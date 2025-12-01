#!/usr/bin/env bash
# ------------------------------------------------------------
# Idempotent provisioning script for an "ansible" user
# ------------------------------------------------------------
# Exit on error, treat unset variables as errors, and fail on pipe errors
set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
    echo "⚠️  This script must be run as root (use sudo)." >&2
    exit 1
fi

# ------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------
log()   { printf '[%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$*"; }
die()   { log "ERROR: $*" >&2; exit 1; }

# ------------------------------------------------------------------
# 1. Update the package index and upgrade the system (once per run)
# ------------------------------------------------------------------
log "Updating package index ..."
apt-get update -qq

log "Performing full upgrade ..."
apt-get full-upgrade -y -qq

# ------------------------------------------------------------------
# 2. Ensure sudo is installed
# ------------------------------------------------------------------
if ! dpkg -s sudo >/dev/null 2>&1; then
    log "Installing sudo ..."
    apt-get install -y sudo
else
    log "sudo already installed"
fi

# ------------------------------------------------------------------
# 3. Create the ansible user (if it does not already exist)
# ------------------------------------------------------------------
USERNAME="ansible"
if id -u "$USERNAME" >/dev/null 2>&1; then
    log "User '$USERNAME' already exists"
else
    log "Creating user '$USERNAME' ..."
    useradd -m -s /bin/bash "$USERNAME"
    # Add to sudo group
    usermod -aG sudo "$USERNAME"
fi

# ------------------------------------------------------------------
# 4. Set up the .ssh directory and authorized_keys (idempotent)
# ------------------------------------------------------------------
SSH_DIR="/home/$USERNAME/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

# Ensure the .ssh directory exists with correct permissions
if [[ ! -d "${SSH_DIR}" ]]; then
    log "Creating ${SSH_DIR} ..."
    mkdir -p "${SSH_DIR}"
    chmod 700 "${SSH_DIR}"
    chown "${USERNAME}:${USERNAME}" "${SSH_DIR}"
else
    log "${SSH_DIR} already exists – fixing permissions just in case."
    chmod 700 "${SSH_DIR}"
    chown "${USERNAME}:${USERNAME}" "${SSH_DIR}"
fi

log "Reading keys"

# Define the keys you want present (one per line)
read -r -d '' REQUIRED_KEYS <<'EOF'
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhjvmvRyaBojmOPhVS2EfmQLBllYVL8bhMRihxGOYqp lxc@debian
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYOk8j2fsAzz+TgYKJOvZtE+ncsj3U/XtQ4d37ql7r0 j.moes01@gmail.com
EOF

# Ensure each required key is present exactly once
log "Creating $AUTH_KEYS ..."
touch "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"
chown "$USERNAME:$USERNAME" "$AUTH_KEYS"

log "Inserting keys ..."
while IFS= read -r key; do
    # Skip empty lines
    [[ -z "$key" ]] && continue
    # Grep -Fxq matches the whole line exactly
    if grep -Fxq "$key" "$AUTH_KEYS"; then
        log "Key already present: $(echo "$key" | awk '{print $2}')"
    else
        log "Adding missing key ..."
        printf '%s\n' "$key" >>"$AUTH_KEYS"
    fi
done <<<"$REQUIRED_KEYS"

# ------------------------------------------------------------------
# 5. Configure password‑less sudo for the ansible user
# ------------------------------------------------------------------
SUDOERS_FILE="/etc/sudoers.d/ansible"
SUDOERS_LINE="ansible ALL=(ALL:ALL) NOPASSWD:ALL"

if [[ -f "$SUDOERS_FILE" ]]; then
    if grep -Fxq "$SUDOERS_LINE" "$SUDOERS_FILE"; then
        log "Sudoers entry already present"
    else
        log "Updating existing sudoers file"
        echo "$SUDOERS_LINE" >>"$SUDOERS_FILE"
    fi
else
    log "Creating sudoers file for $USERNAME"
    echo "$SUDOERS_LINE" >"$SUDOERS_FILE"
fi

# Secure the sudoers fragment (read‑only for root)
chmod 0440 "$SUDOERS_FILE"

# Validate the sudoers configuration before exiting
if visudo -c; then
    log "Sudoers syntax OK"
else
    die "Invalid sudoers configuration – aborting"
fi

log "Provisioning completed successfully"

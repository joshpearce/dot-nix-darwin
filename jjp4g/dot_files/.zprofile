# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# AWS CLI
export AWS_VAULT_PROMPT=ykman
export AWS_VAULT_KEYCHAIN_NAME=aws-vault

# Mac Ports
# export PATH="/opt/local/sudobin:/opt/local/bin:/opt/local/sbin:$PATH"

# Brew
# export PATH="$PATH:/opt/homebrew/bin"

# Secretive Config
export SSH_AUTH_SOCK=/Users/josh/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh

# Yubikey Manager
# export PATH="$PATH:/Applications/YubiKey Manager.app/Contents/MacOS"

# Vault
export VAULT_ADDR='https://vault.jjpdev.com'

# Libpq homebrew keg
# export PATH="$PATH:/opt/homebrew/opt/libpq/bin"

# Dotnet
# export PATH="$PATH:/usr/local/share/dotnet"

# port() { sudo /opt/sudoport "$@"; }; export PATH="/opt/local/sudobin:/opt/local/bin:/opt/local/sbin:$PATH"
# Add Visual Studio Code (code)
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Golang
# export GOPATH=/Users/josh/.go

# Rust
. "$HOME/.cargo/env"

# Set DOTNET_ROOT to the Nix store path
if [[ -d /nix/store ]]; then
  DOTNET_ROOT=$(find /nix/store -maxdepth 1 -name "*dotnet-sdk*" -type d | head -1)
  if [[ -n "$DOTNET_ROOT" ]]; then
    export DOTNET_ROOT="$DOTNET_ROOT"
  fi
fi

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/run/current-system/sw/bin:$PATH"
export PATH="/Users/josh/.local/bin:$PATH"
export PATH="/Users/josh/bin:$PATH"

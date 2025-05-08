# Install Nix with flakes support
sh <(curl -L https://nixos.org/nix/install) --daemon
sudo nix-channel --update

# Enable flakes
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon

# From the jetson-system-config directory:
sudo nix run github:numtide/system-manager#system-manager -- switch --flake .#jetson

# Rerun after editing any of the xavier.nix configs
sudo system-manager switch --flake .#xavier-ironbird
sudo systemctl daemon-reload
sudo systemctl restart systemd-networkd


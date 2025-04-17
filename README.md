# For Jetson (ARM64)
sudo nix run github:numtide/system-manager#system-manager -- \
  switch \
  --flake .#aarch64-linux \
  --impure

# Minimal Nixnas deployment: one host, all three layers.
#
# In a real deployment, fleet.nix and host.nix live in the deployer's
# own repo. Here they sit next to each other so the layering is visible.
{
  description = "Minimal Nixnas deployment: one host, three layers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Points at the real repo; the example stays self-contained for CI.
    nixnas.url = "github:nix8247/Nixnas";
  };

  outputs = {
    nixpkgs,
    nixnas,
    ...
  }: {
    nixosConfigurations.nas01 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Core: the Nixnas project layer (this repo).
        nixnas.nixosModules.default
        # Fleet: shared across this deployer's machines.
        ./fleet.nix
        # Host: this particular box.
        ./host.nix
      ];
    };
  };
}

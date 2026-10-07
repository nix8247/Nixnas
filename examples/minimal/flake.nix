# Minimal Nixnas deployment: one host, all three layers.
#
# In a real deployment, fleet.nix and host.nix live in the deployer's
# own repo. Here they sit next to each other so the layering is visible.
{
  description = "Minimal Nixnas deployment: one host, three layers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Tracks the dev branch while it's the working branch — the example's
    # checks then validate the actual work in progress. When dev is
    # squashed into main, point this back at github:nix8247/Nixnas.
    nixnas.url = "github:nix8247/Nixnas/dev";
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

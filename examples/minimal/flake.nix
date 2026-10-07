# Minimal Nixnas deployment: one host, all three layers.
#
# In a real deployment, fleet.nix and host.nix live in the deployer's
# own repo. Here they sit next to each other so the layering is visible.
{
  description = "Minimal Nixnas deployment: one host, three layers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Local path so the example evaluates from a checkout. Real
    # deployments use: github:nix8247/Nixnas (optionally pinned to a tag).
    # (A relative ../.. doesn't survive flake input resolution, so this
    # is absolute — point it at your own checkout.)
    nixnas.url = "path:/home/hatch/workspace/nixnas";
  };

  outputs = { self, nixpkgs, nixnas, ... }: {
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

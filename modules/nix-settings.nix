# Nix itself: flakes on (the whole update story needs them), and weekly
# garbage collection so the store doesn't grow forever on an always-on box.
{lib, ...}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };
}

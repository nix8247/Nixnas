# Firewall baseline: on by default, with a declared port list.
# Fleet/host open more via `nixnas.firewall.allowedTCPPorts`.
{
  config,
  lib,
  ...
}: let
  cfg = config.nixnas;
in {
  options.nixnas.firewall = {
    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [22];
      description = "TCP ports the firewall lets through (SSH is on by default).";
    };
    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "UDP ports the firewall lets through.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = cfg.firewall.allowedTCPPorts;
      allowedUDPPorts = cfg.firewall.allowedUDPPorts;
    };
  };
}

# Container runtime: Podman is the core's OCI runtime.
# Service definitions use Quadlets (.container files as systemd units).
#
# Open question (not decided yet): rootless vs rootful default.
{lib, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = lib.mkDefault false;
    defaultNetwork.settings.dns_enabled = lib.mkDefault true;
  };
}

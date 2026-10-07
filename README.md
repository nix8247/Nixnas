# Nixnas

An opinionated NixOS core for home servers. One shared definition sets up
a single home server or a small fleet, customized per machine — install
once, then the box keeps itself updated from git.

This is the **core** layer. The deployer's own flake adds the **fleet**
(shared config) and **host** (per-machine) layers on top.

## The three layers

| Layer | Who owns it | What lives there |
|-------|-------------|------------------|
| core  | This repo (the project) | Base system, firewall baseline, SSH, Podman, storage plumbing, pull-based updates. Hardware-agnostic, no exceptions. |
| fleet | Deployer's repo | User profiles, roles hosts opt into, fleet-wide firewall, fleet secrets (encrypted). |
| host  | Deployer's repo | Hostname, `hardware-configuration.nix`, disk layout, drivers, which channel the box tracks, host secrets (encrypted). |

## Using it

In your own flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixnas.url = "github:nix8247/Nixnas";
  };

  outputs = { nixpkgs, nixnas, ... }: {
    nixosConfigurations.myserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixnas.nixosModules.default   # the core
        ./fleet.nix                   # your shared config
        ./host.nix                    # this machine
        ./hardware-configuration.nix  # generated on the box
      ];
    };
  };
}
```

Then in the host config:

```nix
{ ... }:
{
  networking.hostName = "myserver";

  nixnas.admins = [
    { name = "tim"; sshKeys = [ "ssh-ed25519 AAAA... tim@laptop" ]; }
  ];

  # Rolling latest: rebuild from your fleet repo's main branch weekly.
  # Point at a tag for a locked snapshot instead.
  nixnas.updates.flake = "github:you/nixnas-fleet#myserver";
}
```

Importing `nixnas.nixosModules.default` enables the core — there is no
enable flag.

## What's in core

- **Base system** — users (`nixnas.admins`), networking, SSH (key-only,
  no root login).
- **Firewall** — enabled by default. Each feature opens its own ports
  (SSH opens 22); open more with plain
  `networking.firewall.allowedTCPPorts` / `allowedUDPPorts` — NixOS merges
  the lists, so nothing needs to stay in sync.
- **Updates** — pull-based, on a schedule (`nixnas.updates.schedule`,
  default weekly). The box runs `nixos-rebuild switch` against
  `nixnas.updates.flake` — a branch for rolling latest, a tag for a
  locked snapshot. Reboots stay manual; previous generations remain in
  the boot menu as the undo button.
- **Storage** — ZFS / bcachefs / btrfs drivers and tools
  (`zfs`, `bcachefs-tools`, `btrfs-progs`, `mergerfs`, `snapraid`).
  Disk layouts are declared per host.
- **Containers** — Podman enabled (Quadlets for service definitions).
- **Nix** — flakes enabled, weekly garbage collection.

What core will never contain: secrets (it ships the mechanism and docs,
never the values) and anything hardware-specific.

## Module layout

`modules/` holds one file per feature, each self-contained: everything a
feature needs lives in its file (SSH opens its own firewall port; the
firewall module doesn't know SSH exists). `modules/nixnas.nix` is the
entry point — it auto-imports every other `.nix` file next to it, so
adding a feature is just adding a file. No enable flags: importing the
module enables it.

## Example

`examples/minimal` is a complete one-host deployment showing all three
layers. Evaluate it without building:

```sh
nix eval ./examples/minimal#nixosConfigurations.nas01.config.networking.hostName
```

## Design rationale

The planning repo holds the architecture, decisions, and research:
https://github.com/nix8247/Nixnas-plan

The installer ISO (ZFS + bcachefs support, disko auto-deploy) lives in:
https://github.com/nix8247/Nixnas-installer

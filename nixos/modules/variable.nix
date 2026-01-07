{ config, pkgs, ... }:

let
    toml-sys = builtins.fromTOML(builtins.readFile /vault/settings/system.toml);
    toml-pkgs = builtins.fromtTOML(builtins.readFile /vault/settings/packages.toml);
{
    system.stateVersion = toml.sys.system.version;
    system.nixos.label = toml-pkgs.generation-label;
}

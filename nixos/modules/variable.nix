{ config, pkgs, ... }:

let
    toml-settings = builtins.fromTOML(
        builtins.readFile /vault/settings.toml
    );
in {
    system.stateVersion = toml-settings.system.nix-version;
}

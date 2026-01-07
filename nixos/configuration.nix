{ config, lib, pkgs, inputs, user, ... }:

{
    imports = [
        /kanso/nixos/hardware-configuration.nix
        /kanso/nixos/modules/programs.nix
        /kanso/nixos/modules/variable.nix
        /kanso/nixos/modules/service.nix
        /kanso/nixos/modules/users.nix
        /kanso/nixos/modules/kanso.nix
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

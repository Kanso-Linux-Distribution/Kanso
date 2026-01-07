{ config, pkgs, ... }:

let
    toml = builtins.fromTOML(builtins.readFile /vault/settings/system.toml);
    hostname = toml.system.hostname;
    email = toml.system.email;
    version = toml.system.version;
in
{
    home.username = hostname;
    home.homeDirectory = "/home/${hostname}";

    xdg.userDirs = {
        enable = true;
        createDirectories = true;
        download = "${config.home.homeDirectory}/Downloads";    
        videos = "${config.home.homeDirectory}/Videos";    
        pictures = "${config.home.homeDirectory}/Pictures";
        desktop = "${config.home.homeDirectory}/Desktop";    
        documents = null;
        music = null;
        templates = null;
        publicShare = null;
    };
    
    programs.git = {
        enable = true;
        userName = hostname;
        userEmail = email;
        extraConfig = {
            safe.directory = "*";
            core.sharedRepository = "world";
        };
    };
    
    programs.home-manager.enable = true;
    home.stateVersion = version; 
}

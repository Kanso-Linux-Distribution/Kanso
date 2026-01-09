{ config, pkgs, lib, ... }:

let
    toml-settings = builtins.fromTOML(
        builtins.readFile /vault/settings.toml
    );

    username = toml-settings.system.username;
    email = toml-settings.system.email;
    nix-version = toml-settings.system.nix-version;
    env = toml-settings.core.env;
    dotfiles = toml-settings.core.dotfiles;
    
    toml-env = builtins.fromTOML(
        builtins.readFile dotfiles.${env}.path
    );

    terminal = toml-env.TERMINAL;
    user-packages = map(pkg: pkgs.${pkg}) toml-env.PACKAGES;

    all-packages = user-packages ++ [ pkgs.${terminal} ];
in
{    
    programs.home-manager.enable = true;

    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = nix-version;

    home.packages = all-packages;

    home.sessionVariables = {
        EDITOR = toml-env.EDITOR;
        TERMINAL = toml-env.TERMINAL;
    };
    
    # DIRECTORIES IN /home/$USER
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

    xdg.configFile = lib.genAttrs toml-env.CONFIG_LINKS(name: {
        source = config.lib.file.mkOutOfStoreSymlink "/vault/dotfiles/${env}/${name}";
    });
    
    programs.git = {
        enable = true;
        settings = {
            user = {
                email = email;
                name = username;
            };
            
            safe.directory = "*";
            core.sharedRepository = "world";
        };
    };   
}

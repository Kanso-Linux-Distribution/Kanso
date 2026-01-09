{ config, lib, pkgs, ... }:
let
    toml-settings = builtins.fromTOML(
        builtins.readFile /vault/settings.toml
    );

    env = toml-settings.core.env;

    toml-env = builtins.fromTOML(
        builtins.readFile toml-settings.core.dotfiles.${env}.path
    );
    
    timeZone = toml-settings.system.timeZone;
    exec-session = toml-env.EXEC_SESSION;
    compositor = toml-env.COMPOSITOR;
    shell = toml-env.SHELL;
    protocol = toml-env.PROTOCOL;
    terminal = toml-env.TERMINAL;

    cmd =
        if (compositor == "gnome") then (if protocol == "wayland" then "${pkgs.dbus}/bin/dbus-run-session ${pkgs.gnome-session}/bin/gnome-session" else "gnome-xorg")
        else if (compositor == "plasma") then (if protocol == "wayland" then "startplasma-wayland" else "startplasma-x11")
        else if (compositor == "cage") then "cage ${terminal}"
        else if (compositor == "cinnamon") then "${pkgs.dbus}/bin/dbus-run-session ${pkgs.cinnamon-session}/bin/cinnamon-session"
        else compositor;
in {
    # SUDO
    security.sudo.extraConfig = "
        Defaults lecture=\"never\"
    ";
    
    # SHELL
    programs.${shell}.enable = true;
    
    # SYSTEM
    services.dbus.enable = true;
    programs.dconf.enable = true;
    services.displayManager.defaultSession = compositor;

    # LOCK SCREEN
    services.greetd = {
        enable = true;
        settings.default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --user-menu --asterisks --cmd \"${cmd}\"";
            user = "greeter";
        };    
    };
    
    # NETWORK
    networking.wireless.enable = false;
    networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
    };
    networking.wireless.iwd.enable = true;

    # TIME
    services.timesyncd.enable = true;
    time.timeZone = timeZone;

    # AUDIO
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true; 
    };

    # SSH
    services.openssh.enable = true;
    #programs.ssh.startAgent = (compositor != "gnome") && (compositor != "cennamon");
}

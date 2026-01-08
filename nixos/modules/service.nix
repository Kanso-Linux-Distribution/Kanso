{ config, lib, pkgs, ... }:
let
    toml = builtins.fromTOML (builtins.readFile /vault/settings/system.toml);
    timeZone = toml.system.timeZone;

    environment = toml.core.environment;
    default-session = toml.system.default-session;
    start-env-script = toml.core.dotfiles.${environment}.start-env-script;
in {
    # SYSTEM
    services.dbus.enable = true;
    services.displayManager.defaultSession = default-session;

    # LOCK SCREEN
    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd \"${start-env-script}\"";
                user = "greeter";
            };
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
    programs.ssh.startAgent = true;
}

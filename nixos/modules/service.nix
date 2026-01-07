{ config, lib, pkgs, ... }:
let
    toml = builtins.fromTOML (builtins.readFile /vault/settings/system.toml);
    timeZone = toml.system.timeZone;
in {
    # --- Network ---
    networking.wireless.enable = false;
    networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
    };
    networking.wireless.iwd.enable = true;

    # --- Time ---
    services.timesyncd.enable = true;
    time.timeZone = timeZone;

    # --- Sound ---
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true; 
    };

    # --- Access ---
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
}

{ config, pkgs, lib, ... }:

let
  toml-settings = builtins.fromTOML(
    builtins.readFile /vault/settings.toml
  );

  env = toml-settings.core.env;
  dotfiles = toml-settings.core.dotfiles;
  
  toml-env = builtins.fromTOML(
    builtins.readFile dotfiles.${env}.path 
  );

  protocol = toml-env.PROTOCOL;
  compositor = toml-env.COMPOSITOR;
in {
  # X11
  services.xserver = {
    enable = (protocol == "x11");

    desktopManager = {
      cinnamon.enable =   (compositor == "cinnamon");
      xfce.enable =       (compositor == "xfce");
      plasma6.enable =    (compositor == "plasma");
      mate.enable =       (compositor == "mate");
      pantheon.enable =   (compositor == "pantheon");
      lxqt.enable =       (compositor == "lxqt");
    };
    
    windowManager = {
      i3.enable =      (compositor == "i3");
      awesome.enable = (compositor == "awesome");
    };

    displayManager = {
      defaultSession = compositor;
    };
  };
  
  # Wayland/X11 version
  services.xserver.desktopManager.gnome.enable = (compositor == "gnome");

  # Wayland
  programs = {
    hyprland.enable = (compositor == "hyprland");
    sway.enable     = (compositor == "sway");
    river.enable    = (compositor == "river");
    niri.enable     = (compositor == "niri");
  };  

  services.cage.enable = (compositor == "cage");
}

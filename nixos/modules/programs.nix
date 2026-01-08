{ config, pkgs, ... }:

let 
  toml-pkgs = builtins.fromTOML (builtins.readFile /vault/settings/packages.toml);
  userPackages = map (name: pkgs.${name}) toml-pkgs.nixpkgs.packages;

  shell-pkgs = with pkgs; [
    starship
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = shell-pkgs ++ userPackages;
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    promptInit = "eval \"$(starship init zsh)\"";
  };
  
  programs.zoxide.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc zlib glib openssl icu nss nspr curl expat fuse3
    libGL libxkbcommon wayland mesa libdrm
    xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi
    xorg.libXext xorg.libXcomposite xorg.libXdamage xorg.libXfixes
    xorg.libXrender xorg.libXtst cairo pango atk at-spi2-atk
    gdk-pixbuf gtk3 libdbusmenu-gtk3 libpulseaudio alsa-lib
    dbus libusb1
  ];
}


{ config, lib, pkgs, user, ... }:

let
  toml-settings = builtins.fromTOML(
    builtins.readFile /vault/settings.toml
  );

  username = toml-settings.system.username;

  core = toml-settings.core;

  toml-env = builtins.fromTOML(
    builtins.readFile core.dotfiles.${core.env}.path
  );
in {
  nix.settings = {
    trusted-users = ["nix-deamon"];
    allowed-users = ["@wheel" username];
  };
  
  users.mutableUsers = false;

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"   
      "networkmanager"
      "video"  
      "render" 
    ];
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
    shell = pkgs.${toml-env.SHELL};
  };

  users.users.root = {
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
  };
}

{ config, lib, pkgs, user, ... }:

let
  toml = builtins.fromTOML(builtins.readFile /vault/settings/system.toml);
  hostname = toml.system.hostname;
in {
  nix.settings = {
    trusted-users = ["nix-deamon"];
    allowed-users = ["@wheel" hostname];
  };
  
  users.mutableUsers = false;

  users.users.${hostname} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"   
      "networkmanager"
      "video"  
      "render" 
      "docker"
    ];
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
  };

  users.users.root = {
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
  };
}

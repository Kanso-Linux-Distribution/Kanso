{
  description = "Kanso Linux Distro";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    toml = builtins.fromTOML(builtins.readFile /vault/settings/system.toml);
    hostname = toml.system.hostname;
    system = toml.system.platform;
    dotfiles = toml.core.dotfiles;
    environment = toml.core.environment;
  in {
    programs.hyprland.enable = true;
    nixosConfigurations.kanso = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs toml; };
      modules = [
        /kanso/nixos/configuration.nix
        inputs.impermanence.nixosModules.impermanence
        inputs.home-manager.nixosModules.home-manager
        {
          environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs toml; };
          home-manager.users.${hostname} = {
            imports = [
              /kanso/nixos/home.nix
              dotfiles.${environment}.path
            ];
            home.username = hostname;
            home.homeDirectory = "/home/${hostname}";
            home.stateVersion = toml.system.version;
          };
        }
      ];
    };
  };
}

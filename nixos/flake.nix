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
      toml-settings = builtins.fromTOML(
        builtins.readFile /vault/settings.toml
      );
      
      username = toml-settings.system.username;
    in {
      nixosConfigurations.kanso = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          /kanso/nixos/configuration.nix
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
          {
            environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.${username}.imports = [
                /kanso/nixos/home.nix
            ];
          }
        ];
      };
  };
}

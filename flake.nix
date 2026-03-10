{
  description = "Terp's Home Manager Configuration";

  # Inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # This ensures home-manager uses the same nixpkgs as our flake
      # Prevents version mismatches and reduces disk usage
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs 
  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      homeConfigurations = {
        terp = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}

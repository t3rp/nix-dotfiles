{
  description = "T3rp's Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHome = userModule: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ userModule ];
      };
    in
    {
      homeConfigurations = {
        brian = mkHome ./users/brian.nix;
        terp = mkHome ./users/terp.nix;
      };
    };
}

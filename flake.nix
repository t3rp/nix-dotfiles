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
      # USER/HOME come from the invoking shell when run with --impure.
      username =
        let u = builtins.getEnv "USER";
        in if u != "" then u else "terp";
      homeDirectory =
        let h = builtins.getEnv "HOME";
        in if h != "" then h else "/home/${username}";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          # Discord, Zoom, etc
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username homeDirectory;
          };
          modules = [ ./home.nix ];
        };
      };
    };
}

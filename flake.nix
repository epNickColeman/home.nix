{
  description = "Home-manager darwin config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/v1.8";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, devenv }: 
  let
    # User configuration - define your user details here
    user = {
      name        = "nick";
      fullName    = "Nick Coleman";
      email       = "nick.coleman@educationperfect.com";  # Replace with your actual email
      home        = "/Users/nick";
      shell       = "zsh";
      
      # Git-specific configurations
      githubUser  = "epNickColeman";
      gitWorkspaces = {
        "src/ep" = {
          user = {
            email = "nick.coleman@educationperfect.com";
            name = "Nick Coleman";
          };
          core = { autocrlf = "input"; };
        }; 
        # Add more workspaces here as needed
        # "src/personal" = {
        #   user = {
        #     email = "nick.j.coleman@gmail.com";
        #     name = "Nick Coleman";
        #   };
        # };
      };
    };
  in
  {
    darwinConfigurations."Nicks-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs user; };
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.users.${user.name} = ./home;
          home-manager.extraSpecialArgs = { inherit inputs user; };
        }
      ];
    };
  };
}

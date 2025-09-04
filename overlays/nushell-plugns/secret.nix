self: super: {
  nushellPlugins = super.nushellPlugins // {
    secret = super.rustPlatform.buildRustPackage rec {
      pname = "nu_plugin_secret";
      version = "0.6.0";

      src = super.fetchFromGitHub {
        owner = "nushell-works";
        repo = "nu_plugin_secret";
        rev = "v${version}";
        hash = "sha256-SO3MbIw/QVTYGsVY7HjsikkVHeJ4ObC5uHXcqRwAku4="; # Replace with actual hash
      };

      cargoHash = "sha256-EM2KohRalZXbmaKsPGo6Rz1GXOxBARlo2wFph1QMI0g="; # Replace with actual hash

      nativeBuildInputs = with super; [ pkg-config ];
      buildInputs = with super; [ openssl ];

      meta = with super.lib; {
        description = "A nushell plugin to manage secrets";
        homepage = "https://github.com/nushell-works/nu_plugin_secret";
        license = licenses.mit;
        maintainers = [];
        mainProgram = "nu_plugin_secret";
      };
    };
  };
}
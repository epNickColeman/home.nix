self: super: {
  nushellPlugins = super.nushellPlugins // {
    semver = super.nushellPlugins.semver.overrideAttrs (oldAttrs: {
      version = "0.11.14";
      
      src = super.fetchFromGitHub {
        owner = "abusch";
        repo = "nu_plugin_semver";
        tag = "v0.11.14";
        hash = "sha256-mfwgwY/iYdMz8Qn6a9zfpMHWHl2n1Q8ClkT+KiCAGyk=";
      };
      
      cargoHash = "";
      
      meta = oldAttrs.meta // {
        platforms = super.lib.platforms.linux ++ super.lib.platforms.darwin;
      };
    });
  };
}
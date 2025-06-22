{ config, lib, pkgs, ... }:

{
  brews.apps = {
    casks = [
      "1password"
      "brave-browser" # better chrome
      "cursor"
      "discord"
      "dropbox"
      "google-chrome"
      "hiddenbar"
      "iina" # modern video player
      "jetbrains-toolbox"
      "intellij-idea"
      "datagrip"
      "licecap" # animated screenshots
      "notion"
      "notion-calendar"
      "postman"
      "hoppscotch" # postman alternative
      "rider"
      "slack"
      "sublime-text"
      "vlc"
      "warp" # AI-enabled terminal
      "zoom"
      "zed" # code editor
      "mitmproxy"
    ];
  };

  brews.vscode = {
    enable = true;
    extensions = [
        "AdamCaviness.theme-monokai-dark-soda"
        "akamud.vscode-theme-onedark"
        "amazonwebservices.aws-toolkit-vscode"
        "arrterian.nix-env-selector"
        "bbenoist.Nix"
        "bierner.markdown-mermaid"
        "coolbear.systemd-unit-file"
        "donjayamanne.githistory"
        "eamodio.gitlens"
        "giltho.comby-vscode"
        "GitHub.copilot"
        "GraphQL.vscode-graphql-syntax"
        "GraphQL.vscode-graphql"
        "hashicorp.terraform"
        "haskell.haskell"
        "Intility.vscode-backstage"
        "Ionide.Ionide-fsharp"
        "jnoortheen.nix-ide"
        "JozefChmelar.compare"
        "justusadam.language-haskell"
        "kmoritak.vscode-mermaid-snippets"
        "ms-azuretools.vscode-docker"
        "ms-dotnettools.csdevkit"
        "ms-dotnettools.csharp"
        "ms-dotnettools.vscode-dotnet-runtime"
        "ms-dotnettools.vscodeintellicode-csharp"
        "ms-vscode-remote.remote-containers"
        "ms-vscode.makefile-tools"
        "PKief.material-icon-theme"
        "redhat.vscode-yaml"
        "streetsidesoftware.avro"
        "vscode-icons-team.vscode-icons"
        "yzhang.markdown-all-in-one"
        "zxh404.vscode-proto3"
    ];
  };

  brews.rancher = {
    enable = true;
    hostResolver = false;
  };

  brews.cloudflare-warp = {
    enable = true;
  };

  brews.iterm2 = {
    enable = true;
  };

  brews.raycast = {
    enable = true;
  };
 }

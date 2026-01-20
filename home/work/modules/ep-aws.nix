
{ pkgs, config, lib, ... }:

let
  writeScriptDir = path: text:
    pkgs.writeTextFile {
      inherit text;
      executable = true;
      name = builtins.baseNameOf path;
      destination = "${path}";
    };

  epUp = pkgs.writeShellScriptBin "epup" ''
    set -e

    if ! aws sts get-caller-identity &> /dev/null; then
      aws sso login --sso-session ep
    fi
    aws ecr get-login-password --region ap-southeast-2 --profile ecr | docker login --username AWS --password-stdin 058337015204.dkr.ecr.ap-southeast-2.amazonaws.com

    docker compose up -d "$@"
  '';

  epLogin = pkgs.writeShellScriptBin "eplogin" "aws sso login --sso-session ep";

in {
  home.packages = with pkgs; [
    awscli2
    epUp
    epLogin
  ];
}

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal nix-darwin + home-manager configuration for macOS (aarch64-darwin). Uses Nix Flakes to declaratively manage system configuration, user environment, development tools, and application settings.

## Build Command

```bash
sudo darwin-rebuild switch --flake .
```

All changed files must be `git add`ed before building — Nix flakes only sees git-tracked files.

First-time install uses:
```bash
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/master#darwin-rebuild -- switch --flake .
```

There are no tests or linters. Validation happens at build time via `darwin-rebuild switch`.

## Architecture

**Entry point:** `flake.nix` defines inputs (nixpkgs-unstable, nix-darwin, home-manager, devenv), user config, and wires everything together. User details (name, email, git workspaces) are defined in the `user` attrset in `flake.nix`.

**Two configuration layers:**
- `darwin-configuration.nix` — system-level macOS config (nix settings, shell, keyboard, homebrew, environment)
- `home/default.nix` — user-level config via home-manager (shell setup, programs, tools, session variables)

**Module system (`lib/modules.nix`):** Auto-discovers and imports `.nix` files from directories. Key functions:
- `mapModules` / `mapModulesRec'` — recursively find and import modules
- `discoverOverlays` — auto-discover overlays from `overlays/` directory
- `importDarwinModules` — load modules using their `systemConfig` section
- `importHomeModules` — load modules using their `userConfig` section
- Shared libraries in `lib/shared/` are auto-discovered and merged into `lib`

**Directory layout:**
- `home/` — home-manager config: shell, programs, packages
- `home/modules/tools/` — modular tool configs (git, aws, dotnet, dasel, skim, haskell)
- `home/modules/secureEnv/` — 1Password integration for secrets → Keychain
- `home/work/` — work-specific config (EP nuget, tokens, work packages)
- `darwin/` — macOS system preferences, dock, spotlight
- `brews/` — Homebrew-managed apps and per-app config (VSCode extensions, Rancher, iTerm2)
- `overlays/` — custom package overlays (auto-discovered by flake.nix)

## Key Patterns

**Adding a new tool module:** Create a `.nix` file in `home/modules/tools/`. It will be auto-discovered. Modules can define `options` and either `systemConfig` or `userConfig` sections depending on context.

**Adding an overlay:** Place a `.nix` file (or directory with `default.nix`) in `overlays/`. It's auto-discovered by `discoverOverlays` in `flake.nix`. Each overlay is a standard nixpkgs overlay function `final: prev: { ... }`.

**Homebrew apps:** Managed declaratively in `brews/apps.nix`. Per-app configuration modules go in `brews/modules/`.

**Secrets:** Managed via `secureEnv.onePassword` — secrets are pulled from 1Password and stored in macOS Keychain, then exported as environment variables. Never stored on disk unencrypted. Work secrets are in `home/work/default.nix`.

**Git workspaces:** Configured in `flake.nix` under `user.gitWorkspaces`. Allow per-directory git config (different email/settings for work vs personal).

## Nix Conventions

- `nixpkgs` follows the unstable channel
- `config.allowUnfree = true`
- Directories prefixed with `_` are excluded from module auto-discovery
- A directory's `default.nix` is its entry point; other `.nix` files in the same directory are discovered as sibling modules
- State versions: darwin = 5, home-manager = 25.05

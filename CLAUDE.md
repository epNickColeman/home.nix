# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal nix-darwin + home-manager configuration for macOS (aarch64-darwin). Uses Nix Flakes to declaratively manage system configuration, user environment, development tools, and application settings.

## Build Command

```bash
sudo darwin-rebuild switch --flake .
```

All changed files must be `git add`ed before building — Nix flakes only sees git-tracked files.

There are no tests or linters. Validation happens at build time via `darwin-rebuild switch`.

## Architecture

**Entry point:** `flake.nix` defines inputs (nixpkgs-unstable, nix-darwin, home-manager, devenv) and the `user` attrset (name, email, git workspaces). The `user` record is passed to all modules via `specialArgs`/`extraSpecialArgs`, so any module can access `user.name`, `user.email`, etc.

**Two configuration layers:**
- `darwin-configuration.nix` — system-level: nix settings, shell, keyboard, homebrew, environment. Imports from `darwin/` (via `importAllModules`) and `brews/` (via `importDarwinModules`).
- `home/default.nix` — user-level via home-manager: shell, programs, tools. Imports from `home/modules/` (via `importAllModules`) and `brews/` (via `importHomeModules`).

**Module system (`lib/modules.nix`):** Auto-discovers and imports `.nix` files from directories.
- `importAllModules` — standard single-context module discovery
- `importDarwinModules` / `importHomeModules` — for dual-context modules; extracts the `systemConfig` or `userConfig` section respectively
- `discoverOverlays` — auto-discover overlays from `overlays/`
- Shared libraries in `lib/shared/` are auto-discovered and merged into `lib` (e.g., `lib.plists.merge`)

**Directory layout:**
- `home/modules/tools/` — modular tool configs (git, aws, dotnet, dasel, skim, haskell)
- `home/modules/secureEnv/` — 1Password → Keychain → environment variable secrets
- `home/work/` — work-specific config and secrets
- `darwin/` — macOS system preferences, dock, spotlight
- `brews/` — Homebrew-managed apps with dual-context modules
- `overlays/` — custom package overlays (auto-discovered)

## Key Patterns

**Standard tool modules** (`home/modules/tools/`): Single-context home-manager modules. Define `options` under a namespace (e.g., `tools.git`) with an `enable` option, then `config = mkIf cfg.enable { ... }` for `programs.*`, `home.packages`, etc. Auto-discovered — just create a `.nix` file.

**Dual-context modules** (`brews/modules/`): For apps needing both system and user config. These define `systemConfig` (homebrew casks, system env) and `userConfig` (activation scripts, session variables) sections. Both `darwin-configuration.nix` and `home/default.nix` import from `brews/`, each extracting their respective section.

**Activation scripts:** Used in `userConfig` for imperative setup (e.g., configuring app settings). Pattern:
```nix
home.activation.myScript = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  $DRY_RUN_CMD command-here
'';
```

**Overlays:** Place a `.nix` file (or directory with `default.nix`) in `overlays/`. Standard `final: prev: { ... }` format. Flake inputs are available as `pkgs.inputs` via `inputsOverlay`.

**Homebrew:** Managed declaratively. `brews/apps.nix` defines the app list options. `homebrew.onActivation.cleanup = "zap"` means apps not declared in config get removed on rebuild.

**Secrets:** `secureEnv.onePassword` fetches from 1Password, stores in macOS Keychain, exports as session variables via shell command substitution. Never on disk unencrypted.

**Adding packages:** Simple packages go in `home/packages.nix` as entries in `home.packages`. Tools needing configuration get their own module in `home/modules/tools/`. Homebrew casks go in `brews/apps.nix` or a dual-context module in `brews/modules/`.

## Nix Conventions

- `nixpkgs` follows the unstable channel
- `config.allowUnfree = true`
- Directories prefixed with `_` are excluded from module auto-discovery
- A directory's `default.nix` is its entry point; other `.nix` files in the same directory are discovered as sibling modules
- State versions: darwin = 5, home-manager = 25.05

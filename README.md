# dvim

Neovim configuration, packaged as a self-contained Nix flake.

Runs as `dvim` with `NVIM_APPNAME=dvim` so it never conflicts with a system `nvim`.

## Usage

### Run directly

```bash
nix run github:DanijelMi/neovim
```

### Install via `nix profile`

```bash
nix profile install github:DanijelMi/neovim
```

### Home Manager (recommended)

Add to your flake inputs and import the module:

```nix
# flake.nix
inputs = {
  dvim.url = "github:DanijelMi/neovim";
  dvim.inputs.nixpkgs.follows = "nixpkgs";
};
```

Import the module in your Home Manager configuration:

```nix
imports = [ inputs.dvim.homeManagerModules.default ];
```

Then enable it in your Home Manager config:

```nix
programs.dvim.enable = true;
```

## Home Manager Module Options

### `programs.dvim.enable`

**Type:** `bool`  
**Default:** `false`

Enables dvim. Adds the `dvim` binary to `home.packages` with all bundled tools available on its PATH.

### `programs.dvim.neovide.enable`

**Type:** `bool`  
**Default:** `false`

Installs the [Neovide](https://neovide.dev) GUI frontend and configures it.

## Bundled Tools

All tools below are added to `dvim`'s `PATH` at build time. They are not added to the system PATH.

### LSP Servers

| Package | Purpose |
|---------|---------|
| `nixd` | Nix |
| `lua-language-server` | Lua |
| `basedpyright` | Python |
| `bash-language-server` | Bash/Shell |
| `shellcheck` | Bash linting (bash-language-server dep) |
| `terraform-ls` | Terraform / OpenTofu |
| `yaml-language-server` | YAML |
| `marksman` | Markdown |
| `vscode-langservers-extracted` | JSON, HTML, CSS, ESLint |
| `gitlab-ci-ls` | GitLab CI |
| `harper` | English grammar |

### Formatters & Linters

| Package | Purpose |
|---------|---------|
| `stylua` | Lua formatter |
| `nixfmt` | Nix formatter |
| `ruff` | Python linter and formatter |
| `shfmt` | Shell formatter |
| `shellharden` | Shell linter |
| `prettier` | Multi-language formatter |
| `yamlfmt` | YAML formatter |
| `markdownlint-cli` | Markdown linter |
| `checkmake` | Makefile linter |
| `vale` | Prose linter |
| `commitlint` | Commit message linter\* |

\* `commitlint` requires a manually configured ruleset. See [commitlint docs](https://commitlint.js.org/). The conventional commits ruleset can be installed via npm: `npm set prefix ~/.local/lib && npm install -g @commitlint/config-conventional`

### Tools

| Package | Purpose |
|---------|---------|
| `tree-sitter` | Treesitter parser compilation |
| `imagemagick` | Image rendering (image.nvim) |
| `fzf` | Fuzzy finder |
| `fd` | Fast file finder |
| `ripgrep` | Fast grep |
| `bat` | Syntax-highlighted pager |
| `zoxide` | Smarter `cd` |
| `delta` | Enhanced git diffs |
| `difftastic` | Structural diffs |
| `deno` | Markdown preview |
| `trivy` | Vulnerability scanner |
| `terraform` | Terraform CLI (BSL license) |
| `tflint` + `tflint-ruleset-aws` | Terraform linter with AWS rules |

### Lua Packages

| Package | Purpose |
|---------|---------|
| `magick` | Image manipulation (image.nvim) |

## tflint Configuration

A `tflint.hcl` config enabling the `terraform` and `aws` plugins is generated at build time and set via `TFLINT_CONFIG_FILE`. The AWS plugin version is pinned to whatever version is in the nixpkgs revision used by this flake.

## Flake Outputs

| Output | Description |
|--------|-------------|
| `packages.<system>.default` | The `dvim` wrapper script |
| `apps.<system>.default` | `nix run` entry point |
| `homeManagerModules.default` | Home Manager module with `programs.dvim` options |

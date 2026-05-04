[doc('List just options')]
default:
    @just --list

[doc('Build neovim')]
build:
    nix build

[doc('Build and run neovim')]
run:
    nix run

[doc('Update the flake lock file')]
update:
    nix flake update

config := justfile_directory()

[doc('Fast startup check — runs headless against local source without a nix build')]
check:
    @echo "Testing local config..."
    @nvim=$(grep -o '/nix/store[^ ]*/bin/nvim' $(which dvim)) && \
     NVIM_APPNAME=dvim "$nvim" --headless --cmd "set rtp^={{ config }}" -u {{ config }}/init.lua -c "qa" && echo "OK"

[doc('Full build then startup check against the built store path')]
test:
    @echo "Building..."
    @nix build
    @echo "Testing built config..."
    @./result/bin/dvim --headless -c "qa" && echo "OK"


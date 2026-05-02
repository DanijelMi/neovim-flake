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


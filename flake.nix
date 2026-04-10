{
  description = "dvim - Dane's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          configDir = pkgs.stdenv.mkDerivation {
            name = "dvim";
            src = ./.;
            installPhase = ''
              cp -r . $out
            '';
          };

          nvim-wrapped = pkgs.writeShellScriptBin "nvim" ''
            export NVIM_APPNAME="dvim"
            exec ${pkgs.neovim}/bin/nvim \
              --cmd "set rtp+=${configDir}" \
              -u ${configDir}/init.lua "$@"
          '';
        in
        {
          default = {
            type = "app";
            program = "${nvim-wrapped}/bin/nvim";
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          configDir = pkgs.stdenv.mkDerivation {
            name = "dvim";
            src = ./.;
            installPhase = ''
              cp -r . $out
            '';
          };

          nvim-wrapped = pkgs.writeShellScriptBin "nvim" ''
            export NVIM_APPNAME="dvim"
            exec ${pkgs.neovim}/bin/nvim \
              --cmd "set rtp+=${configDir}" \
              -u ${configDir}/init.lua "$@"
          '';
        in
        {
          default = nvim-wrapped;
        }
      );
    };
}

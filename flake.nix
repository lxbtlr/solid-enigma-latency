{
  description = "A Nix-flake-based C/C++ development environment";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let

        name = "Latency";        

        pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShells.default = pkgs.mkShell.override {
          # Override stdenv in order to change compiler:
          stdenv = pkgs.clangStdenv;
        }{
          packages = with pkgs; [
            (python311.withPackages (ps: [
              ps.numpy
              ps.pandas
              ps.matplotlib
              ps.seaborn
              ps.scipy
              ps.networkx
            ]))
            gdb
            gcc
            asmjit
            llvmPackages_16.libstdcxxClang
            clang-tools_16
            clang
            cmake
            codespell
            conan
            cppcheck
            doxygen
            gtest
            lcov
            vcpkg
            vcpkg-tool
            poppler_utils
            valgrind
            gnuplot
            #]{ pkgs = nixpkgs.legacyPackages.${system}; };
            ];
        buildInputs = [pkgs.clang-tools];
        shellHook = ''
          export YEL='\033[1;33m'
          export RED='\033[0;31m'
          export NC='\033[0m'
          cd src/
          make clean -s
          cd -
          PATH="${pkgs.clang-tools}/bin:$PATH"
          echo -e "\t\t#$YEL Now in ${name} Shell$NC #"
          git status -s
        '';
          
          };

      }
    );
}

#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash
set -eux

nix-build -A "libcpucycles"
nix-build -I nixpkgs=$PWD -E 'with import <nixpkgs> {}; libcpucycles.override({stdenv = clangStdenv;})'
nix-build -A "pkgsCross.aarch64-multiplatform.libcpucycles"
nix-build -I nixpkgs=$PWD -E 'with import <nixpkgs> {}; pkgsCross.aarch64-multiplatform.libcpucycles.override({stdenv = clangStdenv;})'


#!/bin/sh

pushd ~/nixos-config
sudo nixos-rebuild switch --flake .#
git add *
git commit -m "new gen"
git push
popd

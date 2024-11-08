#!/bin/sh

pushd ~/nixos-config
sudo nixos-rebuild switch --flake .#
git add *
git rm $(git ls-files --deleted)
git commit -m "new gen"
git push
popd

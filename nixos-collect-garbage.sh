#!/bin/sh

sudo nix-collect-garbage -d
sudo /run/current-system/bin/switch-to-configuration boot

#!/bin/sh
set -e

sudo pacman -S --needed --noconfirm rust nodejs jdk-openjdk go dotnet-sdk aspnet-runtime 
sudo pacman -S --needed --noconfirm openssh git github-cli bat uv

#!/bin/bash
sleep 60
echo $HOME
echo "Updating packages ..."
sudo apt update
sudo apt upgrade -y
echo $HOME

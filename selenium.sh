#!/usr/bin/env bash

gem install selenium-webdriver headless

mkdir /tmp/.X11-unix
sudo chmod 1777 /tmp/.X11-unix
sudo chown root /tmp/.X11-unix/

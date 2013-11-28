#!/bin/bash

synclient TouchpadOff=1
#xgamma -gamma .7
#xgamma -ggamma .75
echo 4000 | sudo tee /sys/class/backlight/intel_backlight/brightness


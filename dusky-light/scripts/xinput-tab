#!/bin/bash

idd=$(xinput --list | grep 'AlpsPS/2 ALPS GlidePoint' | awk '{print $6}'| cut -d'=' -f2)

propid=$(xinput list-props $idd | grep 'Tapping Enabled' | awk '{print $4}' |sed 's/[^0-9]*//g' )
xinput --set-prop $idd $propid 1 

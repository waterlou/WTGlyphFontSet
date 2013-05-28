#!/bin/bash

TTFNAME="mainicon"

fontcustom compile svg -o ttf -n $TTFNAME
coffee ttfcss2plist.coffee < ttf/fontcustom.css > $TTFNAME.plist
cp ttf/*.ttf $TTFNAME.ttf

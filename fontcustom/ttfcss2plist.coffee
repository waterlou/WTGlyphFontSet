#!/usr/bin/env coffee

carrier = require('carrier')

re = /.icon-([^:]+):before\s*{\s*content:\s*"\\+([a-f0-9]+)";\s*}/
reb = /^.icon/

console.log '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
'
my_carrier = carrier.carry process.stdin

lines = ""

my_carrier.on 'line', (line) ->
  if line.match(reb)?
    lines = line
  else
    lines += line
  ret = lines.match(re)
  if ret?
    console.log "<key>#{ret[1]}</key><string>&#x#{ret[2]};</string>"
    lines = ""
	  
my_carrier.on 'end', ->
  console.log '</dict></plist>'

process.stdin.resume()

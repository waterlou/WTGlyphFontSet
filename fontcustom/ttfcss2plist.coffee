carrier = require('carrier')

re = /^.icon-([^:]+):before { content: "\\([a-f0-9]+)"; }/

console.log '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
'
my_carrier = carrier.carry process.stdin
my_carrier.on 'line', (line) ->
	ret = line.match(re)
	console.log "<key>#{ret[1]}</key><string>&#x#{ret[2]};</string>" if ret?
my_carrier.on 'end', ->
	console.log '</dict></plist>'

process.stdin.resume()

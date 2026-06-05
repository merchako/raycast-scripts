#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Mimestream Links
# @raycast.mode silent

# Optional parameters:
# @raycast.packageName Mimestream
# @raycast.icon ✉️

# Documentation:
# @raycast.description Copy the current Mimestream message's links to the clipboard as Markdown: [Mimestream](…) · [Gmail](…)
# @raycast.author Alex Mercado
# @raycast.authorURL https://github.com/merchako

tell application "System Events"
	tell application "Mimestream" to activate
	delay 0.1

	-- ⌘⌥L = "Copy Link" (Mimestream deep link); key code 37 is L
	key code 37 using {command down, option down}
end tell

delay 0.2
set mimestreamLink to the clipboard

tell application "System Events"
	-- ⌘⇧L = "Copy Gmail Link"; key code 37 is L
	key code 37 using {command down, shift down}
end tell

delay 0.2
set gmailLink to the clipboard

if mimestreamLink is "" or gmailLink is "" then
	display notification "Could not read one or both Mimestream links" with title "Mimestream Links"
	return
end if

set mdText to "[Mimestream](" & mimestreamLink & ") · [Gmail](" & gmailLink & ")"
set the clipboard to mdText

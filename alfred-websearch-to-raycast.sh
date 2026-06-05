#!/bin/bash

# Hardcoded paths to Alfred configuration (common macOS locations)
ALFRED_PREFS="${ALFRED_PREFS:-~/Library/Application Support/Alfred/Alfred.alfredpreferences/workflows}"
WEB_SEARCH_PREFS="$HOME/Library/Application Support/Alfred/Preferences/Features/WebSearch.plist"

# Output file for Raycast Quicklinks JSON
OUTPUT="raycast-quicklinks.json"

# Check if plist file exists
if [[ ! -f "$WEB_SEARCH_PREFS" ]]; then
  echo "Error: Alfred Web Search prefs not found at $WEB_SEARCH_PREFS" >&2
  exit 1
fi

# Convert plist to JSON using plutil, then use jq to transform into Raycast Quicklinks format
plutil -convert json -o - "$WEB_SEARCH_PREFS" | \
jq -r '.CustomSearches // [] | map(
  {
    name: (.Title // "Untitled"),
    keyword: (.Keyword // ""),
    url: (.SearchURL // "" | gsub("\\{query\\}"; "%s"))
  }
) | {
  quicklinks: .
}' > "$OUTPUT"

echo "Converted Alfred web searches to Raycast Quicklinks JSON: $OUTPUT"
echo "Import into Raycast: Raycast > Extensions > Quicklinks > Import JSON"

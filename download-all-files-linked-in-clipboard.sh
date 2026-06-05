#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Download Clipboard Media
# @raycast.mode fullOutput
# @raycast.icon 📥
# @raycast.packageName Custom Scripts

# Documentation:
# @raycast.description Downloads images/videos from links in clipboard content to ~/Downloads
# @raycast.description Look at whatever text is on the clipboard and download any files linked to in it. 
# @raycast.author Merchako
# @raycast.authorURL https://raycast.com/Merchako


# Get clipboard content as plain text (handles markdown, HTML, rich text)
clip_content=$(pbpaste)

# Downloads folder
downloads_dir="$HOME/Downloads/ClipboardMedia-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$downloads_dir"

# Counter for downloaded files
count=0

# Regex patterns for common image/video URLs
patterns=(
    'https?://[^\s<>"]*\.(jpg|jpeg|png|gif|webp|bmp|svg|avif)'
    'https?://[^\s<>"]*\.(mp4|webm|mov|avi|mkv|flv|wmv)'
    'https?://[^\s<>"]*/img[^\s<>"]*\.(jpg|jpeg|png|gif|webp)'
    'https?://[^\s<>"]*/image[^\s<>"]*\.(jpg|jpeg|png|gif|webp)'
    'https?://[^\s<>"]*/video[^\s<>"]*\.(mp4|webm|mov)'
    'https?://[^\s<>"]*\.(jpg|jpeg|png|gif|webp|mp4|webm)[^\s<>"]*'
)

echo "📋 Scanning clipboard content for media links..."

# Extract URLs using multiple patterns
while IFS= read -r url; do
    if [[ "$url" =~ ^https?:// ]]; then
        filename=$(basename "$url" | sed 's/%[0-9a-fA-F][0-9a-fA-F]/_/g' | sed 's/[^a-zA-Z0-9._-]/_/g')
        if [[ -z "$filename" ]]; then
            filename="media_$(date +%s)_${count}"
        fi
        
        # Determine extension
        ext="${filename##*.}"
        if [[ ! "$ext" =~ ^(jpg|jpeg|png|gif|webp|bmp|svg|mp4|webm|mov|avi|mkv|flv|wmv)$ ]]; then
            filename="${filename%.*}_media.${ext:-png}"
        fi
        
        filepath="$downloads_dir/$filename"
        
        echo "⬇️  Downloading: $url -> $filename"
        curl -sL --max-time 30 -o "$filepath" "$url" && {
            count=$((count + 1))
            echo "✅ Saved: $filename"
        } || echo "❌ Failed: $filename"
    fi
done < <(
    echo "$clip_content" | 
    grep -oiE "$(printf '%s|' "${patterns[@]}")" | 
    grep -o 'https?://[^[:space:]]\+' | 
    sort -u
)

# Summary
if [[ $count -gt 0 ]]; then
    echo "🎉 Downloaded $count files to: $downloads_dir"
    open "$downloads_dir"
else
    echo "ℹ️  No media links found in clipboard"
fi

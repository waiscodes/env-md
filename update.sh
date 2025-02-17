#!/bin/bash

# Hash book/toc.js
# Rename toc.js to toc-<hash>.js
# Update all mentions of toc.js inside book to toc-<hash>.js

# Calculate MD5 hash of toc.js and take first 10 characters
HASH=$(md5sum book/toc.js | cut -d ' ' -f 1 | cut -c1-10)

# Create new filename with hash
NEW_FILENAME="toc-${HASH}.js"

# Rename the file
mv book/toc.js "book/${NEW_FILENAME}"

# Find and replace all occurrences of toc.js in html/htm files
find book -type f \( -name "*.html" -o -name "*.htm" \) -exec sed -i "s/toc\.js/${NEW_FILENAME}/g" {} +

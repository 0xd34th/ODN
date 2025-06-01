#!/bin/bash

# Output log file
LOG_FILE="upload_log.txt"
ERROR_LOG="upload_errors.txt"

# Empty the log file on each run
> "$LOG_FILE"
> "$ERROR_LOG"

for filename in *.txt; do
    echo "📦 Uploading $filename"

    # Call Sui client and capture output as JSON
    RESPONSE=$(sui client call \
        --function new \
        --module traits \
        --package 0xd6feaf4699c10bf07872e23cb1bf019068f26ce8b0a74692dd837f33f1061bbc \
        --args "$(cat "$filename")" \
        --json 2>/dev/null)

    # Validate and parse response
    if echo "$RESPONSE" | jq -e . > /dev/null 2>&1; then
        OBJECT_ID=$(echo "$RESPONSE" | jq -r '.effects.created[0].reference.objectId')
        DIGEST=$(echo "$RESPONSE" | jq -r '.effects.created[0].reference.digest')
        echo "✅ Saved: $filename → $OBJECT_ID" | tee -a "$LOG_FILE"
    else
        echo "❌ Failed to parse JSON for $filename" | tee -a "$ERROR_LOG"
        echo "Raw output:" >> "$ERROR_LOG"
        echo "$RESPONSE" >> "$ERROR_LOG"
        echo "---" >> "$ERROR_LOG"
    fi
done

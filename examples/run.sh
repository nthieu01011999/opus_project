#!/bin/bash

# Input binary Opus file (change this to your actual file)
INPUT_FILE="output.opus"
# Size of each split file (adjust as needed)
CHUNK_SIZE="160"
# Output file prefix
OUTPUT_PREFIX="split/sample-"

# Split the binary Opus file into chunks of specified size
split -b $CHUNK_SIZE $INPUT_FILE temp_

# Counter for naming output files
count=0

# Loop through the generated split files and rename them
for file in temp_*; do
    # Rename the split file to the desired format
    mv "$file" "${OUTPUT_PREFIX}${count}.opus"
    # Increment the counter
    ((count++))
done

echo "Splitting complete. Output files are named as ${OUTPUT_PREFIX}0.opus, ${OUTPUT_PREFIX}1.opus, etc."


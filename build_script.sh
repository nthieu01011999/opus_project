#!/bin/bash

TARGET_DIR="/home/it/Desktop/libdatachannel/examples/streamer/samples/opus"
SOURCE_DIR="/home/it/Desktop/opus_project/examples"

# Step 1: Clear the screen and build the project
clear
make clean && make -j4

# Navigate to the examples directory to run the opusenc_example
cd /home/it/Desktop/opus_project/examples

# Run the application file with specified arguments
./opusenc_example test_8kHz_2ch.pcm sample

# Step 2: Check if the target folder is empty or not; if not empty, delete all files in it
if [ -d "$TARGET_DIR" ]; then
    if [ "$(ls -A $TARGET_DIR)" ]; then
        echo "Directory $TARGET_DIR is not empty. Deleting all files..."
        rm -rf "$TARGET_DIR"/*
    else
        echo "Directory $TARGET_DIR is empty."
    fi
else
    echo "Directory $TARGET_DIR does not exist. Creating directory..."
    mkdir -p "$TARGET_DIR"
fi

# Step 3: Check if there are files starting with 'sample' in the source directory and move them
if [ -d "$SOURCE_DIR" ]; then
    # Check if there are any files beginning with 'sample' in the source directory
    if ls "$SOURCE_DIR"/sample* 1> /dev/null 2>&1; then
        echo "Moving files starting with 'sample' from $SOURCE_DIR to $TARGET_DIR..."
        mv "$SOURCE_DIR"/sample* "$TARGET_DIR"
        echo "Files moved successfully."
    else
        echo "No files starting with 'sample' found in $SOURCE_DIR. Interrupting script."
        exit 1
    fi
else
    echo "Source directory $SOURCE_DIR does not exist."
    exit 1
fi

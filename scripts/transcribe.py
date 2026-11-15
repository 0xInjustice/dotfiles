#!/usr/bin/env python3

import whisper
import math
import argparse

# 1. Listen for terminal arguments
parser = argparse.ArgumentParser(description="Transcribe audio to timestamped text.")
parser.add_argument("input", help="Path to the audio file (e.g., audio.wav)")
parser.add_argument("output", help="Path to save the text file (e.g., output.txt)")
args = parser.parse_args()

# 2. Load the AI model
print("Loading model...")
model = whisper.load_model("base")

# 3. Transcribe the dynamic input file (forcing 32-bit math for stability)
print(f"Transcribing '{args.input}'...\n")
result = model.transcribe(args.input, fp16=False)

# 4. Format the data and write it to the dynamic output file
with open(args.output, "w", encoding="utf-8") as file:
    for segment in result["segments"]:
        start_seconds = math.floor(segment["start"])
        
        # Calculate minutes and remaining seconds
        minutes = start_seconds // 60
        seconds = start_seconds % 60
        
        # Construct the exact layout
        formatted_line = f"[{minutes:02d}:{seconds:02d}] {segment['text'].strip()}"
        
        # Print to terminal for visual feedback, and save to the text file
        print(formatted_line)
        file.write(formatted_line + "\n")

print(f"\nSuccess! Transcript saved to: {args.output}")

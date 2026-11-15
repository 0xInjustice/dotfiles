#!/usr/bin/env python3

import numpy as np
import scipy.io.wavfile
import re
import argparse
from pocket_tts import TTSModel

# Attempt to load NLTK for better sentence splitting (handles "Mr.", "Dr." etc.)
try:
    import nltk
    nltk.download('punkt', quiet=True)
    try:
        nltk.download('punkt_tab', quiet=True)
    except:
        pass
    USE_NLTK = True
except ImportError:
    USE_NLTK = False
    print("Note: 'nltk' not found. Falling back to basic regex for sentence splitting.")
    print("To improve splitting on abbreviations, run: pip install nltk")


def generate_voiceover(input_filename, output_filename):

    # 1. Read the input script
    try:
        with open(input_filename, "r", encoding="utf-8") as file:
            raw_script = file.read()
    except FileNotFoundError:
        print(f"Error: Input file '{input_filename}' not found.")
        return
    except Exception as e:
        print(f"Error reading input file: {e}")
        return

    if not raw_script.strip():
        print("Error: Input text file is empty.")
        return

    # 2. Initialize TTS Engine
    print("Loading TTS Engine...")
    tts_model = TTSModel.load_model()

    # Set voice
    voice_state = tts_model.get_state_for_audio_prompt("george")

    # 3. Parse text into sentences
    flat_text = raw_script.replace("\n", " ")

    if USE_NLTK:
        chunks = nltk.sent_tokenize(flat_text)
    else:
        chunks = re.split(r"(?<=[.!?])\s+", flat_text)
        
    chunks = [c.strip() for c in chunks if c.strip()]

    print(f"Found {len(chunks)} sentences.")

    # 4. Create silence between sentences
    sample_rate = tts_model.sample_rate
    silence_duration_sec = 0.5

    silence_array = np.zeros(
        int(sample_rate * silence_duration_sec),
        dtype=np.float32
    )

    audio_pieces = []

    # 5. Generate audio
    for i, chunk in enumerate(chunks):

        print(f"Synthesizing sentence {i + 1}/{len(chunks)}: {chunk[:50]}...")

        try:
            audio_tensor = tts_model.generate_audio(
                voice_state,
                chunk
            )

            # Flatten the array to prevent 1D vs 2D concatenation errors
            audio_array = audio_tensor.numpy().flatten()
            audio_pieces.append(audio_array)

            # Don't add silence after the final sentence
            if i < len(chunks) - 1:
                audio_pieces.append(silence_array)

        except Exception as e:
            print(f"Error synthesizing sentence {i + 1}: {e}")
            return

    # 6. Stitch audio together
    print("Stitching audio blocks together...")
    final_audio = np.concatenate(audio_pieces)

    # 7. Normalize audio to prevent clipping distortion
    max_amplitude = np.max(np.abs(final_audio))
    if max_amplitude > 1.0:
        print("Normalizing audio levels to prevent clipping...")
        final_audio = final_audio / max_amplitude

    # 8. Save WAV
    try:
        scipy.io.wavfile.write(
            output_filename,
            sample_rate,
            final_audio
        )

        print("\nSuccess!")
        print(f"Input : {input_filename}")
        print(f"Output: {output_filename}")

    except Exception as e:
        print(f"Error saving audio: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate a voiceover WAV file using Pocket TTS."
    )

    parser.add_argument(
        "input_file",
        help="Input text file containing the script"
    )

    parser.add_argument(
        "output_file",
        help="Output WAV filename"
    )

    args = parser.parse_args()

    generate_voiceover(
        args.input_file,
        args.output_file
    )


if __name__ == "__main__":
    main()

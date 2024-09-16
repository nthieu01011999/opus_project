#include <stdio.h>
#include <stdlib.h>
#include "opusenc.h"

#define READ_SIZE 256

// Function to create and initialize a new encoder with the next file name
void create_new_encoder(const char *prefix, int index, OggOpusEnc **encoder, OggOpusComments *comments, int *error) {
    char output_file[256];
    sprintf(output_file, "%s-%d.opus", prefix, index);  // Create a new file name (e.g., sample-0.opus)
    *encoder = ope_encoder_create_file(output_file, comments, 8000, 2, 0, error);
    if (!(*encoder)) {
        fprintf(stderr, "Error creating encoder for file %s: %s\n", output_file, ope_strerror(*error));
        ope_comments_destroy(comments);
        exit(1);
    }
}

int main(int argc, char **argv) {
    FILE *fin;
    OggOpusEnc *enc;
    OggOpusComments *comments;
    int error;
    int max_samples_per_file = 5000; // Define how many samples per output file
    int samples_written = 0;
    int file_index = 0;

    if (argc != 3) {
        fprintf(stderr, "usage: %s <raw pcm input> <Ogg Opus output prefix>\n", argv[0]);
        return 1;
    }

    fin = fopen(argv[1], "rb");
    if (!fin) {
        fprintf(stderr, "cannot open input file: %s\n", argv[1]);
        return 1;
    }

    comments = ope_comments_create();
    ope_comments_add(comments, "ARTIST", "Someone");
    ope_comments_add(comments, "TITLE", "Some track");

    // Create initial encoder for the first file
    create_new_encoder(argv[2], file_index++, &enc, comments, &error);

    while (1) {
        short buf[2 * READ_SIZE]; // Read stereo PCM samples
        int ret = fread(buf, 2 * sizeof(short), READ_SIZE, fin); // Read PCM data from input file
        if (ret > 0) {
            ope_encoder_write(enc, buf, ret); // Encode and write to the current .opus file
            samples_written += ret;

            // Check if we need to start a new file
            if (samples_written >= max_samples_per_file) {
                ope_encoder_drain(enc);  // Finish writing the current file
                ope_encoder_destroy(enc);  // Clean up the current encoder

                // Reset sample count and create a new file encoder
                samples_written = 0;
                create_new_encoder(argv[2], file_index++, &enc, comments, &error);
            }
        } else break; // End of input file
    }

    // Finalize the last file
    ope_encoder_drain(enc);
    ope_encoder_destroy(enc);
    ope_comments_destroy(comments);
    fclose(fin);

    return 0;
}

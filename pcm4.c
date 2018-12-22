#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
    if (argc != 4) {
        fprintf(stderr, "Usage: %s [-e, -d] input output", argv[0]);
        return 1;
    }

    FILE *in  = fopen(argv[2], "rb"),
         *out = fopen(argv[3], "wb");

    if (!strncmp(argv[1], "-d", 2)) {
        while(!feof(in)) {
            int c = fgetc(in);
            fputc((c>>4)*0x11, out);
            fputc((c&15)*0x11, out);
        }
    }

    if (!strncmp(argv[1], "-e", 2)) {
        while(!feof(in)) {
            int c1 = fgetc(in),
                c2 = fgetc(in);
            fputc((c1/0x11)<<4|c2/0x11, out);
        }
    }

    fclose(in);
    fclose(out);

    return 0;
}

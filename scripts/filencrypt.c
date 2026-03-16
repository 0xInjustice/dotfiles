#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SALT_SIZE 16
#define BUF_SIZE 4096

typedef struct {
  uint32_t s[8];
} ctx;

/* simple internal hash (sha256-style mixing) */
void hash_init(ctx *c, const uint8_t *key, size_t len) {
  uint32_t seed[8] = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                      0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19};
  memcpy(c->s, seed, sizeof(seed));

  for (size_t i = 0; i < len; i++) {
    c->s[i % 8] ^= key[i] + (c->s[(i + 3) % 8] << 5) + (c->s[(i + 5) % 8] >> 2);
    c->s[i % 8] = (c->s[i % 8] << 7) | (c->s[i % 8] >> 25);
  }
}

uint32_t hash_next(ctx *c) {
  uint32_t x = c->s[0] ^ c->s[3] ^ c->s[5];
  x ^= (x << 13);
  x ^= (x >> 17);
  x ^= (x << 5);

  memmove(&c->s[0], &c->s[1], 7 * sizeof(uint32_t));
  c->s[7] = x;

  return x;
}

void random_bytes(uint8_t *buf, size_t n) {
  FILE *f = fopen("/dev/urandom", "rb");
  if (!f) {
    perror("urandom");
    exit(1);
  }
  fread(buf, 1, n, f);
  fclose(f);
}

void derive_key(uint8_t *out, const char *pass, uint8_t *salt) {
  ctx c;
  size_t plen = strlen(pass);

  uint8_t tmp[256];
  memcpy(tmp, pass, plen);
  memcpy(tmp + plen, salt, SALT_SIZE);

  hash_init(&c, tmp, plen + SALT_SIZE);

  for (int i = 0; i < 32; i++)
    out[i] = hash_next(&c) & 0xff;
}

void crypt_stream(FILE *in, FILE *out, uint8_t *key) {
  ctx c;
  hash_init(&c, key, 32);

  uint8_t buf[BUF_SIZE];

  size_t r;
  while ((r = fread(buf, 1, BUF_SIZE, in))) {
    for (size_t i = 0; i < r; i++) {
      uint8_t k = hash_next(&c) & 0xff;
      buf[i] ^= k;
    }
    fwrite(buf, 1, r, out);
  }
}

void encrypt_file(const char *infile, const char *outfile, const char *pass) {
  FILE *in = fopen(infile, "rb");
  FILE *out = fopen(outfile, "wb");

  uint8_t salt[SALT_SIZE];
  uint8_t key[32];

  random_bytes(salt, SALT_SIZE);
  derive_key(key, pass, salt);

  fwrite("FENC", 1, 4, out);
  fwrite(salt, 1, SALT_SIZE, out);

  crypt_stream(in, out, key);

  fclose(in);
  fclose(out);
}

void decrypt_file(const char *infile, const char *outfile, const char *pass) {
  FILE *in = fopen(infile, "rb");
  FILE *out = fopen(outfile, "wb");

  char magic[4];
  uint8_t salt[SALT_SIZE];
  uint8_t key[32];

  fread(magic, 1, 4, in);
  if (memcmp(magic, "FENC", 4) != 0) {
    printf("invalid file\n");
    exit(1);
  }

  fread(salt, 1, SALT_SIZE, in);
  derive_key(key, pass, salt);

  crypt_stream(in, out, key);

  fclose(in);
  fclose(out);
}

int main(int argc, char **argv) {
  if (argc < 5) {
    printf("usage:\n");
    printf(" encrypt: %s enc input output password\n", argv[0]);
    printf(" decrypt: %s dec input output password\n", argv[0]);
    return 1;
  }

  if (strcmp(argv[1], "enc") == 0)
    encrypt_file(argv[2], argv[3], argv[4]);
  else if (strcmp(argv[1], "dec") == 0)
    decrypt_file(argv[2], argv[3], argv[4]);
  else
    printf("mode enc/dec\n");

  return 0;
}

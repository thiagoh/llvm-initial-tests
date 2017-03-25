#include <cstdio>
#include <cstdlib>

/// putchard - putchar that takes a double and returns 0.
extern "C" double putchard(double X) {
  fputc((char)X, stderr);
  return 0;
}

int main() {

  for (float i = 97.0; i < 97.0 + 26; i++) {
    putchard(i);
  }

  return 0;
}
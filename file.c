
#include <stdio.h>
#include <stdlib.h>

int main(int c, char **args) {

  printf("my num of args are: %d\n", c);
  unsigned int i = 0;
  if (c > 1) {

    printf("and they are...\n");

    for (int j = 0; j <= c; j += 2) {
      printf("%d: %s\n", j, args[j]);
    }

    i = atoi(args[1]);
  }

  for (; i > 0; i--) {
    printf("nhaaaaaaaaaaaaa huuuuuuuuuuu: %d\n", i);
  }

  return 0;
}
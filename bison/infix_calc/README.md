# Infix_calc

```
$ bison infix_calc.y && g++ -lm infix_calc.tab.c -o infix_calc && ./infix_calc

4 2 ^ 
16
5 2 /
2.5
321 2 * 2 ^ 333 /
1237.72973
9 8 7 6 5 4 3 2 1 * * * * * * * *
362880
6 5 4 3 2 1 * * * * * 2 ^ 64 /
8100
```
# Infix_calc

```
$ bison infix_calc.y && g++ -lm infix_calc.tab.c -o infix_calc && ./infix_calc
2 + 4 + 5 * 2
line 2: 16
9*8*7*6*5*4*3*2 
line 3: 362880
6 * 5 * 4 * 3 * 2 ^ 64
line 4: 6.640827867e+21
6 * 5 * 4 * 3 * 2 ^ 2 / 64
line 5: 22.5
4 * 2
line 6: 8
4 * 2 ^ 2
line 7: 16
```
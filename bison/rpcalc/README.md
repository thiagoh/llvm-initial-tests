# Rpcalc

Rpcalc

```
$ bison rpcalc.y && g++ -lm rpcalc.tab.c -o rpcalc && ./rpcalc

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
# llvm-initial-tests

## run the tests

```
# emit LLVM
$ clang file.c -fomit-frame-pointer -S -emit-llvm -o -

# emit optimized assembly
$ clang file.c -fomit-frame-pointer -O3 -S -o -

# emit non-optimized assembly
$ clang file.c -fomit-frame-pointer -S -emit-llvm -o -

# compile with clang 
$ clang file.c 
--> outputs a.out

# run the program
$ ./a.out 10 foo bar
my num of args are: 4
and they are...
0: ./a.out
1: 10
2: foo
3: bar
nhaaaaaaaaaaaaa huuuuuuuuuuu: 10
nhaaaaaaaaaaaaa huuuuuuuuuuu: 9
nhaaaaaaaaaaaaa huuuuuuuuuuu: 8
nhaaaaaaaaaaaaa huuuuuuuuuuu: 7
nhaaaaaaaaaaaaa huuuuuuuuuuu: 6
nhaaaaaaaaaaaaa huuuuuuuuuuu: 5
nhaaaaaaaaaaaaa huuuuuuuuuuu: 4
nhaaaaaaaaaaaaa huuuuuuuuuuu: 3
nhaaaaaaaaaaaaa huuuuuuuuuuu: 2
nhaaaaaaaaaaaaa huuuuuuuuuuu: 1
```

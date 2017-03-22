# LLVM and Toy language

## Playing around LLVM

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


## Testing toy language
```
# Compile and Run
$ clang++ -g -O3 toy.cpp `llvm-config --cxxflags --ldflags --system-libs --libs core` -o toy.app && ./toy.app

# Now test the parsing of 'def bar(a b c d e f g h) a + b + (c + d) * g * f + h;'
ready> def bar(a b c d e f g h) a + b + (c + d) * g * f + h;
ready> Parsed a function definition.
ready>
ready> def foo(a,b) ret a + b;
ready> Read function definition:
define double @foo(double %a, double %b) {
entry:
  %addtmp = fadd double %a, %b
  ret double %addtmp
}

ready> foo(3.2,0.5);
ready> Read top-level expression:
define double @__anon_expr() {
entry:
  %calltmp = call double @foo(double 3.200000e+00, double 5.000000e-01)
}

ready> 3.2+1.1;
Read top-level expression:
define double @__anon_expr() {
entry:
  %calltmp = call double @foo(double 3.200000e+00, double 5.000000e-01)

entry1:                                           ; No predecessors!
}
```
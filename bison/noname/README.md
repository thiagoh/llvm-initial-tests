# noname

```
$ bison -d noname.y && g++ -lm noname.tab.c -I. -I./include/ -I./src -o noname
```

If you want to debug run this. This generates `noname.output`

```
$ bison -dvt noname.y && g++ -lm noname.tab.c -I. -I./include/ -I./src -o noname 
```
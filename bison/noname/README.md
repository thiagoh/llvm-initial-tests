# noname

```
$ bison noname.y && g++ -lm noname.tab.c -o noname && ./noname
```

If you want to debug run this. This generates `noname.output`

```
$ bison -dvt noname.y && g++ -lm noname.tab.c -o noname && ./noname
```
function fib(x) {

  var last = 1;
  var acc = 2;
  var tmp = acc;

  for (var i = 3; i < x; i++) {

    acc = last + acc;
    last = tmp;
    tmp = acc;
  }

  return acc;
}

function printit(x) {
  console.log('fib of ' + x, fib(x));
}

var i = 3;
printit(i++);
printit(i++);
printit(i++);
printit(i++);
printit(i++);
printit(i++);
printit(i++);
printit(i++);
printit(i++);
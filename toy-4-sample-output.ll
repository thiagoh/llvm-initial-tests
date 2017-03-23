; To generate the graph run the command below
; llvm-as < toy-4-sample-output.ll | opt -analyze -view-cfg

define double @foo(double %x, double %y) {
entry:
  %addtmp = fadd double %x, %y
  %cmp = fcmp one double %addtmp, 2.0
  br i1 %cmp, label %then, label %else

  then:
    %res1 = call double @test_condition_1()
    br label %cont

  else:
    %res2 = call double @test_condition_2()
    br label %cont
  
  cont:
    %res = phi double [ %res1, %then ], [ %res2, %else ]
    ret double %res
}

define double @test_condition_1() {
entry:
  ret double 123.0
}

define double @test_condition_2() {
entry:
  ret double 321.0
}
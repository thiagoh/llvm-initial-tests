 ; ModuleID = 'my cool jit'
; source_filename = "my cool jit"

declare double @putchar(double)

define double @foo(double %a, double %b) {
entry:
  %multmp = fmul double %b, %b
  %multmp1 = fmul double %multmp, %b
  %addtmp = fadd double %a, %multmp1
  ret double %addtmp
}

define i32 @main() {
  %1 = call double @foo(double 1.0, double 2.0)
  call double @putchar(double %1)
  ret i32 0
}
; ModuleID = 'classes-test.cpp'
source_filename = "classes-test.cpp"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

%class.Person = type <{ i32, [4 x i8], double, i8*, i32, [4 x i8] }>
%class.MyClass = type { i32 }

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.2 = private unnamed_addr constant [17 x i8] c"foo bar baz quux\00", align 1

; Function Attrs: noinline ssp uwtable
define double @c_puts(i8* %s) #0 {
entry:
  %s.addr = alloca i8*, align 8
  store i8* %s, i8** %s.addr, align 8
  %0 = load i8*, i8** %s.addr, align 8
  %call = call i32 @puts(i8* %0)
  ret double 0.000000e+00
}

declare i32 @puts(i8*) #1

; Function Attrs: noinline ssp uwtable
define double @c_puti(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32, i32* %i.addr, align 4
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %0)
  ret double 0.000000e+00
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: noinline ssp uwtable
define double @c_putd(double %d) #0 {
entry:
  %d.addr = alloca double, align 8
  store double %d, double* %d.addr, align 8
  %0 = load double, double* %d.addr, align 8
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), double %0)
  ret double 0.000000e+00
}

; Function Attrs: noinline ssp uwtable
define void @_Z9do_loop_1R6Person(%class.Person* dereferenceable(32) %person) #0 {
entry:
  %person.addr = alloca %class.Person*, align 8
  %counter = alloca i32, align 4
  store %class.Person* %person, %class.Person** %person.addr, align 8
  store i32 0, i32* %counter, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %counter, align 4
  %cmp = icmp slt i32 %0, 3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load %class.Person*, %class.Person** %person.addr, align 8
  %call = call i32 @_ZN6Person6getAgeEv(%class.Person* %1)
  %call1 = call double @c_puti(i32 %call)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load i32, i32* %counter, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %counter, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable
define linkonce_odr i32 @_ZN6Person6getAgeEv(%class.Person* %this) #2 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  store %class.Person* %this, %class.Person** %this.addr, align 8
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %age = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 0
  %0 = load i32, i32* %age, align 8
  ret i32 %0
}

; Function Attrs: noinline ssp uwtable
define void @_Z9do_loop_2R6Person(%class.Person* dereferenceable(32) %person) #0 {
entry:
  %person.addr = alloca %class.Person*, align 8
  %counter = alloca double, align 8
  store %class.Person* %person, %class.Person** %person.addr, align 8
  store double 0.000000e+00, double* %counter, align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load double, double* %counter, align 8
  %cmp = fcmp olt double %0, 7.000000e+00
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load %class.Person*, %class.Person** %person.addr, align 8
  %call = call i32 @_ZN6Person6getAgeEv(%class.Person* %1)
  %call1 = call double @c_puti(i32 %call)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load double, double* %counter, align 8
  %inc = fadd double %2, 1.000000e+00
  store double %inc, double* %counter, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

; Function Attrs: noinline norecurse ssp uwtable
define i32 @main() #3 {
entry:
  %retval = alloca i32, align 4
  %myClassInstance = alloca %class.MyClass, align 4
  %person1 = alloca %class.Person, align 8
  store i32 0, i32* %retval, align 4
  call void @_ZN6PersonC1Ei(%class.Person* %person1, i32 34)
  call void @_Z9do_loop_1R6Person(%class.Person* dereferenceable(32) %person1)
  call void @_Z9do_loop_2R6Person(%class.Person* dereferenceable(32) %person1)
  %call = call double @_ZN6Person17getChildrenAgeAVGEv(%class.Person* %person1)
  %call1 = call double @c_putd(double %call)
  %call2 = call i8* @_ZN6Person7getNameEv(%class.Person* %person1)
  %call3 = call double @c_puts(i8* %call2)
  %call4 = call i32 @_ZN6Person4getZEv(%class.Person* %person1)
  %call5 = call i8* @_ZN6Person7getNameEv(%class.Person* %person1)
  ret i32 0
}

; Function Attrs: noinline ssp uwtable
define linkonce_odr void @_ZN6PersonC1Ei(%class.Person* %this, i32 %age) unnamed_addr #0 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  %age.addr = alloca i32, align 4
  store %class.Person* %this, %class.Person** %this.addr, align 8
  store i32 %age, i32* %age.addr, align 4
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %0 = load i32, i32* %age.addr, align 4
  call void @_ZN6PersonC2Ei(%class.Person* %this1, i32 %0)
  ret void
}

; Function Attrs: noinline nounwind ssp uwtable
define linkonce_odr double @_ZN6Person17getChildrenAgeAVGEv(%class.Person* %this) #2 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  store %class.Person* %this, %class.Person** %this.addr, align 8
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %chilndreAgeAVG = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 2
  %0 = load double, double* %chilndreAgeAVG, align 8
  ret double %0
}

; Function Attrs: noinline nounwind ssp uwtable
define linkonce_odr i8* @_ZN6Person7getNameEv(%class.Person* %this) #2 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  store %class.Person* %this, %class.Person** %this.addr, align 8
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %name = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 3
  %0 = load i8*, i8** %name, align 8
  ret i8* %0
}

; Function Attrs: noinline nounwind ssp uwtable
define linkonce_odr i32 @_ZN6Person4getZEv(%class.Person* %this) #2 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  store %class.Person* %this, %class.Person** %this.addr, align 8
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %z = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 4
  %0 = load i32, i32* %z, align 8
  ret i32 %0
}

; Function Attrs: noinline nounwind ssp uwtable
define linkonce_odr void @_ZN6PersonC2Ei(%class.Person* %this, i32 %age) unnamed_addr #2 align 2 {
entry:
  %this.addr = alloca %class.Person*, align 8
  %age.addr = alloca i32, align 4
  store %class.Person* %this, %class.Person** %this.addr, align 8
  store i32 %age, i32* %age.addr, align 4
  %this1 = load %class.Person*, %class.Person** %this.addr, align 8
  %age2 = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 0
  %0 = load i32, i32* %age.addr, align 4
  store i32 %0, i32* %age2, align 8
  %chilndreAgeAVG = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 2
  store double 3.200000e+00, double* %chilndreAgeAVG, align 8
  %name = getelementptr inbounds %class.Person, %class.Person* %this1, i32 0, i32 3
  store i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i32 0, i32 0), i8** %name, align 8
  ret void
}

attributes #0 = { noinline ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noinline nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline norecurse ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"clang version 5.0.0 (trunk 298179)"}

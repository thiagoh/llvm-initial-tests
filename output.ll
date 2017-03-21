; ModuleID = 'file.c'
source_filename = "file.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

@.str = private unnamed_addr constant [36 x i8] c"I am calling the function print_it\0A\00", align 1
@.str.1 = private unnamed_addr constant [34 x i8] c"nhaaaaaaaaaaaaa huuuuuuuuuuu: %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [24 x i8] c"my num of args are: %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"and they are...\0A\00", align 1
@.str.4 = private unnamed_addr constant [8 x i8] c"%d: %s\0A\00", align 1

; Function Attrs: nounwind ssp uwtable
define void @print_it(i32) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str, i32 0, i32 0))
  br label %4

; <label>:4                                       ; preds = %10, %1
  %5 = load i32, i32* %2, align 4
  %6 = icmp ugt i32 %5, 0
  br i1 %6, label %7, label %13

; <label>:7                                       ; preds = %4
  %8 = load i32, i32* %2, align 4
  %9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i32 0, i32 0), i32 %8)
  br label %10

; <label>:10                                      ; preds = %7
  %11 = load i32, i32* %2, align 4
  %12 = add i32 %11, -1
  store i32 %12, i32* %2, align 4
  br label %4

; <label>:13                                      ; preds = %4
  ret void
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind ssp uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  %8 = load i32, i32* %4, align 4
  %9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.2, i32 0, i32 0), i32 %8)
  store i32 0, i32* %6, align 4
  %10 = load i32, i32* %4, align 4
  %11 = icmp sgt i32 %10, 1
  br i1 %11, label %12, label %34

; <label>:12                                      ; preds = %2
  %13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0))
  store i32 0, i32* %7, align 4
  br label %14

; <label>:14                                      ; preds = %26, %12
  %15 = load i32, i32* %7, align 4
  %16 = load i32, i32* %4, align 4
  %17 = icmp sle i32 %15, %16
  br i1 %17, label %18, label %29

; <label>:18                                      ; preds = %14
  %19 = load i32, i32* %7, align 4
  %20 = load i32, i32* %7, align 4
  %21 = sext i32 %20 to i64
  %22 = load i8**, i8*** %5, align 8
  %23 = getelementptr inbounds i8*, i8** %22, i64 %21
  %24 = load i8*, i8** %23, align 8
  %25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.4, i32 0, i32 0), i32 %19, i8* %24)
  br label %26

; <label>:26                                      ; preds = %18
  %27 = load i32, i32* %7, align 4
  %28 = add nsw i32 %27, 2
  store i32 %28, i32* %7, align 4
  br label %14

; <label>:29                                      ; preds = %14
  %30 = load i8**, i8*** %5, align 8
  %31 = getelementptr inbounds i8*, i8** %30, i64 1
  %32 = load i8*, i8** %31, align 8
  %33 = call i32 @atoi(i8* %32)
  store i32 %33, i32* %6, align 4
  br label %34

; <label>:34                                      ; preds = %29, %2
  %35 = load i32, i32* %6, align 4
  call void @print_it(i32 %35)
  ret i32 0
}

declare i32 @atoi(i8*) #1

attributes #0 = { nounwind ssp uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"Apple LLVM version 8.0.0 (clang-800.0.42.1)"}

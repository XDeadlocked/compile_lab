; ModuleID = 'main1_anay_cgp.bc'
source_filename = "main1.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@a = dso_local global i32 0, align 4
@b = dso_local global i32 1, align 4
@i = dso_local global i32 0, align 4
@.str = private unnamed_addr constant [40 x i8] c"\E8\AF\B7\E8\BE\93\E5\85\A5\E6\96\90\E6\B3\A2\E9\82\A3\E5\A5\91\E6\95\B0\E5\88\97\E7\9A\84\E9\A1\B9\E6\95\B0\EF\BC\9A\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"%d\0A%d\0A\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 1, i32* @i, align 4
  %3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @.str, i64 0, i64 0))
  %4 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i32* noundef %2)
  %5 = load i32, i32* %2, align 4
  call void @print_fibonacci_sequence(i32 noundef %5)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...) #1

declare i32 @__isoc99_scanf(i8* noundef, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_fibonacci_sequence(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %4 = load i32, i32* @a, align 4
  %5 = load i32, i32* @b, align 4
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0), i32 noundef %4, i32 noundef %5)
  br label %7

7:                                                ; preds = %11, %1
  %8 = load i32, i32* @i, align 4
  %9 = load i32, i32* %2, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %11, label %21

11:                                               ; preds = %7
  %12 = load i32, i32* @b, align 4
  store i32 %12, i32* %3, align 4
  %13 = load i32, i32* @a, align 4
  %14 = load i32, i32* @b, align 4
  %15 = add nsw i32 %13, %14
  store i32 %15, i32* @b, align 4
  %16 = load i32, i32* @b, align 4
  %17 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 noundef %16)
  %18 = load i32, i32* %3, align 4
  store i32 %18, i32* @a, align 4
  %19 = load i32, i32* @i, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, i32* @i, align 4
  br label %7, !llvm.loop !6

21:                                               ; preds = %7
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}

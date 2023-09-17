; ModuleID = 'main.c'


@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"%d\0A%d\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4  ;给返回值预分配寄存器
  %2 = alloca i32, align 4  ;a 
  %3 = alloca i32, align 4  ;b 
  %4 = alloca i32, align 4  ;i 
  %5 = alloca i32, align 4  ;t
  %6 = alloca i32, align 4  ;n
  store i32 0, i32* %1, align 4
  store i32 0, i32* %2, align 4 ;赋值a 
  store i32 1, i32* %3, align 4 ;赋值b 
  store i32 1, i32* %4, align 4 ;赋值i
  %7 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i64 0, i64 0), i32* noundef %6)
  %8 = load i32, i32* %2, align 4 ;a(要调用函数前先存到临时空间)
  %9 = load i32, i32* %3, align 4 ;b 
  %10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i64 0, i64 0), i32 noundef %8, i32 noundef %9)
  br label %11

11:                                               ; preds = %15, %0
  %12 = load i32, i32* %4, align 4  ;分配临时空间加载i
  %13 = load i32, i32* %6, align 4  ;分配临时空间加载n
  %14 = icmp slt i32 %12, %13       ;比较运算
  br i1 %14, label %15, label %25   ;开始循环

15:                                               ; preds = %11
  %16 = load i32, i32* %3, align 4  ;给b的临时空间用于赋值
  store i32 %16, i32* %5, align 4   ;t=b 
  %17 = load i32, i32* %2, align 4  ;给a的临时空间用于运算
  %18 = load i32, i32* %3, align 4  ;给b的临时空间用于计算
  %19 = add nsw i32 %17, %18        ;加法计算
  store i32 %19, i32* %3, align 4   ;结果存到b中
  %20 = load i32, i32* %3, align 4  ;b的临时空间，用于打印
  %21 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i32 noundef %20)
  %22 = load i32, i32* %5, align 4  ;t的临时空间，用于赋值给a
  store i32 %22, i32* %2, align 4   ;a=t 
  %23 = load i32, i32* %4, align 4  ;进行i的自增操作
  %24 = add nsw i32 %23, 1
  store i32 %24, i32* %4, align 4   ;结果回存
  br label %11, !llvm.loop !6

25:                                               ; preds = %11
  %26 = load i32, i32* %1, align 4
  ret i32 %26
}

declare i32 @__isoc99_scanf(i8* noundef, ...) #1

declare i32 @printf(i8* noundef, ...) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}

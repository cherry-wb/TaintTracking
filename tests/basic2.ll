; ModuleID = 'basic2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }

@stdout = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [16 x i8] c"Enter a value: \00", align 1
@stdin = external global %struct._IO_FILE*
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [24 x i8] c"Number entered is odd.\0A\00", align 1
@.str3 = private unnamed_addr constant [25 x i8] c"Number entered is even.\0A\00", align 1

define i32 @main() nounwind uwtable {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 0, i32* %retval
  %0 = load %struct._IO_FILE** @stdout, align 8
  %call = call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %0, i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0))
  %1 = load %struct._IO_FILE** @stdin, align 8
  %call1 = call i32 (%struct._IO_FILE*, i8*, ...)* @__isoc99_fscanf(%struct._IO_FILE* %1, i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32* %x)
  %2 = load i32* %x, align 4
  %rem = srem i32 %2, 2
  %tobool = icmp ne i32 %rem, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %3 = load %struct._IO_FILE** @stdout, align 8
  %call2 = call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %3, i8* getelementptr inbounds ([24 x i8]* @.str2, i32 0, i32 0))
  br label %if.end

if.else:                                          ; preds = %entry
  %4 = load %struct._IO_FILE** @stdout, align 8
  %call3 = call i32 (%struct._IO_FILE*, i8*, ...)* @fprintf(%struct._IO_FILE* %4, i8* getelementptr inbounds ([25 x i8]* @.str3, i32 0, i32 0))
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %5 = load i32* %x, align 4
  %mul = mul nsw i32 %5, 8
  ret i32 %mul
}

declare i32 @fprintf(%struct._IO_FILE*, i8*, ...)

declare i32 @__isoc99_fscanf(%struct._IO_FILE*, i8*, ...)

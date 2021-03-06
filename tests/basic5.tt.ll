; ModuleID = 'basic5.tt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@return_taint = global i1 false
@return_taint1 = global i1 false
@param_taint = global i1 false
@.str = private constant [31 x i8] c"Warning: tainted data in use!\0A\00", align 1
@.str2 = private constant [31 x i8] c"Warning: tainted data in use!\0A\00", align 1

define i32 @doStuff(i32 %x) nounwind uwtable {
entry:
  %param_taint_load = load i1* @param_taint
  store i1 %param_taint_load, i1* @return_taint1
  ret i32 %x

abortBB:                                          ; preds = %abortBB
  %warn_printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([31 x i8]* @.str, i32 0, i32 0))
  call void @exit(i32 1)
  br label %abortBB
}

define i32 @main() nounwind uwtable {
entry:
  %call = call i64 @time(i64* null) nounwind
  %unaryT = or i1 false, false
  %conv = trunc i64 %call to i32
  call void @srand(i32 %conv) nounwind
  %call1 = call i32 @rand() nounwind
  %binT = or i1 true, false
  %rem = srem i32 %call1, 2
  %binT1 = or i1 %binT, false
  %tobool = icmp ne i32 %rem, 0
  %branch_check = or i1 false, false
  br i1 %branch_check, label %abortBB, label %cont_BB

cont_BB:                                          ; preds = %entry
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %cont_BB
  %param_or = or i1 true, false
  %protect_check = icmp eq i1 %param_or, true
  br i1 %protect_check, label %abortBB, label %cont_BB2

cont_BB2:                                         ; preds = %if.then
  store i1 true, i1* @param_taint
  %call2 = call i32 @doStuff(i32 %call1)
  %retT_load = load i1* @return_taint1
  br label %if.end

if.else:                                          ; preds = %cont_BB
  %binT3 = or i1 true, false
  %inc = add nsw i32 %call1, 1
  br label %if.end

if.end:                                           ; preds = %if.else, %cont_BB2
  %taintPHI = phi i1 [ %retT_load, %cont_BB2 ], [ %binT3, %if.else ]
  %x.0 = phi i32 [ %call2, %cont_BB2 ], [ %inc, %if.else ]
  store i1 %taintPHI, i1* @return_taint
  ret i32 %x.0

abortBB:                                          ; preds = %abortBB, %if.then, %entry
  %warn_printf = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([31 x i8]* @.str2, i32 0, i32 0))
  call void @exit(i32 1)
  br label %abortBB
}

declare void @srand(i32) nounwind

declare i64 @time(i64*) nounwind

declare i32 @rand() nounwind

declare i32 @printf(i8*, ...)

declare void @exit(i32) noreturn nounwind

; ModuleID = 'basic.tt.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"Z = %i\0A\00", align 1

define i32 @main() nounwind uwtable {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32, align 4
  %y = alloca i32, align 4
  %z = alloca i32, align 4
  %taint_store = alloca i1
  store i1 true, i1* %taint_store
  store i32 0, i32* %retval
  %taint_store1 = alloca i1
  store i1 false, i1* %taint_store1
  store i32 6, i32* %x, align 4
  %taint_store2 = alloca i1
  store i1 false, i1* %taint_store2
  store i32 5, i32* %y, align 4
  %taint_load = load i1* %taint_store1
  %mem_or = or i1 %taint_load, false
  %0 = load i32* %x, align 4
  %taint_load3 = load i1* %taint_store2
  %mem_or4 = or i1 %taint_load3, false
  %1 = load i32* %y, align 4
  %bin_or = or i1 %mem_or, %mem_or4
  %mul = mul nsw i32 %0, %1
  %taint_store5 = alloca i1
  store i1 %bin_or, i1* %taint_store5
  store i32 %mul, i32* %z, align 4
  %taint_load6 = load i1* %taint_store5
  %mem_or7 = or i1 %taint_load6, false
  %2 = load i32* %z, align 4
  %bin_or8 = or i1 %mem_or7, false
  %inc = add nsw i32 %2, 1
  store i1 %bin_or8, i1* %taint_store5
  store i32 %inc, i32* %z, align 4
  %taint_load9 = load i1* %taint_store5
  %mem_or10 = or i1 %taint_load9, false
  %3 = load i32* %z, align 4
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @.str, i32 0, i32 0), i32 %3)
  %taint_load11 = load i1* %taint_store5
  %mem_or12 = or i1 %taint_load11, false
  %4 = load i32* %z, align 4
  %taint_check = icmp eq i1 %mem_or12, true
  br i1 %taint_check, label %abortBB, label %cont_BB

cont_BB:                                          ; preds = %entry
  ret i32 %4

abortBB:                                          ; preds = %abortBB, %entry
  br label %abortBB
}

declare i32 @printf(i8*, ...)

declare i32 @exit()
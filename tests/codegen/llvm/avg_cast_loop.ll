; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf-pc-linux"

%"struct map_t" = type { ptr, ptr, ptr, ptr }
%"struct map_t.0" = type { ptr, ptr }
%"struct map_t.1" = type { ptr, ptr, ptr, ptr }
%avg_stas_val = type { i64, i64 }
%int64_avg_t__tuple_t = type { i64, i64 }
%print_tuple_16_t = type <{ i64, i64, [16 x i8] }>

@LICENSE = global [4 x i8] c"GPL\00", section "license"
@AT_x = dso_local global %"struct map_t" zeroinitializer, section ".maps", !dbg !0
@ringbuf = dso_local global %"struct map_t.0" zeroinitializer, section ".maps", !dbg !26
@event_loss_counter = dso_local global %"struct map_t.1" zeroinitializer, section ".maps", !dbg !40
@tuple_buf = dso_local externally_initialized global [1 x [2 x [16 x i8]]] zeroinitializer, section ".data.tuple_buf", !dbg !57
@max_cpu_id = dso_local externally_initialized constant i64 zeroinitializer, section ".rodata", !dbg !65
@fmt_str_buf = dso_local externally_initialized global [1 x [1 x [32 x i8]]] zeroinitializer, section ".data.fmt_str_buf", !dbg !67
@num_cpus = dso_local externally_initialized constant i64 zeroinitializer, section ".rodata", !dbg !74

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64 %0, i64 %1) #0

define i64 @kprobe_f_1(ptr %0) section "s_kprobe_f_1" !dbg !79 {
entry:
  %avg_struct = alloca %avg_stas_val, align 8
  %"@x_key" = alloca i64, align 8
  call void @llvm.lifetime.start.p0(i64 -1, ptr %"@x_key")
  store i64 1, ptr %"@x_key", align 8
  %lookup_elem = call ptr inttoptr (i64 1 to ptr)(ptr @AT_x, ptr %"@x_key")
  %lookup_cond = icmp ne ptr %lookup_elem, null
  br i1 %lookup_cond, label %lookup_success, label %lookup_failure

lookup_success:                                   ; preds = %entry
  %1 = getelementptr %avg_stas_val, ptr %lookup_elem, i64 0, i32 0
  %2 = load i64, ptr %1, align 8
  %3 = getelementptr %avg_stas_val, ptr %lookup_elem, i64 0, i32 1
  %4 = load i64, ptr %3, align 8
  %5 = getelementptr %avg_stas_val, ptr %lookup_elem, i64 0, i32 0
  %6 = add i64 %2, 2
  store i64 %6, ptr %5, align 8
  %7 = getelementptr %avg_stas_val, ptr %lookup_elem, i64 0, i32 1
  %8 = add i64 1, %4
  store i64 %8, ptr %7, align 8
  br label %lookup_merge

lookup_failure:                                   ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 -1, ptr %avg_struct)
  %9 = getelementptr %avg_stas_val, ptr %avg_struct, i64 0, i32 0
  store i64 2, ptr %9, align 8
  %10 = getelementptr %avg_stas_val, ptr %avg_struct, i64 0, i32 1
  store i64 1, ptr %10, align 8
  %update_elem = call i64 inttoptr (i64 2 to ptr)(ptr @AT_x, ptr %"@x_key", ptr %avg_struct, i64 0)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %avg_struct)
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  call void @llvm.lifetime.end.p0(i64 -1, ptr %"@x_key")
  %for_each_map_elem = call i64 inttoptr (i64 164 to ptr)(ptr @AT_x, ptr @map_for_each_cb, ptr null, i64 0)
  ret i64 0
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg %0, ptr nocapture %1) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg %0, ptr nocapture %1) #1

define internal i64 @map_for_each_cb(ptr %0, ptr %1, ptr %2, ptr %3) section ".text" !dbg !85 {
  %key7 = alloca i32, align 4
  %ret = alloca i64, align 8
  %val_2 = alloca i64, align 8
  %val_1 = alloca i64, align 8
  %i = alloca i32, align 4
  %lookup_key = alloca i64, align 8
  %key = load i64, ptr %1, align 8
  call void @llvm.lifetime.start.p0(i64 -1, ptr %lookup_key)
  store i64 %key, ptr %lookup_key, align 8
  call void @llvm.lifetime.start.p0(i64 -1, ptr %i)
  call void @llvm.lifetime.start.p0(i64 -1, ptr %val_1)
  call void @llvm.lifetime.start.p0(i64 -1, ptr %val_2)
  store i32 0, ptr %i, align 4
  store i64 0, ptr %val_1, align 8
  store i64 0, ptr %val_2, align 8
  br label %while_cond

while_cond:                                       ; preds = %lookup_success, %4
  %5 = load i32, ptr @num_cpus, align 4
  %6 = load i32, ptr %i, align 4
  %num_cpu.cmp = icmp ult i32 %6, %5
  br i1 %num_cpu.cmp, label %while_body, label %while_end

while_body:                                       ; preds = %while_cond
  %7 = load i32, ptr %i, align 4
  %lookup_percpu_elem = call ptr inttoptr (i64 195 to ptr)(ptr @AT_x, ptr %lookup_key, i32 %7)
  %map_lookup_cond = icmp ne ptr %lookup_percpu_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

while_end:                                        ; preds = %error_failure, %error_success, %while_cond
  call void @llvm.lifetime.end.p0(i64 -1, ptr %i)
  call void @llvm.lifetime.start.p0(i64 -1, ptr %ret)
  %8 = load i64, ptr %val_1, align 8
  %is_negative_cond = icmp slt i64 %8, 0
  br i1 %is_negative_cond, label %is_negative, label %is_positive

lookup_success:                                   ; preds = %while_body
  %9 = getelementptr %avg_stas_val, ptr %lookup_percpu_elem, i64 0, i32 0
  %10 = load i64, ptr %9, align 8
  %11 = getelementptr %avg_stas_val, ptr %lookup_percpu_elem, i64 0, i32 1
  %12 = load i64, ptr %11, align 8
  %13 = load i64, ptr %val_1, align 8
  %14 = add i64 %10, %13
  store i64 %14, ptr %val_1, align 8
  %15 = load i64, ptr %val_2, align 8
  %16 = add i64 %12, %15
  store i64 %16, ptr %val_2, align 8
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %while_cond

lookup_failure:                                   ; preds = %while_body
  %19 = load i32, ptr %i, align 4
  %error_lookup_cond = icmp eq i32 %19, 0
  br i1 %error_lookup_cond, label %error_success, label %error_failure

error_success:                                    ; preds = %lookup_failure
  br label %while_end

error_failure:                                    ; preds = %lookup_failure
  %20 = load i32, ptr %i, align 4
  br label %while_end

is_negative:                                      ; preds = %while_end
  %21 = load i64, ptr %val_1, align 8
  %22 = xor i64 %21, -1
  %23 = add i64 %22, 1
  %24 = load i64, ptr %val_2, align 8
  %25 = udiv i64 %23, %24
  %26 = sub i64 0, %25
  store i64 %26, ptr %ret, align 8
  br label %is_negative_merge_block

is_positive:                                      ; preds = %while_end
  %27 = load i64, ptr %val_2, align 8
  %28 = load i64, ptr %val_1, align 8
  %29 = udiv i64 %28, %27
  store i64 %29, ptr %ret, align 8
  br label %is_negative_merge_block

is_negative_merge_block:                          ; preds = %is_positive, %is_negative
  %30 = load i64, ptr %ret, align 8
  call void @llvm.lifetime.end.p0(i64 -1, ptr %ret)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %val_1)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %val_2)
  %get_cpu_id = call i64 inttoptr (i64 8 to ptr)()
  %31 = load i64, ptr @max_cpu_id, align 8
  %cpuid.min.cmp = icmp ule i64 %get_cpu_id, %31
  %cpuid.min.select = select i1 %cpuid.min.cmp, i64 %get_cpu_id, i64 %31
  %32 = getelementptr [1 x [2 x [16 x i8]]], ptr @tuple_buf, i64 0, i64 %cpuid.min.select, i64 0, i64 0
  call void @llvm.memset.p0.i64(ptr align 1 %32, i8 0, i64 16, i1 false)
  %33 = getelementptr %int64_avg_t__tuple_t, ptr %32, i32 0, i32 0
  store i64 %key, ptr %33, align 8
  %34 = getelementptr %int64_avg_t__tuple_t, ptr %32, i32 0, i32 1
  store i64 %30, ptr %34, align 8
  %35 = getelementptr %int64_avg_t__tuple_t, ptr %32, i32 0, i32 0
  %36 = load i64, ptr %35, align 8
  %37 = getelementptr %int64_avg_t__tuple_t, ptr %32, i32 0, i32 1
  %38 = load i64, ptr %37, align 8
  %get_cpu_id1 = call i64 inttoptr (i64 8 to ptr)()
  %39 = load i64, ptr @max_cpu_id, align 8
  %cpuid.min.cmp2 = icmp ule i64 %get_cpu_id1, %39
  %cpuid.min.select3 = select i1 %cpuid.min.cmp2, i64 %get_cpu_id1, i64 %39
  %40 = getelementptr [1 x [2 x [16 x i8]]], ptr @tuple_buf, i64 0, i64 %cpuid.min.select3, i64 1, i64 0
  call void @llvm.memset.p0.i64(ptr align 1 %40, i8 0, i64 16, i1 false)
  %41 = getelementptr %int64_avg_t__tuple_t, ptr %40, i32 0, i32 0
  store i64 %36, ptr %41, align 8
  %42 = getelementptr %int64_avg_t__tuple_t, ptr %40, i32 0, i32 1
  store i64 %38, ptr %42, align 8
  %get_cpu_id4 = call i64 inttoptr (i64 8 to ptr)()
  %43 = load i64, ptr @max_cpu_id, align 8
  %cpuid.min.cmp5 = icmp ule i64 %get_cpu_id4, %43
  %cpuid.min.select6 = select i1 %cpuid.min.cmp5, i64 %get_cpu_id4, i64 %43
  %44 = getelementptr [1 x [1 x [32 x i8]]], ptr @fmt_str_buf, i64 0, i64 %cpuid.min.select6, i64 0, i64 0
  %45 = getelementptr %print_tuple_16_t, ptr %44, i64 0, i32 0
  store i64 30007, ptr %45, align 8
  %46 = getelementptr %print_tuple_16_t, ptr %44, i64 0, i32 1
  store i64 0, ptr %46, align 8
  %47 = getelementptr %print_tuple_16_t, ptr %44, i32 0, i32 2
  call void @llvm.memset.p0.i64(ptr align 1 %47, i8 0, i64 16, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %47, ptr align 1 %40, i64 16, i1 false)
  %ringbuf_output = call i64 inttoptr (i64 130 to ptr)(ptr @ringbuf, ptr %44, i64 32, i64 0)
  %ringbuf_loss = icmp slt i64 %ringbuf_output, 0
  br i1 %ringbuf_loss, label %event_loss_counter, label %counter_merge

event_loss_counter:                               ; preds = %is_negative_merge_block
  call void @llvm.lifetime.start.p0(i64 -1, ptr %key7)
  store i32 0, ptr %key7, align 4
  %lookup_elem = call ptr inttoptr (i64 1 to ptr)(ptr @event_loss_counter, ptr %key7)
  %map_lookup_cond10 = icmp ne ptr %lookup_elem, null
  br i1 %map_lookup_cond10, label %lookup_success8, label %lookup_failure9

counter_merge:                                    ; preds = %lookup_merge, %is_negative_merge_block
  ret i64 0

lookup_success8:                                  ; preds = %event_loss_counter
  %48 = atomicrmw add ptr %lookup_elem, i64 1 seq_cst, align 8
  br label %lookup_merge

lookup_failure9:                                  ; preds = %event_loss_counter
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure9, %lookup_success8
  call void @llvm.lifetime.end.p0(i64 -1, ptr %key7)
  br label %counter_merge
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly %0, i8 %1, i64 %2, i1 immarg %3) #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly %0, ptr noalias nocapture readonly %1, i64 %2, i1 immarg %3) #3

attributes #0 = { nounwind }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }

!llvm.dbg.cu = !{!76}
!llvm.module.flags = !{!78}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "AT_x", linkageName: "global", scope: !2, file: !2, type: !3, isLocal: false, isDefinition: true)
!2 = !DIFile(filename: "bpftrace.bpf.o", directory: ".")
!3 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !4)
!4 = !{!5, !11, !16, !19}
!5 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 160, elements: !9)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!10}
!10 = !DISubrange(count: 5, lowerBound: 0)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !12, size: 64, offset: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 131072, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 4096, lowerBound: 0)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !17, size: 64, offset: 128)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !2, file: !2, baseType: !20, size: 64, offset: 192)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 128, elements: !22)
!22 = !{!23, !24}
!23 = !DIDerivedType(tag: DW_TAG_member, scope: !2, file: !2, baseType: !18, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, scope: !2, file: !2, baseType: !25, size: 64, offset: 64)
!25 = !DIBasicType(name: "int32", size: 32, encoding: DW_ATE_signed)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "ringbuf", linkageName: "global", scope: !2, file: !2, type: !28, isLocal: false, isDefinition: true)
!28 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 128, elements: !29)
!29 = !{!30, !35}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !31, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 864, elements: !33)
!33 = !{!34}
!34 = !DISubrange(count: 27, lowerBound: 0)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !36, size: 64, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 8388608, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 262144, lowerBound: 0)
!40 = !DIGlobalVariableExpression(var: !41, expr: !DIExpression())
!41 = distinct !DIGlobalVariable(name: "event_loss_counter", linkageName: "global", scope: !2, file: !2, type: !42, isLocal: false, isDefinition: true)
!42 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !43)
!43 = !{!44, !49, !54, !56}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !45, size: 64)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 2, lowerBound: 0)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !50, size: 64, offset: 64)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 32, elements: !52)
!52 = !{!53}
!53 = !DISubrange(count: 1, lowerBound: 0)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !55, size: 64, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !2, file: !2, baseType: !17, size: 64, offset: 192)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "tuple_buf", linkageName: "global", scope: !2, file: !2, type: !59, isLocal: false, isDefinition: true)
!59 = !DICompositeType(tag: DW_TAG_array_type, baseType: !60, size: 256, elements: !52)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 256, elements: !47)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 128, elements: !63)
!62 = !DIBasicType(name: "int8", size: 8, encoding: DW_ATE_signed)
!63 = !{!64}
!64 = !DISubrange(count: 16, lowerBound: 0)
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "max_cpu_id", linkageName: "global", scope: !2, file: !2, type: !18, isLocal: false, isDefinition: true)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "fmt_str_buf", linkageName: "global", scope: !2, file: !2, type: !69, isLocal: false, isDefinition: true)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 256, elements: !52)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 256, elements: !52)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 256, elements: !72)
!72 = !{!73}
!73 = !DISubrange(count: 32, lowerBound: 0)
!74 = !DIGlobalVariableExpression(var: !75, expr: !DIExpression())
!75 = distinct !DIGlobalVariable(name: "num_cpus", linkageName: "global", scope: !2, file: !2, type: !18, isLocal: false, isDefinition: true)
!76 = distinct !DICompileUnit(language: DW_LANG_C, file: !2, producer: "bpftrace", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, globals: !77)
!77 = !{!0, !26, !40, !57, !65, !67, !74}
!78 = !{i32 2, !"Debug Info Version", i32 3}
!79 = distinct !DISubprogram(name: "kprobe_f_1", linkageName: "kprobe_f_1", scope: !2, file: !2, type: !80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !76, retainedNodes: !83)
!80 = !DISubroutineType(types: !81)
!81 = !{!18, !82}
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!83 = !{!84}
!84 = !DILocalVariable(name: "ctx", arg: 1, scope: !79, file: !2, type: !82)
!85 = distinct !DISubprogram(name: "map_for_each_cb", linkageName: "map_for_each_cb", scope: !2, file: !2, type: !80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !76, retainedNodes: !86)
!86 = !{!87}
!87 = !DILocalVariable(name: "ctx", arg: 1, scope: !85, file: !2, type: !82)

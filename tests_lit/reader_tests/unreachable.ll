; Test parsing unreachable instruction.

; RUN: llvm-as < %s | pnacl-freeze -allow-local-symbol-tables \
; RUN:              | %llvm2ice -notranslate -verbose=inst -build-on-read \
; RUN:                -allow-pnacl-reader-error-recovery \
; RUN:                -allow-local-symbol-tables \
; RUN:              | FileCheck %s

define internal i32 @divide(i32 %num, i32 %den) {
entry:
  %cmp = icmp ne i32 %den, 0
  br i1 %cmp, label %return, label %abort

abort:                                            ; preds = %entry
  unreachable

return:                                           ; preds = %entry
  %div = sdiv i32 %num, %den
  ret i32 %div
}

; CHECK:      define internal i32 @divide(i32 %num, i32 %den) {
; CHECK-NEXT: entry:
; CHECK-NEXT:   %cmp = icmp ne i32 %den, 0
; CHECK-NEXT:   br i1 %cmp, label %return, label %abort
; CHECK-NEXT: abort:
; CHECK-NEXT:   unreachable
; CHECK-NEXT: return:
; CHECK-NEXT:   %div = sdiv i32 %num, %den
; CHECK-NEXT:   ret i32 %div
; CHECK-NEXT: }

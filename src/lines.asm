; #########################################################################
;
;   lines.asm - Assembly file for CompEng205 Assignment 2
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA
	;; If you need to, you can place global variables here
	
.CODE
	
;;NAME: Graham Burleigh

;; Don't forget to add the USES the directive here
;;   Place any registers that you modify (either explicitly or implicitly)
;;   into the USES list so that caller's values can be preserved
	
;;   For example, if your procedure uses only the eax and ebx registers
;;      DrawLine PROC USES eax ebx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
DrawLine PROC USES eax ebx ecx edx esi edi x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	LOCAL deltx:DWORD, delty:DWORD, incx:DWORD, incy:DWORD, currx:DWORD, curry:DWORD, error:DWORD, preverr:DWORD
      mov eax, x1
      mov ebx, x0
      sub eax, ebx
      mov ebx, eax
      sar ebx, 31
      xor eax, ebx
      sub eax, ebx
      mov deltx, eax
      mov eax, y1
      mov ebx, y0
      sub eax, ebx
      mov ebx, eax
      sar ebx, 31
      xor eax, ebx
      sub eax, ebx
      mov delty, eax ;;Delta values calculated
      mov eax, x1
      mov ebx, x0
      cmp ebx, eax ;;First if check
      jl setIncx
      mov edi, 1
      neg edi
      mov incx, edi
      jmp AfterIncx ;;Move on if failed
setIncx:
      mov incx, 1
      jmp AfterIncx
AfterIncx:
      mov eax, y1
      mov ebx, y0
      cmp ebx, eax ;;Second if check
      jb setIncy
      mov edi, 1
      neg edi
      mov incy, edi
      jmp AfterIncy ;;Move on if failed
setIncy:
      mov incy, 1
      jmp AfterIncy
AfterIncy:
      mov eax, deltx ;;Inc. vals set, setting error
      mov ebx, delty
      cmp ebx, eax
      jg setErr
      sar ebx, 1
      neg ebx
      mov error, ebx ;;Error set
      jmp AfterErr
setErr:
      mov eax, error ;;Sets error depending on condition
      mov ebx, deltx
      sar ebx, 1
      mov eax, ebx
      mov error, eax
      jmp AfterErr
AfterErr:
      mov eax, x0
      mov ebx, y0
      mov currx, eax
      mov curry, ebx
      mov edx, color
      invoke DrawPixel, eax, ebx, edx ;;Draw at initial position
      jmp Eval
Eval:
      mov eax, currx ;;First eval. condition, exits loop if either fail
      mov ebx, x1
      cmp eax, ebx
      je EndCond
      jmp Eval1
Eval1:
      mov eax, curry ;;Second eval. condition
      mov ebx, y1
      cmp eax, ebx
      je EndCond
      jmp Do
Do:
      mov eax, currx ;;Loop contents, set prev. error and start drawing
      mov ebx, curry
      mov edx, color
      invoke DrawPixel, eax, ebx, edx
      mov eax, error
      mov preverr, eax
      mov eax, deltx
      neg eax
      mov ebx, preverr
      cmp ebx, eax
      jg IfCond ;;Check prev. error vs. deltx
      mov ecx, delty
      cmp ebx, ecx
      jl IfNew
      jmp AfterIf
IfCond:
      mov esi, error
      mov edi, delty
      mov edx, currx
      sub esi, edi
      add edx, incx
      mov currx, edx
      mov error, esi
      mov ebx, preverr
      mov ecx, delty
      cmp ebx, ecx ;;Check prev. error vs. delty
      jg AfterIf
      jmp IfNew
IfNew:
      mov esi, error
      mov edi, deltx
      mov edx, curry
      add esi, edi
      mov error, esi
      add edx, incy
      mov curry, edx
      jmp AfterIf
AfterIf:
      jmp Eval
EndCond:


	ret        	;;  Don't delete this line...you need it
DrawLine ENDP




END

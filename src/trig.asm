; #########################################################################
;
;   trig.asm - Assembly file for CompEng205 Assignment 3
;   name: Graham Burleigh
;   netID: gbb5412
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  Use reciprocal to find the table entry for a given angle
	                        ;;              (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
	
.CODE

FixedSin PROC USES ebx ecx edx esi edi angle:FXPT
LOCAL idx:DWORD
      mov ebx, OFFSET SINTAB
      mov ecx, angle
Init:
      mov idx, 0
      cmp ecx, 0
      jl EvalNegative
      cmp ecx, TWO_PI
      jg MoreThanTwo
      cmp ecx, PI_HALF
      jg MoreThanHalf
NormalCase:
      mov eax, PI_INC_RECIP
      imul ecx
      sal edx, 1
      movzx eax, WORD PTR [SINTAB + edx]
      cmp idx, 1
      jne Done
      neg eax
      jmp Done
MoreThanHalf:
      cmp ecx, PI
      jge MoreThanPi
      mov edi, PI
      sub edi, ecx
      mov ecx, edi
      jmp NormalCase
MoreThanPi:
      mov idx, 1
      sub ecx, PI
      cmp ecx, PI_HALF
      jg MoreThanHalf
      jl NormalCase
      mov ebx, PI_INC_RECIP
      mov eax, ecx
      imul ebx
      sal edx, 1
      movzx eax, WORD PTR [SINTAB + edx]
      mov edi, 0
      sub edi, eax
      mov eax, edi
      jmp Done
PiHalf:
      mov esi, PI
      sub esi, ecx
      mov ecx, esi
      jmp NormalCase
MoreThanTwo:
      sub ecx, TWO_PI
      jmp Init
EvalNegative:
      add ecx, TWO_PI
      jmp Init
Done:  
      ret
FixedSin ENDP 
	
FixedCos PROC angle:FXPT

	mov ebx, angle
      add ebx, PI_HALF
      invoke FixedSin, ebx

	ret			; Don't delete this line!!!	
FixedCos ENDP	
END

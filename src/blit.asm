; #########################################################################
;
;   blit.asm - Assembly file for CompEng205 Assignment 3
;   name: Graham Burleigh
;   netID: gbb5412
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA

	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES ebx ecx edx edi esi x:DWORD, y:DWORD, color:DWORD

LOCAL pos:DWORD
      mov esi, x
      mov edi, y
      cmp esi, 0
      jl Done
      cmp esi, 639
      jg Done
      cmp edi, 0
      jl Done
      cmp edi, 479
      jg Done                       ;;NECESSARY CHECKS PERFORMED, IF FAILED EXITS
      mov eax, y
      mov ecx, 640
      imul ecx
      mov ecx, color
      add eax, esi
      mov edx, ScreenBitsPtr        ;;OTHERWISE MOVE COLOR INTO SCREENBITSPTR AT PROPER INDEX
      mov BYTE PTR [edx + eax], cl
Done:
	ret 			
DrawPixel ENDP

BasicBlit PROC USES ebx ecx edx edi esi ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
LOCAL currx:DWORD, left:DWORD, right:DWORD
LOCAL curry:DWORD, bottom:DWORD, top:DWORD
LOCAL dwidth: DWORD, height:DWORD
LOCAL color:DWORD

      mov esi, ptrBitmap
      mov edi, (EECS205BITMAP PTR [esi]).dwWidth
      mov dwidth, edi
      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight           ;;ALLOCATE LOCALS
      mov height, ebx
      sar edi, 1
      sar ebx, 1
      mov eax, xcenter
      mov left, eax
      sub left, edi
      mov right, eax
      add right, edi
      mov eax, ycenter
      mov top, eax
      sub top, ebx
      mov bottom, eax
      add bottom, ebx
      mov ecx, (EECS205BITMAP PTR [esi]).lpBytes
      mov curry, 0
      mov currx, 0
      jmp Eval1
Loop1:
      mov currx, 0
      jmp Eval2                         ;;CHECK CURR. X VALUE, IF PASSED MOVE TO NEXT FOR CHECK
Loop2:
      mov eax, curry                    ;;CHECK CURR. Y VALUE, DO STUFF IF PASSED ELSE EXIT
      mov edi, dwidth
      imul edi
      add eax, ecx
      add eax, currx
      movzx ebx, BYTE PTR[eax]
      mov color, ebx
      movzx edx, BYTE PTR (EECS205BITMAP PTR [esi]).bTransparent                ;;TRANSPARENT CHECK
      cmp color, edx
      je IncX
      mov ebx, currx
      add ebx, left
      mov edx, curry
      add edx, top
      invoke DrawPixel, ebx, edx, color             ;;DRAWS IF NOT TRANSPARENT
IncX:
      inc currx
Eval2:
      mov eax, dwidth                       ;;EVAL BRANCH 2
      cmp eax, currx
      jg Loop2
      inc curry
Eval1:
      mov ebx, height                       ;;EVAL BRANCH 1
      cmp ebx, curry
      jg Loop1
      
    ret 			; Don't delete this line!!!	
BasicBlit ENDP


RotateBlit PROC USES ebx ecx edx edi esi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
LOCAL cosa:DWORD, sina:DWORD, shiftx:DWORD, shifty:DWORD
LOCAL dstwidth:DWORD, dstheight:DWORD, srcX:DWORD, srcY:DWORD
LOCAL dstX:DWORD, dstY:DWORD, widthX:DWORD, heightY:DWORD, temp:DWORD, color:DWORD
LOCAL xPix:DWORD, yPix:DWORD, currx:DWORD, curry:DWORD

      mov eax, angle
      invoke FixedSin, eax
      mov sina, eax
      mov eax, angle
      invoke FixedCos, eax          ;;GET SINE AND COSINE VALUES OF GIVEN ANGLE
      mov cosa, eax
      mov esi, lpBmp              ;;ALLOC. ESI WITH FIRST ELEM OF BITMAP
      
      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      sal ebx, 16
      mov eax, cosa
      sar eax, 1
      imul ebx
      mov widthX, edx

      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      sal ebx, 16
      mov eax, sina
      sar eax, 1
      imul ebx
      mov ebx, widthX
      sub ebx, edx
      mov shiftx, ebx

      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
      sal ebx, 16
      mov eax, cosa
      sar eax, 1
      imul ebx
      mov heightY, edx

      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      sal ebx, 16
      mov eax, sina
      sar eax, 1
      imul ebx
      mov ebx, heightY
      add ebx, edx
      mov shifty, ebx

      mov eax, (EECS205BITMAP PTR [esi]).dwWidth
      mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
	add eax, ebx
	mov dstwidth, eax
      mov dstheight, eax
      neg eax
      mov dstX, eax
      jmp EvalX                                     ;;ALL LOCAL VARIABLES ALLOCATED, ENTERING NESTED LOOPS
Loop1:
      mov eax, dstheight                            ;;FIRST LOOP STUFF
      neg eax
      mov dstY, eax
      jmp EvalY
Loop2:
      mov eax, dstX                                 ;;SECOND LOOP, BEGINS ROTATION OPERATIONS
      sal eax, 16
      mov ebx, cosa
      imul ebx
      mov temp, edx

      mov eax, dstY
      sal eax, 16
      mov ebx, sina
      imul ebx
      add edx, temp
      mov srcX, edx

      mov eax, dstY
      sal eax, 16
      mov ebx, cosa
      imul ebx
      mov temp, edx

      mov eax, dstX
      sal eax, 16
      mov ebx, sina
      imul ebx
      mov ebx, temp
      sub ebx, edx
      mov srcY, ebx
IfChecks:                                       ;;CHECKS ALL POSSIBILITIES, IF PASSED INCREMENTS Y AND DOESN"T DRAW
      mov eax, srcX
      cmp eax, 0
      jl IncY

      mov ebx, (EECS205BITMAP PTR [esi]).dwWidth
      cmp eax, ebx
      jge IncY

      mov eax, srcY
      cmp eax, 0
      jl IncY
      
	mov ebx, (EECS205BITMAP PTR [esi]).dwHeight
	cmp eax, ebx
	jge IncY

      mov eax, xcenter
      add eax, dstX
      sub eax, shiftx
      cmp eax, 0
      jl IncY

      cmp eax, 639
      jge IncY

      mov eax, ycenter
      add eax, dstY
      sub eax, shifty
      cmp eax, 0
      jl IncY

      cmp eax, 479
      jge IncY

      mov ecx, (EECS205BITMAP PTR [esi]).lpBytes
      mov eax, srcY
      mov edi, (EECS205BITMAP PTR [esi]).dwWidth
      imul edi
      add eax, ecx
      mov ebx, srcX
      add eax, ebx
      movzx ecx, BYTE PTR[eax]
      mov color, ecx
      movzx edx, BYTE PTR (EECS205BITMAP PTR [esi]).bTransparent
      cmp color, edx
      je IncY

      mov eax, xcenter
      add eax, dstX
      sub eax, shiftx
      mov xPix, eax

      mov eax, ycenter
      add eax, dstY
      sub eax, shifty
      mov yPix, eax

      invoke DrawPixel, xPix, yPix, color
IncY:
      inc dstY
EvalY:
      mov eax, dstY
      cmp eax, dstheight
      jl Loop2
      inc dstX
EvalX:
      mov eax, dstX
      cmp eax, dstwidth
      jl Loop1
Done:
	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END

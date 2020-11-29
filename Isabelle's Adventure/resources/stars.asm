; #########################################################################
;
;   stars.asm - Assembly file for CompEng205 Assignment 1
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc
      invoke DrawStar, 48, 64
      invoke DrawStar, 460, 180
      invoke DrawStar, 572, 396
      invoke DrawStar, 284, 212
      invoke DrawStar, 396, 128
      invoke DrawStar, 108, 144
      invoke DrawStar, 420, 460
      invoke DrawStar, 632, 176
      invoke DrawStar, 144, 192
      invoke DrawStar, 56, 208
      invoke DrawStar, 368, 224
      invoke DrawStar, 280, 240
      invoke DrawStar, 592, 256
      invoke DrawStar, 304, 272
      invoke DrawStar, 216, 288
      invoke DrawStar, 228, 304
      invoke DrawStar, 18, 34
      invoke DrawStar, 70, 50
      invoke DrawStar, 172, 296
      invoke DrawStar, 284, 412
      invoke DrawStar, 196, 128
      invoke DrawStar, 178, 44
      invoke DrawStar, 120, 16
      invoke DrawStar, 13, 176
      invoke DrawStar, 157, 308
      invoke DrawStar, 156, 108
      invoke DrawStar, 8, 224
      invoke DrawStar, 180, 75
      invoke DrawStar, 208, 450
      invoke DrawStar, 204, 320
      invoke DrawStar, 21, 288
      invoke DrawStar, 140, 304
      invoke DrawStar, 248, 364
      invoke DrawStar, 460, 180
      invoke DrawStar, 272, 396
      invoke DrawStar, 14, 212
      invoke DrawStar, 396, 178
      invoke DrawStar, 108, 344
      invoke DrawStar, 457, 460
      invoke DrawStar, 332, 176
      invoke DrawStar, 504, 192
      invoke DrawStar, 56, 208
      invoke DrawStar, 368, 224
      invoke DrawStar, 280, 240
      invoke DrawStar, 592, 256
      invoke DrawStar, 304, 272
      invoke DrawStar, 216, 288
      invoke DrawStar, 258, 304
      invoke DrawStar, 138, 341
      invoke DrawStar, 170, 250
      invoke DrawStar, 172, 296
      invoke DrawStar, 584, 412
      invoke DrawStar, 196, 128
      invoke DrawStar, 178, 44
      invoke DrawStar, 120, 16
      invoke DrawStar, 613, 176
      invoke DrawStar, 157, 308
      invoke DrawStar, 156, 108
      invoke DrawStar, 8, 224
      invoke DrawStar, 80, 175
      invoke DrawStar, 208, 50
      invoke DrawStar, 204, 20
      invoke DrawStar, 214, 463
      invoke DrawStar, 314, 453
      invoke DrawStar, 254, 413
      invoke DrawStar, 514, 463
      invoke DrawStar, 614, 363
      invoke DrawStar, 340, 304
      invoke DrawStar, 400, 80
      invoke DrawStar, 350, 90
      invoke DrawStar, 510, 32
	;; Place your code here

	ret  			; Careful! Don't remove this line
DrawStarField endp



END

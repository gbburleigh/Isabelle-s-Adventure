; #########################################################################
;
;   game.inc - Includes for CompEng205 Assignment 4/5
;
;
; #########################################################################

;; Library Definitions
MouseInfo STRUCT
 horiz DWORD ?
 vert  DWORD ?
 buttons DWORD ?
MouseInfo ENDS

TreeItem STRUCT
 x DWORD ?
 y DWORD ?
 bmpBytes BYTE PTR EECS205BITMAP
TreeItem ENDS

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD
EXTERNDEF spaceship:EECS205BITMAP
EXTERNDEF arnold:EECS205BITMAP
EXTERNDEF russmissile:EECS205BITMAP
EXTERNDEF pika:EECS205BITMAP
EXTERNDEF acbackground:EECS205BITMAP
EXTERNDEF isabelle_facing_left:EECS205BITMAP
EXTERNDEF logo:EECS205BITMAP
EXTERNDEF textbox:EECS205BITMAP
EXTERNDEF tomnook:EECS205BITMAP
EXTERNDEF textboxfixed:EECS205BITMAP
EXTERNDEF isabelle_facing_right:EECS205BITMAP
EXTERNDEF tomnook2:EECS205BITMAP
EXTERNDEF heart:EECS205BITMAP
EXTERNDEF apple:EECS205BITMAP
EXTERNDEF hive:EECS205BITMAP
EXTERNDEF textboxnew:EECS205BITMAP
EXTERNDEF leaf:EECS205BITMAP

;; User Defined Functions
GameInit PROTO
GamePlay PROTO
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 





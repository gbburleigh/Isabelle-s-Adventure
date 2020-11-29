; #########################################################################
;
;   game.asm - Assembly file for CompEng205 Assignment 4/5
;   Name: Graham Burleigh
;   NetID: gbb5412
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc
include bitmaplib.inc
include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib
include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib
include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib

include keys.inc

	
.DATA


;;******************** GLOBAL VARIABLES ************************

pausemsg BYTE "PAUSED", 0
winmsg BYTE "You Win!", 0
pauseStatus DWORD 0
fmtStr BYTE "SCORE: %d", 0
outStr BYTE 256 DUP(0)
fmtStrCount BYTE "Count: %d", 0
outStrCount BYTE 256 DUP(0)
fmtStrDebug BYTE "Status: %d", 0
helpStr1 BYTE "See README.txt for", 0
helpStr2 BYTE "play instructions", 0
outStrDebug BYTE 256 DUP(0)
score DWORD 0
SndPath BYTE "C:\Assign5_205\compeng205-assign-45\acmusic.wav",0
WinSnd BYTE "C:\Assign5_205\compeng205-assign-45\winmusic.wav",0
;;hurtSnd BYTE "C:\Users\insta\Desktop\compeng205-assign-45\oof.wav", 0
deadmsg BYTE "!GAME OVER!", 0
myname BYTE "Name: Graham Burleigh", 0
mynetid BYTE "NetID: gbb5412", 0
keyX DWORD 480
keyY DWORD 240
apple1X DWORD 0
apple1Y DWORD 0
apple2X DWORD 0
apple2Y DWORD 0
apple3X DWORD 0
apple3Y DWORD 0
hive1X DWORD 0
hive1Y DWORD 0
hive2X DWORD 0
hive2Y DWORD 0
heartX DWORD 0
heartY DWORD 0
leafX DWORD 0
leafY DWORD 0
apple1status DWORD 0
apple2status DWORD 0
apple3status DWORD 0
hive1Status DWORD 0
hive2Status DWORD 0
hivecount DWORD 75
count DWORD 50
heartStatus DWORD 0
heartCount DWORD 300
leafStatus DWORD 0
leafCount DWORD 600
boostStatus DWORD 0
faceLeft DWORD 0
liveCount DWORD 3
winStatus DWORD 0
playStatus DWORD 0

;;************************ ENDOF GLOBAL VARIABLES ********************

.CODE

;;********************************************************************************

;;Helper to increment score when hitting apple

IncScore PROC USES ebx
      mov ebx, score
      add ebx, 1
      mov score, ebx
      mov eax, ebx
Return:

      ret
IncScore ENDP

;;********************************************************************************

;;Helper to decrement score when hitting hive

DecScore PROC USES ebx
      mov ebx, score
      sub ebx, 1
      mov score, ebx
      mov eax, ebx
      ret
DecScore ENDP

;;********************************************************************************

;;Helper to decrement lives when hitting hive

DecLives PROC USES ebx
      mov ebx, liveCount
      sub ebx, 1
      mov liveCount, ebx
      mov eax, ebx
Return:

      ret
DecLives ENDP

;;********************************************************************************

;;Helper to add lives when hitting heart powerup

IncLives PROC USES ebx
      mov ebx, liveCount
      cmp liveCount, 3
      je Return
      add ebx, 1
      mov liveCount, ebx
      mov eax, ebx
Return:

      ret
IncLives ENDP

;;********************************************************************************

;;Update Isabelle's position based on current KeyPress reading

KeyCallLR PROC USES ebx
CheckRight:
      mov eax, KeyPress
      cmp eax, VK_RIGHT       
      jne CheckLeft           
      cmp keyX, 605
      jg CheckFace
      cmp boostStatus, 0
      jne BoostedRight
      inc keyX                
      inc keyX
      inc keyX
      inc keyX               
      inc keyX
      inc keyX
      mov faceLeft, 1
      mov eax, keyX           
      jmp CheckLeft
BoostedRight:

;;If powerup is on, speed is increased
      inc keyX                
      inc keyX
      inc keyX
      inc keyX                
      inc keyX
      inc keyX
      inc keyX               
      inc keyX
      inc keyX
      inc keyX
      inc keyX
      mov faceLeft, 1
      mov eax, keyX           
      jmp CheckLeft
CheckLeft:
      mov eax, KeyPress
      cmp eax, VK_LEFT    
      jne CheckFace
      cmp keyX, 135
      jl CheckFace
      cmp boostStatus, 0
      jne BoostedLeft
      dec keyX           
      dec keyX
      dec keyX
      dec keyX       
      dec keyX
      dec keyX
      mov faceLeft, 0
      mov eax, keyX
      jmp CheckFace
BoostedLeft:
      dec keyX         
      dec keyX
      dec keyX
      dec keyX            
      dec keyX
      dec keyX
      dec keyX           
      dec keyX
      dec keyX
      dec keyX
      dec keyX
      mov faceLeft, 0
      mov eax, keyX
      jmp CheckFace
CheckFace:
      mov ebx, faceLeft
      cmp ebx, 0
      je DrawItLeft
      jmp DrawItRight
DrawItRight:
      invoke BasicBlit, OFFSET isabelle_facing_right, keyX, 410
      jmp Return   
DrawItLeft:
      invoke BasicBlit, OFFSET isabelle_facing_left, keyX, 410
      jmp Return  
Return:

    ret
KeyCallLR ENDP

;;********************************************************************************

;;Helper to draw falling items while game is paused

TreeItemDraw PROC
      cmp apple1status, 0
      jne DrawApple1
      jmp Check2
DrawApple1:
      invoke BasicBlit, OFFSET apple, apple1X, apple1Y
      jmp Check2
Check2:
      cmp apple2status, 0
      jne DrawApple2
      jmp Check3
DrawApple2:
      invoke BasicBlit, OFFSET apple, apple2X, apple2Y
Check3:
      cmp apple3status, 0
      jne DrawApple3
      jmp CheckH1
DrawApple3:
      invoke BasicBlit, OFFSET apple, apple3X, apple3Y
CheckH1:
      cmp hive1Status, 0
      jne DrawHive1
      jmp CheckH2
DrawHive1:
      invoke BasicBlit, OFFSET hive, hive1X, hive1Y
CheckH2:
      cmp hive2Status, 0
      jne DrawHive2
      jmp CheckHeart
DrawHive2:
      invoke BasicBlit, OFFSET hive, hive2X, hive2Y
CheckHeart:
      cmp heartStatus, 0
      jne DrawHeartBr
      jmp CheckLeaf
DrawHeartBr:
      invoke BasicBlit, OFFSET heart, heartX, heartY
CheckLeaf:
      cmp leafStatus, 0
      jne DrawLeafBr
      jmp Return
DrawLeafBr:
      invoke BasicBlit, OFFSET leaf, leafX, leafY
Return:

      ret
TreeItemDraw ENDP

;;********************************************************************************

;;Draw paused sprites

PausedDraw PROC USES ebx
      mov ebx, faceLeft
      cmp ebx, 0
      je DrawItLeft
      jmp DrawItRight
DrawItRight:
      invoke BasicBlit, OFFSET isabelle_facing_right, keyX, 410
      jmp DrawItems 
DrawItLeft:
      invoke BasicBlit, OFFSET isabelle_facing_left, keyX, 410
      jmp DrawItems
DrawItems:
      invoke TreeItemDraw
Return:

    ret
PausedDraw ENDP

;;********************************************************************************

;;Helper to check for collisions between bitmaps

CheckIntersect PROC USES ebx ecx edx edi esi oneX:DWORD, oneY:DWORD, 
oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP

      xor eax, eax
      mov esi, oneBitmap
      mov edi, twoBitmap                        ;;ALLOCATE BITMAP POINTERS

      mov ecx, oneX
      mov edx, (EECS205BITMAP PTR [esi]).dwWidth
      shr edx, 1
      sub ecx, edx                              ;;ecx = oneX - width1/2

      mov ebx, twoX
      mov edx, (EECS205BITMAP PTR [edi]).dwWidth
      shr edx, 1
      add ebx, edx                              ;;ebx = twoX + width2/2
      cmp ecx, ebx                              ;;IF ECX GREATER, JUMP TO RETURN BRANCH
      jge Return

      mov ecx, oneX                             
      mov edx, (EECS205BITMAP PTR [edi]).dwWidth
      shr edx, 1
      add ecx, edx

      mov ebx, twoX
      mov edx, (EECS205BITMAP PTR [esi]).dwWidth
      shr edx, 1
      add ecx, edx
      cmp ecx, ebx                              ;;REPEAT CHECK FOR TWO ON RIGHT SIDE OF ONE
      jle Return                                ;;IF LESS JUMP TO RETURN

      mov ecx, oneY
      mov edx, (EECS205BITMAP PTR [esi]).dwHeight
      shr edx, 1
      sub ecx, edx

      mov ebx, twoY
      mov edx, (EECS205BITMAP PTR [edi]).dwHeight
      shr edx, 1
      add ebx, edx
      cmp ecx, ebx
      jge Return

      mov ecx, oneY
      mov edx, (EECS205BITMAP PTR [edi]).dwHeight
      shr edx, 1
      add ecx, edx

      mov ebx, twoY
      mov edx, (EECS205BITMAP PTR [esi]).dwHeight
      shr edx, 1
      add ecx, edx
      cmp ecx, ebx
      jle Return
      mov eax, 1
      
Return:
      
      ret
CheckIntersect ENDP

;;********************************************************************************

;;Helper to update heart/health display

LifeCheck PROC USES ebx
      mov ebx, liveCount
      cmp ebx, 3
      je DrawThree
      cmp ebx, 2
      je DrawTwo
      cmp ebx, 1
      je DrawOne
      jmp DrawDead
DrawThree:
      invoke BasicBlit, OFFSET heart, 70, 185
      invoke BasicBlit, OFFSET heart, 100, 185
      invoke BasicBlit, OFFSET heart, 130, 185
      jmp Return
DrawTwo:
      invoke BasicBlit, OFFSET heart, 70, 185
      invoke BasicBlit, OFFSET heart, 100, 185
      jmp Return
DrawOne:
      invoke BasicBlit, OFFSET heart, 70, 185
      jmp Return
DrawDead:
      mov pauseStatus, 1
      invoke DrawStr, OFFSET deadmsg, 280, 230, 000h
Return:
      
      ret
LifeCheck ENDP

;;********************************************************************************

;;If count is 0, spawn new apples. Otherwise, decrement count.
;;Essentially creates no more than three apples on an alternating order with random starting x pos.

UpdateApples PROC
      cmp count, 0
      je Spawn1
      jmp Update
Spawn1:
      cmp apple1status, 0
      jne Spawn2
      mov count, 50
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov apple1X, eax
      mov apple1Y, 0
      mov apple1status, 1
      jmp Update
Spawn2:
      cmp apple2status, 0
      jne Spawn3
      mov count, 50
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov apple2X, eax
      xor eax, eax
      mov apple2Y, 0
      mov apple2status, 1
      jmp Update
Spawn3:
      cmp apple3status, 0
      jne Return
      mov count, 50
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov apple3X, eax
      xor eax, eax
      mov apple3Y, 0
      mov apple3status, 1
      jmp Update
Update:
      dec count
Return:

      ret
UpdateApples ENDP

;;********************************************************************************

;;Helper to draw apple at given position/status

DrawApple PROC x:DWORD, y:DWORD, status:DWORD
      cmp status, 0
      je Return
      invoke BasicBlit, OFFSET apple, x, y
Return:

      ret
DrawApple ENDP

;;********************************************************************************

;;Helper to wrap up all DrawApple calls

DrawAllApples PROC 
      invoke UpdateApples
      invoke DrawApple, apple1X, apple1Y, apple1status
      invoke DrawApple, apple2X, apple2Y, apple2status
      invoke DrawApple, apple3X, apple3Y, apple3status
      inc apple1Y
      inc apple1Y
      inc apple1Y
      inc apple2Y
      inc apple2Y
      inc apple2Y
      inc apple3Y
      inc apple3Y
      inc apple3Y

      ret
DrawAllApples ENDP

;;********************************************************************************

;;Update hives using same method as updating apples

UpdateHives PROC
      cmp hivecount, 0
      je Spawn1
      jmp Update
Spawn1:
      cmp hive1Status, 0
      jne Spawn2
      mov hivecount, 75
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov hive1X, eax
      mov hive1Y, 0
      mov hive1Status, 1
      jmp Update
Spawn2:
      cmp hive2Status, 0
      jne Return
      mov hivecount, 75
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov hive2X, eax
      mov hive2Y, 0
      mov hive2Status, 1
      jmp Update
Update:
      dec hivecount
Return:

      ret
UpdateHives ENDP

;;********************************************************************************

;;Helper to draw hives on screen based on position/status

DrawHive PROC x:DWORD, y:DWORD, status:DWORD
      cmp status, 0
      je Return
      invoke BasicBlit, OFFSET hive, x, y
Return:

      ret
DrawHive ENDP

;;********************************************************************************

;;Helper to draw all hives

DrawAllHives PROC 
      invoke DrawHive, hive1X, hive1Y, hive1Status
      invoke DrawHive, hive2X, hive2Y, hive2Status
      invoke UpdateHives
      cmp hive1Y, 200
      jge Gravity1
      jmp Draw1
Gravity1:
      inc hive1Y
      inc hive1Y
      inc hive1Y
      inc hive1Y
      inc hive1Y
      jmp Check2
Draw1:
      inc hive1Y
      inc hive1Y
      inc hive1Y
      jmp Return
Check2:
      cmp hive2Y, 200
      jg Gravity2
      jmp Draw2
Gravity2:
      inc hive2Y
      inc hive2Y
      inc hive2Y
      inc hive2Y
      inc hive2Y
      jmp Return
Draw2:
      inc hive2Y
      inc hive2Y
      inc hive2Y
      jmp Return
Return:
      
      ret
DrawAllHives ENDP

;;********************************************************************************

;;Repeat update helper for Heart

UpdateHeart PROC
      cmp heartCount, 0
      jz Spawn1
      jmp Update
Spawn1:
      cmp heartStatus, 0
      jne Update
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov heartX, eax
      mov heartY, 0
      mov heartStatus, 1
      mov heartCount, 400
      jmp Update

Update:
      dec heartCount
      cmp heartCount, 0
      jz Return
Return:

      ret
UpdateHeart ENDP

;;********************************************************************************

;;Helper to draw heart with UpdateHeart

DrawHeart PROC
      invoke UpdateHeart
      cmp heartStatus, 0
      je Return
      invoke BasicBlit, OFFSET heart, heartX, heartY
      inc heartY
      inc heartY
Return:

      ret
DrawHeart ENDP

;;********************************************************************************


;;Begin with Animal Crossing Theme

GameInit PROC
	     invoke PlaySound, OFFSET SndPath, 0, SND_ASYNC

	     ret         
GameInit ENDP

;;********************************************************************************

;;Helper to get pause status

CheckPause PROC USES ebx
      mov eax, KeyPress
      cmp eax, VK_P
      jne Return
      mov ebx, pauseStatus
      cmp ebx, 0
      je PauseIt
      jmp UnpauseIt
PauseIt:
      mov pauseStatus, 1
      jmp Return
UnpauseIt:
      mov pauseStatus, 0
Return:
      mov eax, pauseStatus
      
      ret
CheckPause ENDP

;;********************************************************************************

;;HELPERS FOR UPDATING SCORE

      ;;Update score when touching apple1

UpdateScore1 PROC
      cmp apple1status, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, apple1X, apple1Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, apple1X, apple1Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
GotFruit:
      invoke IncScore
      mov apple1status, 0   
Return:

      ret
UpdateScore1 ENDP

      ;;Update score when touching apple2

UpdateScore2 PROC
      cmp apple2status, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, apple2X, apple2Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, apple2X, apple2Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
GotFruit:
      invoke IncScore
      mov apple2status, 0   
Return:

      ret
UpdateScore2 ENDP

      ;;Update score when touching apple3

UpdateScore3 PROC
      cmp apple3status, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, apple3X, apple3Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, apple3X, apple3Y, OFFSET apple
      cmp eax, 0
      jne GotFruit
      jmp Return
GotFruit:
      invoke IncScore
      mov apple3status, 0   
Return:

      ret
UpdateScore3 ENDP

      ;;UpdateScore wrapper

UpdateScores PROC
      invoke UpdateScore1
      invoke UpdateScore2
      invoke UpdateScore3
      
      ret
UpdateScores ENDP

;;********************************************************************************

;;HELPER FOR UPDATING HEALTH VALUES

UpdateLives1 PROC
      cmp hive1Status, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, hive1X, hive1Y, OFFSET hive
      cmp eax, 0
      jne DecLiveCount
      jmp CheckRight
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, hive1X, hive1Y, OFFSET hive
      cmp eax, 0
      jne DecLiveCount
      jmp CheckY
DecLiveCount:
      invoke DecScore
      invoke DecLives
      mov hive1Status, 0
      ;;invoke PlaySound, OFFSET hurtSnd, 0, SND_ASYNC
CheckY:
      cmp hive1Y, 460
      jge ChangeStatus
      jmp Return
ChangeStatus:
      mov hive1Status, 0
      jmp Return
Return:


      ret
UpdateLives1 ENDP

UpdateLives2 PROC
      cmp hive2Status, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, hive2X, hive2Y, OFFSET hive
      cmp eax, 0
      jne DecLiveCount
      jmp CheckRight
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, hive2X, hive2Y, OFFSET hive
      cmp eax, 0
      jne DecLiveCount
      jmp CheckY
DecLiveCount:
      invoke DecLives
      invoke DecScore
      mov hive2Status, 0
      ;;invoke PlaySound, OFFSET hurtSnd, 0, SND_ASYNC  
CheckY:
      cmp hive2Y, 460
      jge ChangeStatus
      jmp Return
ChangeStatus:
      mov hive2Status, 0
      jmp Return
Return:



      ret
UpdateLives2 ENDP

;;********************************************************************************

;;Helper for increasing health when heart pickup obtained

UpdateHealth PROC
      cmp heartStatus, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, heartX, heartY, OFFSET heart
      cmp eax, 0
      jne AddLife
      jmp CheckY
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, heartX, heartY, OFFSET heart
      cmp eax, 0
      jne AddLife
      jmp CheckY
AddLife:
      invoke IncLives
      jmp ChangeStatus
CheckY:
      cmp heartY, 460
      je ChangeStatus
      jmp Return
ChangeStatus:
      mov heartStatus, 0
      jmp Return
Return:

      ret
UpdateHealth ENDP

;;********************************************************************************

;;Helper for increasing speed boost when leaf pickup obtained

UpdateBoost PROC
      cmp leafStatus, 0
      je Return
      cmp faceLeft, 0
      je CheckLeft
      jmp CheckRight
CheckLeft:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_left, leafX, leafY, OFFSET leaf
      cmp eax, 0
      jne AddBoost
      jmp CheckY
CheckRight:
      invoke CheckIntersect, keyX, 410, OFFSET isabelle_facing_right, leafX, leafY, OFFSET leaf
      cmp eax, 0
      jne AddBoost
      jmp CheckY
AddBoost:
      mov boostStatus, 1
      jmp ChangeStatus
CheckY:
      cmp leafY, 460
      je ChangeStatus
      jmp Return
ChangeStatus:
      mov leafStatus, 0
      jmp Return
Return:

      ret
UpdateBoost ENDP

;;********************************************************************************

;;Spawn leaf if not present and count exhausted, then reset

UpdateLeaf PROC
      cmp leafCount, 0
      je Spawn1
      jmp Update
Spawn1:
      cmp leafStatus, 0
      jne Update
      mov leafCount, 600
      rdtsc
      invoke nseed, eax
      invoke nrandom, 360
      add eax, 200
      mov leafX, eax
      mov leafY, 0
      mov leafStatus, 1
      jmp Update

Update:
      dec leafCount
Return:

      ret
UpdateLeaf ENDP

;;********************************************************************************

;;Helper for drawing leaf on screen

DrawLeaf PROC
      invoke UpdateLeaf
      cmp leafStatus, 0
      je Return
      invoke BasicBlit, OFFSET leaf, leafX, leafY
      inc leafY
      inc leafY
Return:

      ret
DrawLeaf ENDP

;;********************************************************************************

;;UpdateLives wrapper

UpdateLives PROC
      invoke UpdateLives1
      invoke UpdateLives2
      
      ret
UpdateLives ENDP

;;********************************************************************************

;;Update heart position/status HELPER

UpdateHeartItem PROC
      invoke UpdateHeart
      invoke DrawHeart
      invoke UpdateHealth
      
      ret
UpdateHeartItem ENDP

;;********************************************************************************

;;Update leaf position/status HELPER

UpdateLeafItem PROC
      invoke UpdateLeaf
      invoke DrawLeaf
      invoke UpdateBoost
      
      ret
UpdateLeafItem ENDP

;;********************************************************************************
;; Helper to play winning music

WinSong PROC
      cmp playStatus, 1
      je Return
      invoke PlaySound, OFFSET WinSnd, 0, SND_ASYNC
Return:

      ret
WinSong ENDP

;;********************************************************************************
;;    !!!MAIN GAMEPLAY LOOP!!!    ;;

GamePlay PROC
      invoke BlackStarField 
      invoke BasicBlit, OFFSET acbackground, 320, 240
      invoke BasicBlit, OFFSET logo, 100, 100
      invoke BasicBlit, OFFSET tomnook2, 70, 410
      invoke BasicBlit, OFFSET textboxnew, 100, 325 
      invoke DrawStr, OFFSET myname, 20, 309, 000h
      invoke DrawStr, OFFSET mynetid, 20, 319, 000h
      invoke UpdateScores
      invoke LifeCheck
      invoke CheckPause
      cmp eax, 0
      jg Paused
      invoke DrawAllApples
      invoke DrawAllHives
      invoke UpdateHeartItem
      invoke UpdateLeafItem
      invoke UpdateLives
      invoke KeyCallLR                      
      jmp DisplayScore
Paused:
      invoke PausedDraw
      cmp winStatus, 1
      je DisplayScore
      invoke DrawStr, OFFSET pausemsg, 290, 240, 000h
      jmp DisplayScore
DisplayScore:
      mov eax, score
      push eax
      push offset fmtStr
      push offset outStr
      call wsprintf
      add esp, 12
      invoke DrawStr, offset outStr, 70, 155, 000h
      invoke DrawStr, offset helpStr1, 30, 275, 00h
      invoke DrawStr, offset helpStr2, 30, 285, 00h
      cmp score, 15
      jge GameOver
      jmp Return
GameOver:
      mov pauseStatus, 1
      mov winStatus, 1
      invoke DrawStr, OFFSET winmsg,  35, 230, 000h
      invoke WinSong
      mov playStatus, 1

;; Debugging Tools

;;DisplayCount:
;;      mov eax, heartCount
;;      push eax
;;      push offset fmtStrCount
;;      push offset outStrCount
;;     call wsprintf
;;      add esp, 12
;;      invoke DrawStr, offset outStrCount, 70, 235, 000h
;;DebugStatus:
;;      mov eax, heartStatus
;;      push eax
;;      push offset fmtStrDebug
;;      push offset outStrDebug
;;      call wsprintf
;;      add esp, 12
;;      invoke DrawStr, offset outStrDebug, 70, 245, 00h  
Return:

	     ret         
GamePlay ENDP

;;********************************************************************************


END

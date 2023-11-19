; board.asm
; author: francisco
; author: arayaroma
;
.8086
.model small

public BoardDriver     
public px, py, colorPaint
public pattern, collision
public scorePlayer, player_score_value

; file.asm
extrn OpenFile:far, getNextLine:far, CloseFile:far, driverValidate:far

; move.asm
extrn move:far, printPause:far
extrn playHit:far, playBonus:far
; mouse.asm
extrn ShowMouse:far, SetMousePosition:far, GetKeyPressed:far

; menu.asm
extrn MenuDriver:far

; option.asm
extrn nombre:byte, levelCount:byte, levelTxt:byte

;graphics.asm
extrn ClearScreen:far, PrintMessage:far, printRectangle:far
extrn PrintGameOverMessage:far

; score
extrn ConvertScoreTxt:far

.data 
    endless_runners     db "Endless Runners", '$'
    player_name         db "Player: ", '$'
    game_over_txt       db "Game Over", '$' 
    player_name_x       db 1
    player_name_y       db 14
    player_score        db "Score: ", '$'
    player_score_value  db 10 dup(" "), 10,13,'$'
    player_score_x      db 7
    player_score_y      db 42
    player_lives        db "Lives: ", '$'
    player_lives_cant   db 3, '$'
    player_lives_value  db 3, '$'
    player_lives_x      db 1
    player_lives_y      db 62
    pause_message       db "Press P to pause the game", '$'
    pause_message_x     db 28
    pause_message_y     db 4
    pattern             db 250 dup(' ')	,'$'
    nave                db "     n    ", '$'
    posNave             db 6
    collision           db 10 dup(' ') , '$'
    isMove              db 0
    px                  db 75
    colorPaint          db 66   
    py                  db 9
    highsize            dw 20
    contLine            db 0
    cont                db 0
    second              db 0
    isChangeSec         db 0
    miliSec             db 0
    gameDelay           db 0
    nextSeco            db 0
    minute              db 0
    isChange            db 0
    scorePlayer         dw 0
    levelTxtNumber      db 2 dup(' ') , '$'
    delayTxt            db 2 dup(' ') , '$'

.Code

clearPatter proc
    mov cx, 250
    lea si, pattern
    loopClear:
        mov al, ' '
        mov [si], al
        inc si
        loop loopClear
    mov scorePlayer, 0
    lea si,player_score_value
    mov cx,10
    loopClear2:
        mov al, ' '
        mov [di], al
        inc di
        loop loopClear2
ret
clearPatter endp

PrintHeaders proc near
    mov dh, 0
    mov dl, 33
    call SetMousePosition
    lea dx, endless_runners
    call PrintMessage

    mov dh, [player_name_x]
    mov dl, [player_name_y]
    call SetMousePosition
    lea dx, player_name
    call PrintMessage

    mov dh, [player_score_x]
    mov dl, [player_score_y+2]
    lea dx, nombre
    call PrintMessage

    mov dh, [player_lives_x]
    mov dl, [player_lives_y]
    call SetMousePosition
    lea dx, player_lives
    call PrintMessage

    mov dh, [player_lives_x]
    mov dl, [player_lives_y+2]
    xor cx, cx
    MOV Cl, player_lives_cant
    cmp cx, 0
    je endHeader
    printLives:
        lea dx, player_lives_value
        call PrintMessage

    loop printLives
    endHeader:
    call printLvl
    ret
PrintHeaders endp

PrintPauseMessage proc near
    mov dh, [pause_message_x]
    mov dl, [pause_message_y]
    call SetMousePosition
    lea dx, pause_message
    call PrintMessage
    ret
PrintPauseMessage endp

printScore proc near
    push ax dx 
    inc scorePlayer
    mov ax, scorePlayer
    lea di, player_score_value
    call ConvertScoreTxt
    mov dh, [player_score_x]
    mov dl, [player_score_y]
    call SetMousePosition
    lea dx, player_score
    call PrintMessage

    mov dh, [player_score_x]
    mov dl, [player_score_y+2]
    lea dx, player_score_value
    call PrintMessage
    pop dx ax
    ret
printScore endp

printLvl proc 
    mov dh, 7
    mov dl, 20
    call SetMousePosition
    lea dx, levelTxt
    call PrintMessage
    xor ax, ax
    mov al,levelCount
    lea di, levelTxtNumber
    call ConvertScoreTxt
    lea dx, levelTxtNumber
    call PrintMessage
ret
printLvl endp

caluDelay proc near
    xor cx, cx  
    mov cl,levelCount
    mov ax,99
    loopCalCu:
    sub ax, 5
    loop loopCalCu
    mov gameDelay, al
    
    endCaluDelay:
    xor ax, ax
    mov al,gameDelay
    lea di, delayTxt
    call ConvertScoreTxt
    mov dh, 0
    mov dl, 0
    call SetMousePosition
    lea dx, delayTxt
    call PrintMessage
    call printLvl
ret
caluDelay endp

board PROC far
push ax bx cx dx
mov cont, 0
mov contLine, 0
mov px, 77
mov py, 9
xor ax, ax

xor si, si
    lea si, pattern
    printPattern:
        mov cont,0
        printPiece:
            mov ah,[si]
            cmp ah, '$'
            je printNave
            cmp ah,' '
            je free
            cmp ah,'*'
            je notFree 

            cmp ah,'r'
            je upLevelC 
            cmp ah,'a'
            je upLive 
            cmp ah,'v'
            je downLevel 

            jne notFree
            free:
                mov colorPaint, 56
                call printRectangle
                jmp init
            notFree:
                mov colorPaint,3
                call printRectangle
                jmp init
            downLevel:
                mov colorPaint, 2
                call printRectangle
                jmp init
            upLevelC:
                mov colorPaint, 4
                call printRectangle
                jmp init
            upLive:
                mov colorPaint, 1
                call printRectangle
                jmp init
            init:
                inc py  ; increment py position to next row
                inc si
                inc cont
                cmp cont, 10
                je pass
        jmp printPiece
        pass:
        mov py, 9 ; reset py position
        sub px, 3 ; increment px position to next col
        je printNave 
    jmp printPattern
    printNave:
       ; mov py, 9 ; reset py position
      ;  sub px, 3 ; increment px position to next col
        lea si, nave
        mov cont,0
        pieceNave:
            mov ah,[si]
            cmp ah, '$'
            je printNave
            cmp ah,' '
            je freeNave 
            jne notfreeNave
            freeNave:
                mov colorPaint, 56
                call printRectangle
                jmp nextPiece
            notfreeNave:
                cmp ah, 'n'
                je naveNormal
                cmp ah, 'N'
                je naveColicion
                cmp ah,'*'
                je obstaculo
                mov colorPaint, 56
                call printRectangle
                jmp nextPiece
                naveNormal:
                mov colorPaint, 5
                jmp nextPiece
                naveColicion:
                mov colorPaint, 0
                jmp nextPiece
                obstaculo:
                mov colorPaint, 3
                
            nextPiece:
            call printRectangle
                inc py  ; increment py position to next row
                inc si
                inc cont
                cmp cont, 10
                je endNave
                jmp pieceNave
        endNave:
    pop dx cx bx ax
    ret
board ENDP



isMoveNave proc 
 
    xor ax, ax
    MOV ah,0bh
    int 21h
    cmp al, 0
    je endNoMove

    mov ah,00h
    int 16h

    cmp ax,0
    je endNoMove
    cmp al, 119 ;  w 
    je moveUp
    cmp al, 115 ; s
    je moveDown
    cmp ah, 48h
    je moveUp
    cmp ah, 50h
    je moveDown

    cmp al, 112 ;p ascii code 112
    je pause
    jmp endNoMove
    moveUp:
        cmp posNave, 1
        je endMove
        lea si, nave
        loopToN:
        mov al, [si]
        cmp al, 'n'
        je moveNaveUp
        cmp al,'N'
        je moveNaveUp
        inc si 
        jmp loopToN
        moveNaveUp:
        dec posNave
        mov al, ' '
        mov [si], al
        mov al, 'n'
        mov [si-1], al

        jmp endMove 
    moveDown:
        cmp posNave, 10
        je endMove
        lea si, nave
        loopToNe:
        mov al, [si]
        cmp al, 'n'
        je moveNaveDown
        cmp al,'N'
        je moveNaveDown
        inc si 
        jmp loopToNe
        moveNaveDown:
        inc posNave
        mov al, ' '
        mov [si], al
        mov al, 'n'
        mov [si+1], al
        jmp endMove
    pause:
        call pauseGame
    endMove:
    call ColitionCmp
    call board 
    endNoMove:  
ret
isMoveNave endp

pauseGame proc near
  
    call ClearScreen
    call printPause
    loopPause:
    mov ah, 0
    int 16h
    cmp al, 112
    jne loopPause
    call PrintHeaders
    call board
    mov ah,2ch
	int 21h
    mov second, dh
    inc second
    cmp second, 60
    jne endPause
    mov second, 0
    endPause:
    
ret
pauseGame endp
lostLiveProc proc near
    call playHit
    dec player_lives_cant
    call ClearScreen
    call PrintHeaders
    call board
   
    cmp player_lives_cant, 0
    je endGame
    jmp endLostLive

    endGame:
    call CloseFile
    call game_over
    
    endLostLive:
    ret
lostLiveProc endp

ColitionCmp proc

    lea si, collision
    lea di, nave
    mov bl,'n'
    mov bh,'N'
    loopColition:
        mov al, [si]
        cmp al, '$'
        je endColition
            mov ah, [di]
            cmp ah, 'n'
            je naveColicion2
            cmp ah, 'N'
            je naveColicion2
            mov [di],al
            inc si
            inc di
            jmp loopColition
            naveColicion2:
            cmp al,'*'
            je lostLive
            cmp al,'a'
            je getLive
            cmp al,'r'
            je upLevelCmp
            cmp al,'v'
            je decLevel

            mov [di],bl
            jmp freeColision
            lostLive:
                mov [di],bh
                call lostLiveProc
                jmp freeColision
            getLive:
                mov [di],bl
                call up_love
                jmp freeColision
            upLevelCmp:
                mov [di],bl
                call upLevelProc
                jmp freeColision
            decLevel:
                mov [di],bl
                call decLevelProc
                jmp freeColision
            freeColision:
            inc si
            inc di
            jmp loopColition
        endColition:
        

    ret
ColitionCmp endp

decLevelProc proc near
    cmp levelCount, 1
    je endDecLevel
    call playBonus
    dec levelCount
    call caluDelay
    endDecLevel:
ret
decLevelProc endp

upLevelProc proc near
    cmp levelCount, 15
    je endUpLevel
    inc levelCount
    call playBonus
    cmp levelCount, 15
    je endUpLevel
    inc levelCount
    
    endUpLevel:
    call caluDelay
ret
upLevelProc endp

up_love proc near
    cmp player_lives_cant, 3
    je endUpLove
    call playBonus
    inc player_lives_cant
    call PrintHeaders
    endUpLove:
ret
up_love endp

delay proc near
	mov ah,2ch
	int 21h
    cmp second,0
    je second0
    cmp dh, second
    ja operaciones
    jne endDelay
    cmp dl, miliSec
    jb endDelay
    jmp operaciones
    second0:
        cmp dh, 59
        jnb endDelay

        cmp dh, second
        ja operaciones

        cmp dl, miliSec
        jb endDelay
        
    operaciones:
        call getNextLine
        call move
        push ax bx cx dx si di
        call ColitionCmp
        call board
        call printScore
        pop di si dx cx bx ax 
        mov second, dh
        mov bh, gameDelay
        mov miliSec, dl
        add miliSec, bh
        cmp miliSec, 99
        jnb Ajust
        jmp endDelay
    Ajust:
    sub miliSec, 99
    inc second
    cmp second, 60
    jne endDelay
    mov second, 0
    endDelay:
    
    ret
delay endp



restSecond proc 
	mov ah,2ch
	int 21h
	mov nextSeco, dh
	mov minute, cl
	add nextSeco, 20
	cmp nextSeco, 60
	jnb ajuste
	mov isChange,0
	jmp endreset
	ajuste:
		sub nextSeco,60
		mov isChange, 1 
	endreset:
	
	ret

restSecond endp


cronom20 proc 
	mov ah,2ch
	int 21h

	cmp isChange,1
	je changeMinu
	jne noEsperaCambio
	
	changeMinu:
		cmp minute, cl
		je endcom
		cmp dh,nextSeco
		jnb upLevel
		jmp endcom
	noEsperaCambio:
		cmp dh,nextSeco
		jnb upLevel
		jmp endcom
	upLevel:
		call restSecond
        
        cmp levelCount,15
        je endUpLvl
        inc levelCount
        call caluDelay
        
        endUpLvl:
	endcom:

ret
cronom20 endp

BoardDriver proc far
    mov player_lives_cant, 3
    call restSecond
    call PrintHeaders
    call PrintPauseMessage
    call OpenFile   
    call ShowMouse
    call clearPatter
    call board
    call caluDelay
    call printScore

    playing:
    call cronom20
    call isMoveNave
    call delay    
    jmp playing


    ret
BoardDriver endp





game_over proc near
    call ClearScreen
    call driverValidate
    call clear_register

    call PrintGameOverMessage
    call GetKeyPressed
    call MenuDriver
ret
game_over endp

clear_register proc 
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor di, di
    xor si, si
ret
clear_register endp

end
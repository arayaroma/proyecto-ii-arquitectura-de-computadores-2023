; board.asm
; author: francisco
;
.8086
.model small

public BoardDriver     
public px, py, colorPaint
public pattern, collision

; file.asm
extrn OpenFile:far, getNextLine:far, CloseFile:far

; move.asm
extrn move:far           

; option.asm
extrn nombre:byte
extrn levelCount:byte
; mouse.asm
extrn ShowMouse:far
extrn SetMousePosition:far

;graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far
extrn printRectangle:far


.data 
    endless_runners     db "Endless Runners", '$'
    player_name         db "Player: ", '$'
    player_name_x       db 1
    player_name_y       db 14
    player_score        db "Score: ", '$'
    player_score_value  db "0", '$'
    player_score_x      db 1
    player_score_y      db 38
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
    gameDelay           db 40
    nextSeco            db 0
    minute              db 0
    isChange            db 0 
.Code

PrintHeaders proc near
    mov dh, 0
    mov dl, 34
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

    mov dh, [player_score_x]
    mov dl, [player_score_y]
    call SetMousePosition
    lea dx, player_score
    call PrintMessage

    mov dh, [player_score_x]
    mov dl, [player_score_y+2]
    lea dx, player_score_value
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

caluDelay proc near
    cmp levelCount, 1
    je level1
    cmp levelCount, 2
    je level2
    cmp levelCount, 3
    je level3
    cmp levelCount, 4
    je level4
    cmp levelCount, 5
    je level5
    cmp levelCount, 6
    je level6
    cmp levelCount, 7
    je level7
    cmp levelCount, 8
    je level8
    cmp levelCount, 9
    je level9
    cmp levelCount, 10
    je level10
    cmp levelCount, 11
    je level11
    cmp levelCount, 12
    je level12
    cmp levelCount, 13
    je level13
    cmp levelCount, 14
    je level14
    cmp levelCount, 15
    je level15


    ; UP LVE  gameDelay = 100*0.95 
    level1:
    mov gameDelay, 100
    jmp endCaluDelay
    level2:
    mov gameDelay, 95
    jmp endCaluDelay
    level3:
    mov gameDelay, 90
    jmp endCaluDelay
    level4:
    mov gameDelay, 85
    jmp endCaluDelay
    level5:
    mov gameDelay, 80
    jmp endCaluDelay
    level6:
    mov gameDelay, 75
    jmp endCaluDelay
    level7:
    mov gameDelay, 70
    jmp endCaluDelay
    level8:
    mov gameDelay, 65
    jmp endCaluDelay
    level9:
    mov gameDelay, 60
    jmp endCaluDelay
    level10:
    mov gameDelay, 55
    jmp endCaluDelay
    level11:
    mov gameDelay, 50
    jmp endCaluDelay
    level12:
    mov gameDelay, 45
    jmp endCaluDelay
    level13:
    mov gameDelay, 40
    jmp endCaluDelay
    level14:
    mov gameDelay, 35
    jmp endCaluDelay
    level15:
    mov gameDelay, 30
    jmp endCaluDelay
    endCaluDelay:
    
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
            jne notFree
            free:
                mov colorPaint, 01
                call printRectangle
                jmp init
            notFree:
                mov colorPaint, 66
                call printRectangle
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
                mov colorPaint, 01
                call printRectangle
                jmp nextPiece
            notfreeNave:
                cmp ah, 'n'
                je naveNormal
                cmp ah, 'N'
                je naveColicion
                cmp ah,'*'
                je obstaculo
                naveNormal:
                mov colorPaint, 5
                jmp nextPiece
                naveColicion:
                mov colorPaint, 4
                jmp nextPiece
                obstaculo:
                mov colorPaint, 66
                
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


  ;  cmp isMove, 1
    ;je endMove


    cmp ax,0
    je endNoMove
    cmp al, 119 ;  w 
    je moveUp
    cmp al, 115 ; s
    je moveDown
    ;cmp al, 112 ;p ascii code 112
  ;  mov isMove, 0
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

    endMove:
    call ColitionCmp
    call board 
    endNoMove:  
ret
isMoveNave endp

lostLiveProc proc near
    cmp player_lives_cant, 0
    je endGame
    dec player_lives_cant

    call ClearScreen
    call PrintHeaders
    call PrintPauseMessage
    call board
    endGame:
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
            cmp al,'c'
            je getPoint
            mov [di],bl
            jmp freeColision
            lostLive:
                mov [di],bh
                call lostLiveProc
                jmp freeColision

                ;TODO: restar vidas
                ;TODO: verificar si se perdio
                ;TODO: Sonido colision
            getPoint:
                mov [di],bl
                jmp freeColision
            freeColision:
            inc si
            inc di
            jmp loopColition
        endColition:
        

    ret
ColitionCmp endp



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
        jne endDelay
        cmp dl, miliSec
        jb endDelay
        
    operaciones:
        call getNextLine
        call move
        call ColitionCmp
        call board
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
    ; mov ah, 02
    ; mov dl, "s"
    ; int 21h
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
    call restSecond
    call PrintHeaders
    call PrintPauseMessage
    call OpenFile   
    call ShowMouse
    call board
    call caluDelay
    go:
    call cronom20
    call isMoveNave
    call delay    
    jmp go
    call CloseFile
    ret
BoardDriver endp

end
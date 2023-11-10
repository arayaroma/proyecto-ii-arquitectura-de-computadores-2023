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
    player_live_one     db 3, '$'
    player_live_two     db 3, '$'
    player_live_three   db 3, '$'
    player_lives_x      db 1
    player_lives_y      db 62
    pause_message       db "Press P to pause the game", '$'
    pause_message_x     db 20
    pause_message_y     db 4
    pattern             db 250 dup(' ')	,'$'
    nave                db "     n    ", '$'
    collision           db 10 dup(' ') , '$'
    isMove              db 0
    px                  db 75
    colorPaint          db 66   
    py                  db 9
    highsize            dw 20
    contLine            db 0
    cont                db 0

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
    lea dx, player_live_one
    call PrintMessage

    mov dl, [player_lives_y+3]
    lea dx, player_live_two
    call PrintMessage

    mov dl, [player_lives_y+4]
    lea dx, player_live_three
    call PrintMessage
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

board PROC far
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
                mov colorPaint, 1
                call printRectangle
                jmp nextPiece
            notfreeNave:
                mov colorPaint, 5
                call printRectangle
            nextPiece:
                inc py  ; increment py position to next row
                inc si
                inc cont
                cmp cont, 10
                je endNave
                jmp pieceNave
        endNave:
    ret
board ENDP

delay proc far
    ; operacion con el nivel 
    MOV     CX, 0FH
    MOV     DX, 4240H
    MOV     AH, 86H
    INT     15H
    ret
delay endp

isMoveNave proc 
    xor ax, ax
    MOV ah,0bh
    int 21h
    cmp al, 0
    je endMove

    mov ah,00h
    int 16h

    cmp al,0
    je isMoveNaveZero
  ;  cmp isMove, 1
    ;je endMove


    cmp ax,0
    je endMove
    cmp al, 119 ;  w 
    je moveUp
    cmp al, 115 ; s
    je moveDown
    ;cmp al, 112 ;p ascii code 112
  ;  mov isMove, 0
    jmp endMove
    moveUp:
       ; mov isMove, 1
        lea si, nave
        loopToN:
        mov al, [si]
        cmp al, 'n'
        je moveNaveUp
        inc si 
        jmp loopToN
        moveNaveUp:
        mov al, ' '
        mov [si], al
        mov al, 'n'
        mov [si-1], al
        call board
        ret 
    moveDown:
       ; mov isMove, 1
        lea si, nave
        loopToNe:
        mov al, [si]
        cmp al, 'n'
        je moveNaveDown
        inc si 
        jmp loopToNe
        moveNaveDown:
        mov al, ' '
        mov [si], al
        mov al, 'n'
        mov [si+1], al
        call board
            ret
    isMoveNaveZero:
  ;  mov isMove, 0
    endMove:
ret
isMoveNave endp

BoardDriver proc far
    call PrintHeaders
    call PrintPauseMessage
    call OpenFile
    go:
    push si
    call isMoveNave
    pop si
    call board
    call ShowMouse
    call getNextLine
    call move

    push cx
    call delay
    pop cx
    jmp go
    call CloseFile
    ret
BoardDriver endp

end
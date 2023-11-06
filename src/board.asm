.MODEL SMALL

extrn printRectangle:far
public px, py, colorPaint
public BoardDriver     
extrn move:far           
extrn openFilePatron:far ,getNextLine:far , closePatron:far
public pattern, collision
extrn ClearScreen:far
extrn ShowMouse:far
extrn SetMousePosition:far
extrn PrintMessage:far
.data 

    pattern db 250 dup(' ')	,'$'
    nave db "     n    ", '$'
    collision db 10 dup(' ') , '$'
    isMove db 0
    px db 75
    colorPaint db 66   
    py db 9
    highsize dw 20


    contLine db 0
    cont db 0
.Code

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

    mov ah,01h
    int 16h

    cmp ax,0
    je isMoveNaveZero
    mov ah,02
    mov dl,al
    int 21h
    cmp isMove, 1
    je endMove

    mov ah,02
    mov dl,al
    int 21h

    cmp ax,0
    je endMove
    cmp al, 119
    je moveUp
    cmp al, 115
    je moveDown
    mov isMove, 0
    jmp endMove
    moveUp:
        mov isMove, 1
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
        mov isMove, 1
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
    mov isMove, 0
    endMove:
ret
isMoveNave endp

BoardDriver proc far

    call openFilePatron
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
    call closePatron
    ret
BoardDriver endp

end
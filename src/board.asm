.MODEL SMALL

extrn printRectangle:far
public px, py, colorPaint
public board, BoardDriver     
extrn move:far           
extrn pattern:byte
extrn delay:far
extrn openFilePatron:far ,getNextLine:far , closePatron:far

extrn ClearScreen:far
extrn ShowMouse:far
extrn SetMousePosition:far
extrn PrintMessage:far
.data 

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
mov px, 75
mov py, 9
xor ax, ax

xor si, si
    lea si, pattern
    printPattern:
        mov cont,0
        printPiece:
            mov ah,[si]
            cmp ah, '$'
            je endPattern
            cmp ah,' '
            je free 
            jne notFree
            free:
                mov colorPaint, 1
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
        je endPattern 
    jmp printPattern
    endPattern:

    ret
board ENDP

BoardDriver proc far

    call openFilePatron
    go:
    call ClearScreen



    push si di 
    call board
    pop si di

    call ShowMouse
    call getNextLine
    push si di
    call move
    pop si di
    call delay

    jmp go
    call closePatron
    ret
BoardDriver endp

end
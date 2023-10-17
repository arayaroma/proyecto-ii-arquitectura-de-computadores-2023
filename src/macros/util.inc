waitEvent macro
    mov ah, 00H ; wait for keypress
    int 16H 
endm
;==============================================================================
printPoint macro x, y, color
    mov ah, 0ch
    mov al,color                ; color of the point
    mov bh,0					; page any as 0 
    mov cx, y                   ; x coordinate
    mov dx, x                   ; y coordinate
    int 10h                     ; call BIOS video interrupt
endm

printHoriLine macro row, col, color, len
    mov cx, len 
    prtCol:
        push cx
            printPoint row col color ; print point
        pop cx
        inc col ; increment col position
    loop prtCol
endm

printVertLine macro row, col, color, len
    mov cx, len 
    prtRow:
        push cx
            printPoint row col color ; print point
        pop cx
        inc row ; increment col position
    loop prtRow
endm



printSquare macro row, col, color, len
    push cx
    mov cx, len
    prtRowOfSquare:
        push cx
            printHoriLine row col color len
        pop cx
        inc col
    loop prtRowOfSquare
    endm
waitEvent macro
    mov ah, 00H ; wait for keypress
    int 16H 
endm
;==============================================================================
printPoint macro x, y, color
    mov ah, 0ch
    mov al,color                ; color of the point
    mov bh,0					; page any as 0 
    mov cx, x                   ; x coordinate
    mov dx, y                   ; y coordinate
    int 10h                     ; call BIOS video interrupt
endm

printHoriLine macro col, row, color, len
    mov cx, len 
    prtCol:
        push cx
            printPoint col row color ; print point
        pop cx
        inc row ; increment row position
    loop prtCol
endm

printVertLine macro col, row, color, len
    mov cx, len 
    prtRow:
        push cx
            printPoint col row color ; print point
        pop cx
        inc col ; increment row position
    loop prtRow
endm



printSquare macro col, row, color, len
    push cx
    mov cx, len
    prtRowOfSquare:
        push cx
            printHoriLine col row color len
        pop cx
        inc row
    loop prtRowOfSquare
    endm
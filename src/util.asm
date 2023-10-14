public printPoint, waitEvent

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

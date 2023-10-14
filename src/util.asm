

waitEvent macro
    mov ah, 00H ; wait for keypress
    int 16H 
endm

;==============================================================================
printPoint macro x, y , color
    mov ah, 0ch
    mov al,color                   ; color TODO: PASS COLOR BY PARAMETER
    mov bh,0					; pagina 
    mov cx, x
    mov dx, y             
    int 10h
endm

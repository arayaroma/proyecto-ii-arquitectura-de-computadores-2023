.model small
.stack 100H
.data
    titleText db 'Endless Runners', 10, 13, '$'
    playText db 'Play', 10, 13, '$'
    row db ?
    col db ?

printMessage macro message
    mov ah, 09H
    lea dx, message
    int 21H
endm

waitEvent macro
    mov ah, 00H
    int 16H
endm

.code

;function to set cursor position
public pos
pos proc 
    mov ah, 02H
    mov bh, 00h
    mov dh, col
    mov dl, row
    int 10H
    ret
pos endp

public clearScreen
clearScreen proc
    mov ax, 0600H
    mov bh, 17H
    mov cx, 0000H
    mov dx, 184FH
    int 10h
    ret
clearScreen endp

public printMenu
printMenu proc far
    call clearScreen
    waitEvent
    mov row, 0
    mov col, 0
    call pos
    printMessage titleText
    waitEvent
    ret
printMenu endp

end
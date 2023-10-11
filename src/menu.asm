public printMenu, clearScreen
.model small

.data
titleText db '[Endless Runners]', '$'
playText db 'Play', '$'
stageText db 'Stage', '$'
aboutText db 'About', '$'

axisYOffset db ?
axisXOffset db ?

cursorRow db ?
cursorCol db ?

waitEvent macro
    mov ah, 00H
    int 16H
endm

printMessage macro msg
    mov ah, 09H
    lea dx, msg
    int 21H
endm
setMousePosition macro x, y 
    mov ah, 02H
    mov bh, 00H
    mov dh, x
    mov dl, y
    int 10H
endm

.code

clearScreen proc far
    mov ax, 0600H
    mov bh, 00H
    mov cx, 0000H
    mov dx, 184FH
    int 10H
    ret
clearScreen endp

printMenu proc far

    mov axisXOffset, 8
    mov axisYOffset, 31

    setMousePosition axisXOffset, axisYOffset
    printMessage titleText

    add axisXOffset, 3
    add axisYOffset, 6
    setMousePosition axisXOffset, axisYOffset
    printMessage playText

    add axisXOffset, 3
    setMousePosition axisXOffset, axisYOffset
    printMessage stageText

    add axisXOffset, 3
    setMousePosition axisXOffset, axisYOffset
    printMessage aboutText
    ret
printMenu endp
end
.8086
.model small
public menuDriver
extrn clearScreen:far
extrn setVideoMode:far
extrn getMousePosition:far
extrn ShowMouse:far

extrn mouseX:byte
extrn mouseY:byte

.data

titleText db '[Endless Runners]', '$'
playText db 'Play', '$'
stageText db 'Stage', '$'
aboutText db 'About', '$'


axisYOffset db ?
axisXOffset db ?


waitEvent macro
    mov ah, 00H
    int 16H
endm

printMessage macro msg
    mov ah, 09H
    lea dx, msg
    int 21H
endm

; setMouseCursor macro
setMousePosition macro x, y 
    mov ah, 02H
    mov bh, 00H
    mov dh, x
    mov dl, y
    int 10H
endm

.code

printMenu proc far
    mov axisXOffset, 8
    mov axisYOffset, 31

    setMousePosition axisXOffset, axisYOffset
    printMessage titleText

    add axisYOffset, 6
    add axisXOffset, 3
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

menuDriver proc far
    call setVideoMode
    call clearScreen
    call printMenu
    call ShowMouse

menuDriver endp

end
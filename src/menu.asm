.8086
.model small
public MenuDriver

; graphics.asm
extrn ClearScreen:far
extrn SetVideoMode:far
extrn PrintMessage:far

; ascii.asm
extrn ConvertToASCII:far
extrn DisplayASCII:far

; mouse.asm
extrn GetMousePosition:far
extrn SetMousePosition:far
extrn ShowMouse:far
extrn mouseXText:byte
extrn mouseYText:byte
extrn mouseX:word
extrn mouseY:word

.data

titleText db '[Endless Runners]', '$'
playText db 'Play', '$'
stageText db 'Stage', '$'
aboutText db 'About', '$'

axisYOffset db ?
axisXOffset db ?

.code

; PrintMenu
;
; This procedure will print the menu on the screen.
PrintMenu proc far
    mov axisXOffset, 8
    mov axisYOffset, 31

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset titleText 
    call PrintMessage

    add axisYOffset, 6
    add axisXOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset playText
    call PrintMessage

    add axisXOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset stageText
    call PrintMessage

    add axisXOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset aboutText
    call PrintMessage
    ret
PrintMenu endp

; LoadMouseText
;
; This procedure will load the mouse text on the screen.
LoadMouseText proc near
    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset mouseXText
    call PrintMessage 

    mov dh, 1
    mov dl, 0
    call SetMousePosition

    mov dx, offset mouseYText
    call PrintMessage 
    ret
LoadMouseText endp

; MouseCoordinatesLoop
;
; This procedure will loop forever and display the
; mouse coordinates on the screen.
MouseCoordinatesLoop proc near
    mouseLoop:
    mov dh, 0
    mov dl, 8
    call SetMousePosition
    xor dx, dx
    call GetMousePosition
    mov ax, [mouseX]
    call ConvertToASCII

    mov dh, 1
    mov dl, 8
    call SetMousePosition
    xor dx, dx
    call GetMousePosition
    mov ax, [mouseY]
    call ConvertToASCII
    jmp mouseLoop
    ret
MouseCoordinatesLoop endp

; MenuDriver
;
; This procedure is the main driver for the menu.
; It will call all the other procedures to display
; the menu and handle the mouse.
MenuDriver proc far
    call SetVideoMode
    call ShowMouse
    call ClearScreen
    call PrintMenu
    call LoadMouseText
    call MouseCoordinatesLoop
    ret
MenuDriver endp

end
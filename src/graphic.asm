; graphic.asm
; author: arayaroma
;
.8086
.model small
public printRectangle, PrintBackButton
public SetVideoMode, ClearScreen, PrintMessage

; about.asm
extrn GoBackMenu:far

; mouse.asm
extrn SetMousePosition:far

; rectangle.asm
extrn px:byte, py:byte, colorPaint:byte
extrn printLine:far 

.data
    button_label    db 'Back', '$'
    axis_x          db ?
    axis_y          db ?

.code

;   SetVideoMode
;
;   Sets the video mode to 16-color VGA 640x480
;   Input: none
;   Output: none
SetVideoMode proc far
    mov ax, 0012H
    int 10h
    ret
SetVideoMode endp

;   ClearScreen
;
;   Clears the screen
;   Input: none
;   Output: none
ClearScreen proc far
    mov ax, 0600H
    mov bh, 00H
    mov cx, 0000H
    mov dx, 184FH
    int 10H
    ret
ClearScreen endp

;   PrintMessage
;
;   Prints a message to the screen
;   Input: DS:DX -> message
;   Output: none
PrintMessage proc far
    mov ah, 09H
    int 21H
    ret
PrintMessage endp

;   PrintBackButton
;
PrintBackButton proc far
    mov axis_x, 0
    mov axis_y, 0

    mov dh, [axis_x]
    mov dl, [axis_y]
    call SetMousePosition

    mov dx, offset button_label
    call PrintMessage
    ret
PrintBackButton endp

;   printRectangle
;
printRectangle proc far
    Mov ah, 07h
    Mov al, 0   ; DESPLASAMINETO //
    Mov bh, colorPaint  ; COLOR DE FONDO
    Mov ch, py 
    Mov cl, px
  ;  inc cl
    Mov dh, py
    ;add dh,1
    Mov dl, px
    add dl, 2
    Int 10h
    ret
printRectangle endp
end
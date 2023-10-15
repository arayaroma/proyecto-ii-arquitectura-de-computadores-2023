; graphics.asm
; author: arayaroma
;
.8086
.model small
public SetVideoMode, ClearScreen, PrintMessage, IsMouseIn, is_mouse_in

; ascii.asm
extrn ConvertToASCII:far

; mouse.asm
extrn GetMousePosition:far
extrn SetMousePosition:far
extrn mouseX:word
extrn mouseY:word

.data

is_mouse_in dw ?
play_text_x1 dw 295
play_text_y1 dw 178
play_text_x2 dw 327
play_text_y2 dw 192
fix_me db 'a', '$'

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

IsMouseIn proc far
    call GetMousePosition
    cmp [mouseX], offset play_text_x1
    jl not_in_area

    cmp [mouseX], offset play_text_x2
    jg not_in_area

    cmp [mouseY], offset play_text_y1
    jl not_in_area

    cmp [mouseY], offset play_text_y2
    jg not_in_area

    mov is_mouse_in, 1
    jmp print_value

not_in_area:
    mov is_mouse_in, 0
    jmp print_value

print_value:
    mov dh, 2
    mov dl, 0
    call SetMousePosition

    mov dx, offset fix_me
    call PrintMessage
    ret
IsMouseIn endp

end
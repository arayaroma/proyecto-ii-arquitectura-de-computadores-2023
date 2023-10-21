; mouse.asm
; author: arayaroma
;
.8086
.model small
public ShowMouse, HideMouse, SetMousePosition, GetMousePosition
public mouseX, mouseY, mouseXText, mouseYText, IsMouseIn, is_left_clicked

; ascii.asm
extrn ConvertToASCII:far

; graphics.asm
extrn PrintMessage:far

; menu.asm
extrn text_x1:word
extrn text_x2:word
extrn text_y1:word
extrn text_y2:word

.data
mouseXText db "Mouse X: ", '$'
mouseYText db "Mouse Y: ", '$'
mouseX dw 0
mouseY dw 0
mouseStatus dw ?
is_mouse_in dw ?
is_left_clicked dw ?


.code

; ShowMouse
;
; int 33H
; ax = 01H 
;
ShowMouse proc far
    mov ax, 0001H
    int 33H
    ret
ShowMouse endp

; HideMouse
;
; int 33H
; ax = 02H
;
HideMouse proc far
    mov ax, 0002H
    int 33H
    ret
HideMouse endp

; GetMousePosition
;
; int 33H
; ax = 03H
; bx: button status
; cx: x position
; dx: y position
; 
; |8|7|6|5|4|3|2|1|0|
; (0) left button (1 = pressed)
; (1) right button (1 = pressed)
; (2-8) unused
;
GetMousePosition proc far
    mov ax, 03H
    int 33H
    mov [mouseX], cx
    mov [mouseY], dx
    mov [mouseStatus], bx
    ret
GetMousePosition endp

; SetMousePosition
;
; int 10H 
; ax = 02H
; bx = 00H
; dh = x position
; dl = y position
;
SetMousePosition proc far
    mov ah, 02H
    mov bh, 00H
    int 10H
    ret
SetMousePosition endp

; IsMouseIn
;
; checks if mouse is in a specific area
; 
; x1, y1 = top left corner
; x2, y2 = bottom right corner
;
; Input: none
; Output: is_mouse_in = 1 if mouse is in area, 0 otherwise
;
IsMouseIn proc far
    push bp
    mov bp, sp

    push dx
    mov dh, 2
    mov dl, 0
    call SetMousePosition
    pop dx

    cmp word ptr [bp + 4], cx
    jl not_in_area
    cmp word ptr [bp + 6], cx
    jg not_in_area

    cmp word ptr [bp + 8], dx
    jl not_in_area
    cmp word ptr [bp + 10], dx
    jg not_in_area

    mov [is_mouse_in], 1
    jmp if_is_left_clicked

not_in_area:
    mov [is_mouse_in], 0
    jmp if_is_left_clicked

if_is_left_clicked:
    cmp [mouseStatus], 00000001B
    je left_clicked
    mov [is_left_clicked], 0
    jmp print_value

left_clicked:
    mov [is_left_clicked], 1
    jmp print_value

; debug purposes
print_value:
    mov ax, [is_left_clicked]
    call ConvertToASCII
    pop bp
    ret
IsMouseIn endp

end
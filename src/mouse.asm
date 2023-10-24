; mouse.asm
; author: arayaroma
;
.8086
.model small
public ShowMouse, HideMouse, SetMousePosition, GetMousePosition
public mouseX, mouseY, mouseXText, mouseYText, IsMouseIn
public is_in_play_area, is_in_scoreboard_area, is_in_about_area

; ascii.asm
extrn ConvertToASCII:far

; graphics.asm
extrn PrintMessage:far

; menu.asm
extrn play_text_x1:word, play_text_y1:word, play_text_x2:word, play_text_y2:word
extrn scoreboard_text_x1:word, scoreboard_text_y1:word, scoreboard_text_x2:word, scoreboard_text_y2:word
extrn about_text_x1:word, about_text_y1:word, about_text_x2:word, about_text_y2:word

.data
mouseXText db "Mouse X: ", '$'
mouseYText db "Mouse Y: ", '$'
mouseX dw 0
mouseY dw 0
mouseStatus dw ?
is_mouse_in dw ?
is_in_play_area dw ?
is_in_scoreboard_area dw ?
is_in_about_area dw ?

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
    push dx
    mov dh, 2
    mov dl, 0
    call SetMousePosition
    pop dx

    cmp cx, [play_text_x1]
    jl not_in_play_area
    cmp cx, [play_text_x2]
    jg not_in_play_area

    cmp dx, [play_text_y1]
    jl not_in_play_area
    cmp dx, [play_text_y2]
    jg not_in_play_area

    mov [is_mouse_in], 1
    jmp if_is_in_play_area

not_in_play_area:
    cmp cx, [scoreboard_text_x1]
    jl not_in_scoreboard_area
    cmp cx, [scoreboard_text_x2]
    jg not_in_scoreboard_area

    cmp dx, [scoreboard_text_y1]
    jl not_in_scoreboard_area
    cmp dx, [scoreboard_text_y2]
    jg not_in_scoreboard_area

    mov [is_mouse_in], 1
    jmp if_is_in_scoreboard_area

not_in_scoreboard_area:
    cmp cx, [about_text_x1]
    jl not_in_about_area
    cmp cx, [about_text_x2]
    jg not_in_about_area

    cmp dx, [about_text_y1]
    jl not_in_about_area
    cmp dx, [about_text_y2]
    jg not_in_about_area

    mov [is_mouse_in], 1
    jmp if_is_in_about_area

not_in_about_area:
    mov [is_mouse_in], 0
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

if_is_in_play_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_play

if_is_in_scoreboard_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_scoreboard

if_is_in_about_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_about

to_print_value:
    mov [is_in_play_area], 0
    mov [is_in_scoreboard_area], 0
    mov [is_in_about_area], 0
    jmp print_value

click_on_play:
    mov [is_in_play_area], 1
    jmp print_value

click_on_scoreboard:
    mov [is_in_scoreboard_area], 1
    jmp print_value

click_on_about:
    mov [is_in_about_area], 1
    jmp print_value

; debug purposes
print_value:
    mov ax, [is_in_scoreboard_area]
    call ConvertToASCII
    ret
IsMouseIn endp

end
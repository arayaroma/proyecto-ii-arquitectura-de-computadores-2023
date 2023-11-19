; option.asm
; author: abarcajesus
; author: arayaroma
;
.8086
.model small
public OptionDriver, nombre, levelCount, levelTxt

; board.asm
extrn BoardDriver:far

; menu.asm
extrn MenuDriver:far

; ascii.asm
extrn ConvertToASCII:far, DisplayASCII:far

; graphics.asm
extrn OnActionBackButton:far
extrn ClearScreen:far, ShowMouse:far
extrn PrintMessage:far, PrintBackButton:far
extrn is_in_back_area:byte
extrn back_x1:word, back_y1:word
extrn back_x2:word, back_y2:word

; mouse.asm
extrn GetMousePosition:far, SetMousePosition:far
extrn ShowMouse:far, HideMouse:far
extrn mouseXText:byte, mouseYText:byte
extrn mouseX:word, mouseY:word
extrn is_mouse_in:word, mouseStatus:word

.data
    incrementLevel              db '+', '$'
    decrementLevel              db '-', '$'
    option_text                 db 'Option', '$'
    levelTxt                    db 'Level:', '$'
    levelNumber                 db '010203040506070809101112131415', '$'
    mensaje                     db "Presiona en cualquier lugar y escribe tu nombre:", '$'
    play                        db "Jugar", '$'
    level_message               db "Selecciona el nivel:", '$'
    nombre                      db 20 dup(' '), "$"
    levelNumberAux              db 2 dup(" "), "$"
    levelCount                  db 1
    axisYOffset                 db ?
    axisXOffset                 db ?
    letterCount                 db 0
    increment_text_x1           dw 357
    increment_text_y1           dw 322
    increment_text_x2           dw 369
    increment_text_y2           dw 332

    decrement_text_x1           dw 259
    decrement_text_y1           dw 322
    decrement_text_x2           dw 273
    decrement_text_y2           dw 332

    play_text_x1                dw 301
    play_text_y1                dw 367
    play_text_x2                dw 347
    play_text_y2                dw 379

    is_in_increment_area        dw ?
    is_in_decrement_area        dw ?
    is_in_play_area             dw ?

    x_level                     db 0
    y_level                     db 0

.code

clearOptions proc near
    mov is_in_increment_area,0       
    mov is_in_decrement_area,0        
    mov is_in_play_area,0         
    mov levelCount,1
    mov letterCount,0
    mov cx, 20
    lea si,nombre
    clear_name:
        mov al,' '
        mov [si],al 
        inc si
    loop clear_name
    mov levelNumberAux[0], al
    mov levelNumberAux[1], al
ret
clearOptions endp

OptionDriver proc far
    
    call HideMouse
    call clearOptions
    call ClearScreen
    call PrintOption
    call ShowMouse
    call MainOptionLoop
    ret
OptionDriver endp

MainOptionLoop proc near
    call PrintBackButton
do_loop:
    call GetMousePosition
    call OnActionBackButton
    cmp [is_in_back_area], 1
    je in_back
    jne continue

in_back:
    cmp [mouseStatus], 1
    je return_to_main_menu

continue:
    call GetMousePosition
    call OptionClickEvent
    cmp [is_in_increment_area], 1
    je increment

    cmp [is_in_decrement_area], 1
    je decrement

    cmp [is_in_play_area], 1
    je play_game
    jne do_loop

return_to_main_menu:
    call HideMouse
    call MenuDriver
    ret

play_game:
    call GotoPlay
    ret

increment:
    call GotoIncrement
    mov is_in_increment_area,0
    mov mouseStatus,0
    mov is_mouse_in,0
    mov [mouseX], 0
    mov [mouseY], 0
    ret

decrement:
    call GotoDecrement
    mov is_in_decrement_area,0
    mov mouseStatus,0
    mov is_mouse_in,0
    mov [mouseX], 0
    mov [mouseY], 0
    ret
MainOptionLoop endp

GotoPlay proc near
    call HideMouse
    call ClearScreen
    call BoardDriver
    ret
GotoPlay endp

GotoIncrement proc near
    ;call HideMouse
    ret
GotoIncrement endp

GotoDecrement proc near
    ;call HideMouse
    ret
GotoDecrement endp

PrintOption proc near
    mov axisXOffset, 12
    mov axisYOffset, 15

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset mensaje
    call PrintMessage

    add axisXOffset, 1
    add axisYOffset, 1
    mov dh, 13
    mov dl, 16
    call SetMousePosition

    lea di, nombre
loop_name:
    ; Espera una tecla y la almacena en AL
    xor ax, ax
    mov ah, 0bh
    int 21h

    cmp al, 0
    je loop_name

    mov ah, 0
    int 16h
    
    cmp al, 8
    je delete_character
    cmp al, 13
    je end_loop_name
    cmp al, 32
    je loop_name

    ; Concatena la tecla al nombre
    inc letterCount
    mov [di], al

    ; Imprime el nombre
    mov ah,2
    mov dl,al
    int 21h
    ; mov dx, di
    ; call PrintMessage
    inc di
    jmp loop_name

delete_character:
    cmp letterCount, 0
    je loop_name
    mov ah, 2
    mov dl, 8
    int 21h

    mov ah, 2
    mov dl, ' '
    int 21h

    mov ah, 2
    mov dl, 8
    int 21h

    dec letterCount
    dec di
    mov byte ptr [di], 0
    jmp loop_name
    jmp loop_name

end_loop_name:
    cmp letterCount, 0
    je loop_name
    mov al, "$"
    mov [di], al
    call ClearScreen
    call clear_xy_position

    mov axisXOffset, 12
    mov axisYOffset, 15

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset mensaje
    call PrintMessage

    add axisXOffset, 1
    add axisYOffset, 1

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset nombre
    call PrintMessage

    add axisXOffset, 4
    add axisYOffset, 14

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset level_message
    call PrintMessage

    add axisXOffset, 3
    add axisYOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset decrementLevel
    call PrintMessage

    add axisYOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    mov dx, offset levelTxt
    call PrintMessage

    add axisYOffset, 6
    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    mov x_level, dh
    mov y_level, dl
    call SetMousePosition

    lea di, levelNumberAux
    lea si, levelNumber
    mov cx, 2
ciclo_level:
    mov ah,[si]
    mov [di],ah
    inc si
    inc di
    loop ciclo_level

    mov dx, offset levelNumberAux
    call PrintMessage

    add axisYOffset, 3
    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset incrementLevel
    call PrintMessage

    add axisXOffset,3
    mov axisYOffset, 38

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset play
    call PrintMessage
ret
PrintOption endp

clear_xy_position proc
    mov axisXOffset, 0
    mov axisYOffset, 0
    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition
    ret
clear_xy_position endp

; LoadMouseText
;
; This procedure will load the mouse text on the screen.
;
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

;MouseCoordinatesLoop
;
; This procedure will loop forever and display the
; mouse coordinates on the screen.
;
MouseCoordinatesLoop proc near
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
    ret
MouseCoordinatesLoop endp

OptionClickEvent proc near
    ; debug purposes
    ; push dx
    ; mov dh, 2
    ; mov dl, 0
    ; call SetMousePosition
    ; pop dx

    ;if (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y)
    cmp cx, [increment_text_x1]
    jl not_in_increment_area
    cmp cx, [increment_text_x2]
    jg not_in_increment_area

    cmp dx, [increment_text_y1]
    jl not_in_increment_area
    cmp dx, [increment_text_y2]
    jg not_in_increment_area

    mov [is_mouse_in], 1
    jmp if_is_in_increment_area

not_in_increment_area:
    cmp cx, [decrement_text_x1]
    jl not_in_decrement_area
    cmp cx, [decrement_text_x2]
    jg not_in_decrement_area

    cmp dx, [decrement_text_y1]
    jl not_in_decrement_area
    cmp dx, [decrement_text_y2]
    jg not_in_decrement_area

    mov [is_mouse_in], 1
    jmp if_is_in_decrement_area

not_in_decrement_area:
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
    mov [is_in_play_area], 0
    jmp return

not_in_play_area:
    mov [is_mouse_in], 0
    cmp [mouseStatus], 1
    jne to_print_value
    cmp [is_mouse_in], 1
    jmp return

if_is_in_play_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_play

if_is_in_decrement_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_decrement

if_is_in_increment_area:
    cmp [mouseStatus], 1
    jne to_print_value

    cmp [is_mouse_in], 1
    jne to_print_value

    jmp click_on_increment

to_print_value:
    mov [is_in_increment_area], 0
    mov [is_in_decrement_area], 0
    jmp return

click_on_play:
    mov [is_in_play_area], 1
    jmp return

click_on_increment:

    xor di,di
    xor si,si
    lea di, levelNumberAux
    lea si, levelNumber
    cmp levelCount, 14
    ja end_click_on_increment
    inc levelCount
    call print_level_update
end_click_on_increment:
    call ShowMouse
    jmp return

click_on_decrement:
  
    xor di,di
    xor si,si
    lea di, levelNumberAux
    lea si, levelNumber
    cmp levelCount, 2
    jb end_click_on_decrement
    dec levelCount
    call print_level_update
end_click_on_decrement:
    call ShowMouse
    jmp return

return:
    ret
OptionClickEvent endp

print_level_update proc near
    xor cx,cx
    mov cl, levelCount
    dec cl
    inc_si:
        inc si
        inc si
    loop inc_si
    
    mov cx, 2
    inc_level:
        mov ah,[si]
        mov [di],ah
        inc si
        inc di
    loop inc_level
    mov dh, [x_level]
    mov dl, [y_level]
    call SetMousePosition
    mov dx, offset levelNumberAux
    call PrintMessage
    mov cx,6
    delayClick:
        push cx
        mov cx,60000
        delayClick2:
        loop delayClick2
        pop cx
    loop delayClick
ret
print_level_update endp

end
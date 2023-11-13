; option.asm
; author: abarcajesus
;
.8086
.model small
public OptionDriver, nombre, levelCount

; graphics.asm
extrn ClearScreen:far
extrn ShowMouse:far
extrn PrintMessage:far

; board.asm
extrn BoardDriver:far

; file.asm
; extrn OpenScoreFile:far
; extrn WriteScoreFile:far

; ascii.asm
extrn ConvertToASCII:far
extrn DisplayASCII:far

; mouse.asm
extrn GetMousePosition:far
extrn SetMousePosition:far
extrn ShowMouse:far
extrn HideMouse:far
extrn mouseXText:byte
extrn mouseYText:byte
extrn mouseX:word
extrn mouseY:word
extrn is_mouse_in:word
extrn mouseStatus:word

.data
incrementLevel db '+', '$'
decrementLevel db '-', '$'
option_text db 'Option', '$'
level db 'Level:', '$'
levelNumber db '010203040506070809101112131415', '$'
mensaje db "Presiona en cualquier lugar y escribe tu nombre:", '$'
play db "Jugar", '$'
level_message db "Selecciona el nivel:", '$'
nombre db 20 dup(' '), "$"
levelNumberAux db 2 dup(" "), "$"
levelCount db 0
axisYOffset db ?
axisXOffset db ?
letterCount db 0
increment_text_x1 dw 357
increment_text_y1 dw 322
increment_text_x2 dw 369
increment_text_y2 dw 332

decrement_text_x1 dw 259
decrement_text_y1 dw 322
decrement_text_x2 dw 273
decrement_text_y2 dw 332

play_text_x1 dw 301
play_text_y1 dw 367
play_text_x2 dw 347
play_text_y2 dw 379

is_in_increment_area dw ?
is_in_decrement_area dw ?
is_in_play_area dw ?

x_level db 0
y_level db 0

.code

PrintOption proc far

    ;print message to input name
    mov axisXOffset, 12
    mov axisYOffset, 15

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset mensaje
    call PrintMessage

    add axisXOffset, 1
    add axisYOffset, 1

    lea di, nombre
    loop_name:
            ; Espera una tecla y la almacena en AL
            mov ah, 0
            int 16h

            inc letterCount
            cmp al, 8
            je delete_character

            ; Concatena la tecla al nombre
            mov [di], al

            add axisYOffset, 1

            mov dh, [axisXOffset]
            mov dl, [axisYOffset]
            call SetMousePosition


            ; Imprime el nombre
            mov dx, di
            call PrintMessage
            inc di
            ; Comprueba si se presionó la tecla Enter (código ASCII 13)
            cmp al, 13
            je end_loop_name

        jmp loop_name

    delete_character:
        ; Comprueba si el puntero al nombre ya está al comienzo
        cmp di, offset nombre
        je loop_name ; No se puede borrar más, así que vuelve a la entrada

        ; Retrocede el puntero en el nombre
        dec di

        call ClearScreen
        call clear_xy_position

        mov axisXOffset, 12
        mov axisYOffset, 15

        dec letterCount
        mov dh, [axisXOffset]
        mov dl, [axisYOffset]
        call SetMousePosition

        mov dx, offset mensaje
        call PrintMessage

        add axisXOffset, 1
        add axisYOffset, 2

        mov dh, [axisXOffset]
        mov dl, [axisYOffset]
        call SetMousePosition

        ; Limpia el carácter borrado
        mov byte ptr [di], 0

        mov dx, offset nombre
        call PrintMessage


        add axisYOffset, offset letterCount
        mov dh, [axisXOffset]
        mov dl, [axisYOffset]
        call SetMousePosition


    jmp loop_name



    ;end loop name
    end_loop_name:
        ; call OpenScoreFile
        ; call WriteScoreFile

        ;escribir el nombre
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

        mov dx, offset level
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
    push dx
    mov dh, 2
    mov dl, 0
    call SetMousePosition
    pop dx

    ;if (mouseX > x1 && mouseX < x2 && mouseY > y1 && mouseY < y
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
    jmp return

click_on_decrement:
    call HideMouse
    xor di,di
    xor si,si
    lea di, levelNumberAux
    lea si, levelNumber
    cmp levelCount, 1
    jb end_click_on_decrement
    dec levelCount
    call print_level_update
    end_click_on_decrement:
    call ShowMouse
    jmp return

return:
    ret
OptionClickEvent endp


MainOptionLoop proc near
do_loop:
    call OptionClickEvent
    cmp [is_in_increment_area], 1
    je increment
    cmp [is_in_decrement_area], 1
    je decrement
    cmp [is_in_play_area], 1
    je play_game

    call LoadMouseText
    call MouseCoordinatesLoop
    jmp do_loop


play_game:
    call GotoPlay
    ret
increment:
    call HideMouse
    call GotoIncrement
    ret
decrement:
    call HideMouse
    call GotoDecrement
    ret
MainOptionLoop endp


GotoPlay proc near
    call HideMouse
    call ClearScreen
    call BoardDriver
    ret
GotoPlay endp
GotoIncrement proc near
    call HideMouse
    ret
GotoIncrement endp

GotoDecrement proc near
    call HideMouse
    ret
GotoDecrement endp


print_level_update proc near
    xor cx,cx
    mov cl, levelCount
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
    mov ah, 00H ; wait for keypress
    int 16H
ret
print_level_update endp

OptionDriver proc far

    call ClearScreen

    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset option_text
    call PrintMessage

    call PrintOption
    call ShowMouse
    call MainOptionLoop
    ret
OptionDriver endp
end
; graphic.asm
; author: arayaroma
;
.8086
.model small
public printRectangle, PrintBackButton
public SetVideoMode, ClearScreen, PrintMessage
public back_x1, back_y1, back_x2, back_y2
public OnActionBackButton
public is_in_back_area
public printPause
public game_over_top, game_over_middle_top, game_over_middle_bot, game_over_bot
public game_over_binary, game_over_binary_two, game_over_octal, game_over_hex

; about.asm
extrn GoBackMenu:far

; mouse.asm
extrn SetMousePosition:far, GetMousePosition:far

; rectangle.asm
extrn px:byte, py:byte, colorPaint:byte, printLine:far 

.data
    button_label            db 'Back', '$'
    axis_x                  db ?
    axis_y                  db ?
    back_x1                 dw 0
    back_y1                 dw 0
    back_x2                 dw 40
    back_y2                 dw 15
    is_in_back_area         db 0

    msgpasue                db  '_____ _____ _____ _____ _____ ',               10,13, "$"
    msgpasue1               db '|  _  |  _  |  |  |   __|   __|',               10,13, "$"
    msgpasue2               db '|   __|     |  |  |__   |   __|',               10,13, "$"
    msgpasue3               db '|__|  |__|__|_____|_____|_____|',               10,13, "$"

    game_over_top           db ' _____                  _____',                 10, 13, '$'             
    game_over_middle_top    db '|   __|___ _____ ___   |     |_ _ ___ ___',     10, 13, '$' 
    game_over_middle_bot    db '|  |  | .`|     | -_|  |  |  | | | -_|  _|',    10, 13, '$'
    game_over_bot           db '|_____|__,|_|_|_|___|  |_____|\_/|___|_|',      10, 13, '$'  

    game_over_binary        db '01000111 01100001       01101101 01100101',     10, 13, '$'
    game_over_binary_two    db '01001111 01110110       01100101 01110010',     10, 13, '$'
    game_over_octal         db '107 141  155 145        117 166  145 162',      10, 13, '$'
    game_over_hex           db '47  61   6D  65         4F  76   65  72',       10, 13, '$'
;  ╦╦ ╦╔═╗╔═╗╦═╗
;  ║║ ║║ ╦╠═╣╠╦╝
; ╚╝╚═╝╚═╝╩ ╩╩╚═
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
;2
;   Prints a message to the screen
;   Input: DS:DX -> message
;   Output: none
PrintMessage proc far
    mov ah, 09H
    int 21H
    ret
PrintMessage endp

; OnActionBackButton
; Checks if the mouse is in the back button
;
OnActionBackButton proc far
    call GetMousePosition
    cmp cx, [back_x1]
    jl not_in_back_button
    cmp cx, [back_x2]
    jg not_in_back_button
    cmp dx, [back_y1]
    jl not_in_back_button
    cmp dx, [back_y2]
    jg not_in_back_button

    mov [is_in_back_area], 1
    jmp end_action_back_button

not_in_back_button:
    mov [is_in_back_area], 0
    jmp end_action_back_button

end_action_back_button:
    ret
OnActionBackButton endp

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

printPause proc far
    mov dl,23
    mov dh,10
    call SetMousePosition
    lea dx, msgpasue
    call PrintMessage
        mov dl,23
    mov dh,11
    call SetMousePosition
    lea dx, msgpasue1
    call PrintMessage
        mov dl,23
    mov dh,12
    call SetMousePosition
    lea dx, msgpasue2
    call PrintMessage
    mov dl,23
    mov dh,13
    call SetMousePosition
    lea dx, msgpasue3
    call PrintMessage

    ret
printPause endp
end
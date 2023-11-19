; about.asm
; author: arayaroma
;
.8086
.model small
public AboutDriver, GoBackMenu

; menu.asm
extrn MenuDriver:far

; mouse.asm
extrn ShowMouse:far, HideMouse:far
extrn SetMousePosition:far, GetMousePosition:far
extrn is_mouse_in:word, mouseStatus:word
extrn back_x1:word, back_y1:word
extrn back_x2:word, back_y2:word

; graphics.asm
extrn ClearScreen:far, PrintMessage:far
extrn PrintBackButton:far, OnActionBackButton:far
extrn is_in_back_area:byte, delayClickMause:far

.data
    endless_runners_text    db 'Endless Runners', '$'
    developed_by_text       db 'Developed by', '$'
    dev_one_name            db 'Daniel Araya Roman', '$'
    dev_two_name            db 'Jesus Abarca Rodriguez', '$'
    dev_three_name          db 'Francisco Amador Salazar', '$'
    copyright_text          db 'All rights reserved 2023', '$'

    axis_x_offset           db ?
    axis_y_offset           db ?

.code

; AboutDriver
; Driver for the about menu
;
AboutDriver proc far
    call delayClickMause
    call ClearScreen
    call ShowMouse
    call PrintInformation
    call PrintBackButton

action_loop:
    call OnActionBackButton
    cmp [is_in_back_area], 1
    cmp [mouseStatus], 1
    jne action_loop
    je go_back

go_back:
    call delayClickMause
    call GoBackMenu
    ret
AboutDriver endp

; GoBackMenu
; Returns to the main menu
;
GoBackMenu proc near
    call HideMouse
    call ClearScreen
    call MenuDriver
    ret
GoBackMenu endp

; PrintInformation
; Prints the information about the developers
;
PrintInformation proc near
    mov axis_x_offset, 4
    mov axis_y_offset, 28

    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset endless_runners_text
    call PrintMessage

    add axis_x_offset, 2

    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset developed_by_text 
    call PrintMessage

    add axis_x_offset, 2

    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset dev_one_name
    call PrintMessage

    add axis_x_offset, 2
    
    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset dev_two_name
    call PrintMessage

    add axis_x_offset, 2

    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset dev_three_name
    call PrintMessage

    add axis_x_offset, 2

    mov dh, [axis_x_offset]
    mov dl, [axis_y_offset]
    call SetMousePosition

    mov dx, offset copyright_text
    call PrintMessage

    ret
PrintInformation endp

end
; about.asm
; author: arayaroma
;
.8086
.model small
public AboutDriver, GoBackMenu

; menu.asm
extrn MenuDriver:far

; mouse.asm
extrn SetMousePosition:far
extrn ShowMouse:far
extrn HideMouse:far
extrn SetMousePosition:far
extrn GetMousePosition:far
extrn is_mouse_in:word
extrn mouseStatus:word

; graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far
extrn PrintBackButton:far

.data
    endless_runners_text    db 'Endless Runners', '$'
    developed_by_text       db 'Developed by', '$'
    dev_one_name            db 'Daniel Araya Roman', '$'
    dev_two_name            db 'Jesus Abarca Rodriguez', '$'
    dev_three_name          db 'Francisco Amador Salazar', '$'
    copyright_text          db 'All rights reserved 2023', '$'

    axis_x_offset           db ?
    axis_y_offset           db ?

    back_x1                 dw 0
    back_y1                 dw 0
    back_x2                 dw 40
    back_y2                 dw 15
    is_in_back_area         db 0


.code

; AboutDriver
; Driver for the about menu
;
AboutDriver proc far
    call ClearScreen
    call ShowMouse
    call PrintInformation
    call PrintBackButton
action_loop:
    call OnActionBackButton
    cmp [is_in_back_area], 1
    je back_area
    jne action_loop

back_area:
    cmp [mouseStatus], 1
    je go_back
    jne action_loop

go_back:
    call GoBackMenu
    ret
AboutDriver endp

; OnActionBackButton
; Checks if the mouse is in the back button
;
OnActionBackButton proc near
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
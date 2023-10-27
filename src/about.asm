; about.asm
; author: arayaroma
;
.8086
.model small
public AboutDriver, GoBackMenu

; menu.asm
extrn PrintMenu:far

; mouse.asm
extrn SetMousePosition:far
extrn ShowMouse:far
extrn HideMouse:far
extrn SetMousePosition:far
extrn IsMouseIn:far
extrn is_mouse_in:word

; graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far
extrn PrintBackButton:far

.data

endless_runners_text db 'Endless Runners', '$'
developed_by_text db 'Developed by', '$'
dev_one_name  db 'Daniel Araya Roman', '$'
dev_two_name db 'Jesus Abarca Rodriguez', '$'
dev_three_name db 'Francisco Amador Salazar', '$'
copyright_text db 'All rights reserved 2023', '$'

axis_x_offset db ?
axis_y_offset db ?

back_x1 dw 0
back_y1 dw 0
back_x2 dw 1
back_y2 dw 1

.code

AboutDriver proc far
    call ClearScreen
    call ShowMouse
    call PrintInformation
    call PrintBackButton
    call OnActionBackButton
    ret
AboutDriver endp

GoBackMenu proc near
    call HideMouse
    call ClearScreen
    call PrintMenu
    ret
GoBackMenu endp

OnActionBackButton proc near
action_loop:
    push [back_y2]
    push [back_y1]
    push [back_x2]
    push [back_x1]
    call IsMouseIn
    add sp, 8
    cmp [is_mouse_in], 1
    je go_menu

    jmp action_loop
go_menu:
    call GoBackMenu
    ret
OnActionBackButton endp

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
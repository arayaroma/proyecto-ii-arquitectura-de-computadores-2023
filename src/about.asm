; about.asm
; author: arayaroma
;
.8086
.model small
public AboutDriver

; mouse.asm
extrn SetMousePosition:far
extrn ShowMouse:far

; graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far

.data

about_text db 'About', '$'

.code

AboutDriver proc far
    call ClearScreen

    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset about_text 
    call PrintMessage

    call ShowMouse
    ret
AboutDriver endp

end
; score.asm
; author: arayaroma
;
.8086
.model small
public ScoreboardDriver

; mouse.asm
extrn SetMousePosition:far
extrn ShowMouse:far

; graphics.asm
extrn ClearScreen:far
extrn PrintMessage:far

.data

scoreboard_text db 'Scoreboard', '$'

.code

ScoreboardDriver proc far
    call ClearScreen

    mov dh, 0
    mov dl, 0
    call SetMousePosition

    mov dx, offset scoreboard_text 
    call PrintMessage

    call ShowMouse
    ret
ScoreboardDriver endp

end
; menu.asm
; author: arayaroma
;
.8086
.model small
public MenuDriver, text_x1, text_y1, text_x2, text_y2

; graphics.asm
extrn ClearScreen:far
extrn SetVideoMode:far
extrn PrintMessage:far

; board.asm
extrn board:far
extrn BoardDriver:far

; ascii.asm
extrn ConvertToASCII:far
extrn DisplayASCII:far

; mouse.asm
extrn GetMousePosition:far
extrn SetMousePosition:far
extrn ShowMouse:far
extrn HideMouse:far
extrn IsMouseIn:far
extrn mouseXText:byte
extrn mouseYText:byte
extrn mouseX:word
extrn mouseY:word
extrn is_left_clicked:word

.data

titleText db '[Endless Runners]', '$'
playText db 'Play', '$'
scoreboardText db 'Scoreboard', '$'
aboutText db 'About', '$'

text_x1 dw ?
text_y1 dw ?
text_x2 dw ?
text_y2 dw ?

play_text_x1 dw 280
play_text_y1 dw 170
play_text_x2 dw 330
play_text_y2 dw 190

scoreboard_text_x1 dw 272
scoreboard_text_y1 dw 225
scoreboard_text_x2 dw 353
scoreboard_text_y2 dw 238

about_text_x1 dw 295
about_text_y1 dw 274
about_text_x2 dw 335
about_text_y2 dw 285

; 00000001B = play
; 00000010B = scoreboard
; 00000100B = about
area_option dw ?

axisYOffset db ?
axisXOffset db ?

.code

; PrintMenu
;
; This procedure will print the menu on the screen.
;
PrintMenu proc far
    mov axisXOffset, 8
    mov axisYOffset, 31

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset titleText 
    call PrintMessage

    add axisYOffset, 6
    add axisXOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset playText
    call PrintMessage

    add axisXOffset, 3
    sub axisYOffset, 3
    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset scoreboardText
    call PrintMessage

    add axisXOffset, 3
    add axisYOffset, 3

    mov dh, [axisXOffset]
    mov dl, [axisYOffset]
    call SetMousePosition

    mov dx, offset aboutText
    call PrintMessage
    ret
PrintMenu endp

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

; MouseCoordinatesLoop
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


; MainMenuLoop
;
; This procedure will loop forever and handle the mouse
; events.
;
MainMenuLoop proc near
do_loop:
    push [play_text_y2]
    push [play_text_y1]
    push [play_text_x2]
    push [play_text_x1]
    call IsMouseIn 
    add sp, 8
    mov [area_option], 00000001B

    push [scoreboard_text_y2]
    push [scoreboard_text_y1]
    push [scoreboard_text_x2]
    push [scoreboard_text_x1]
    call IsMouseIn
    add sp, 8
    ; mov [area_option], 00000010B

    push [about_text_y2]
    push [about_text_y1]
    push [about_text_x2]
    push [about_text_x1]
    call IsMouseIn
    add sp, 8
    ; mov [area_option], 00000100B

    cmp [is_left_clicked], 1
    je left_clicked

    call LoadMouseText
    call MouseCoordinatesLoop
    jmp do_loop

left_clicked:
    cmp [area_option], 00000001B
    je goto_play

    cmp [area_option], 00000010B
    je goto_scoreboard

    cmp [area_option], 00000100B
    je goto_about

    call LoadMouseText
    call MouseCoordinatesLoop
repeat_loop:
    jmp do_loop

goto_play:
    call HideMouse
    call BoardDriver
    ret

goto_scoreboard:
    call HideMouse
    call ClearScreen
    ret

goto_about:
    call HideMouse
    call ClearScreen
    ret
MainMenuLoop endp

; MenuDriver
;
; This procedure is the main driver for the menu.
; It will call all the other procedures to display
; the menu and handle the mouse.
;
MenuDriver proc far
    call SetVideoMode
    call ShowMouse
    call ClearScreen
    call PrintMenu
    call MainMenuLoop
    ret
MenuDriver endp

end
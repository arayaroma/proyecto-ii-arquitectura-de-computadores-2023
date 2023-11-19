; menu.asm
; author: arayaroma
;
.8086
.model small
public MenuDriver, PrintMenu
public play_text_x1, play_text_y1, play_text_x2, play_text_y2
public about_text_x1, about_text_y1, about_text_x2, about_text_y2
public scoreboard_text_x1, scoreboard_text_y1, scoreboard_text_x2, scoreboard_text_y2

; graphics.asm
extrn ClearScreen:far, SetVideoMode:far, PrintMessage:far
extrn PrintMainTitle:far

; board.asm
extrn BoardDriver:far

; ascii.asm
extrn ConvertToASCII:far, DisplayASCII:far

; about.asm
extrn AboutDriver:far

; option.asm
extrn OptionDriver:far

; score.asm
extrn ScoreboardDriver:far

; mouse.asm
extrn GetMousePosition:far, SetMousePosition:far
extrn ShowMouse:far, HideMouse:far
extrn mouseXText:byte, mouseYText:byte
extrn mouseX:word, mouseY:word
extrn is_mouse_in:word, mouseStatus:word

.data
    titleText               db '[Endless Runners]', '$'
    playText                db 'Play', '$'
    scoreboardText          db 'Scoreboard', '$'
    aboutText               db 'About', '$'

    play_text_x1            dw 280
    play_text_y1            dw 170
    play_text_x2            dw 330
    play_text_y2            dw 190

    scoreboard_text_x1      dw 272
    scoreboard_text_y1      dw 225
    scoreboard_text_x2      dw 353
    scoreboard_text_y2      dw 238

    about_text_x1           dw 295
    about_text_y1           dw 274
    about_text_x2           dw 335
    about_text_y2           dw 285

    axisYOffset             db ?
    axisXOffset             db ?

    is_in_play_area         dw ?
    is_in_scoreboard_area   dw ?
    is_in_about_area        dw ?

.code
; PrintMenu
;
; This procedure will print the menu on the screen.
;
PrintMenu proc far
    ; mov axisXOffset, 8
    ; mov axisYOffset, 31

    ; mov dh, [axisXOffset]
    ; mov dl, [axisYOffset]
    ; call SetMousePosition

    ; mov dx, offset titleText 
    ; call PrintMessage

    call PrintMainTitle

    mov axisXOffset, 8
    mov axisYOffset, 31
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

; MenuClickEvent
;
; checks if mouse is in a specific area
; 
; x1, y1 = top left corner
; x2, y2 = bottom right corner
;
; Input: none
; Output: is_mouse_in = 1 if mouse is in area, 0 otherwise
;
MenuClickEvent proc near
    call GetMousePosition

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
    ; mov ax, [is_in_scoreboard_area]
    ; call ConvertToASCII
    ret
MenuClickEvent endp

; MainMenuLoop
;
; This procedure will loop forever and handle the mouse
; events.
;
MainMenuLoop proc near
do_loop:
    call MenuClickEvent 
    cmp [is_in_play_area], 1
    je play
    cmp [is_in_scoreboard_area], 1
    je scoreboard
    cmp [is_in_about_area], 1
    je about
    jmp do_loop

play:
    call GotoPlay
    ret
scoreboard:
    call GotoScoreboard
    
    ret
about:
    call GotoAbout
    ret
MainMenuLoop endp

GotoPlay proc near
    call HideMouse
    call OptionDriver
    ret
GotoPlay endp

GotoScoreboard proc near
    call HideMouse
    call ScoreboardDriver
    ret
GotoScoreboard endp

GotoAbout proc near
    call HideMouse
    call AboutDriver
    ret
GotoAbout endp

; MenuDriver
;
; This procedure is the main driver for the menu.
; It will call all the other procedures to display
; the menu and handle the mouse.
;
MenuDriver proc far
    call SetVideoMode

    call ClearScreen
    call PrintMenu
    call ShowMouse
    call MainMenuLoop
    ret
MenuDriver endp

end
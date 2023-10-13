.8086
.model small
public ShowMouse, HideMouse, getMousePosition, mouseX, mouseY

.data

mouseX db 2 dup(0)
mouseY db 2 dup(0)

isLeftButtonPressed db ?
isRightButtonPressed db ?

.code

; showMouse
;
; int 33H
; ax = 01H 
ShowMouse proc far
    mov ax, 0001H
    int 33H
    ret
ShowMouse endp

; hideMouse
;
; int 33H
; ax = 02H
HideMouse proc far
    mov ax, 0002H
    int 33H
    ret
HideMouse endp

; getMousePosition
;
; int 33H
; ax = 03H
; bx: button status
; cx: x position
; dx: y position
; 
; |8|7|6|5|4|3|2|1|0|
; (0) left button (1 = pressed)
; (1) right button (1 = pressed)
; (2-8) unused
getMousePosition proc far
    mov ax, 03H
    int 33H

    push ax
    call ConvertToAscii
    mov si, offset mouseX 
    pop ax
    mov cx, ax
    call DisplayCoordinate

    push dx
    call ConvertToAscii
    mov si, offset mouseY   
    pop dx
    mov cx, dx
    call DisplayCoordinate
    ret
getMousePosition endp

ConvertToAscii proc
    push bx cx dx
    mov bx, 10
    xor cx, cx
divLoop:
    div bx
    add dl, '0'
    dec si
    mov [si], dl
    test ax, ax
    jnz divLoop
    pop dx cx bx
    ret
ConvertToAscii endp

DisplayCoordinate proc
    push ax dx
    mov ah, 09H
    mov dx, si
    int 21H
    pop dx ax
    ret
DisplayCoordinate endp

end
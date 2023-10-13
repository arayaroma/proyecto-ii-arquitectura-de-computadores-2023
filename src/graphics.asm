.8086
.model small
public setVideoMode, clearScreen
.code

;  640x480 16-color VGA graphics mode
setVideoMode proc far
    mov ax, 0012H
    int 10h
    ret
setVideoMode endp

clearScreen proc far
    mov ax, 0600H
    mov bh, 00H
    mov cx, 0000H
    mov dx, 184FH
    int 10H
    ret
clearScreen endp

end
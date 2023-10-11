public setVideoMode
.model small
.code

;  640x480 16-color VGA graphics mode
setVideoMode proc far
    mov ax, 0012H
    int 10h
    ret
setVideoMode endp

end
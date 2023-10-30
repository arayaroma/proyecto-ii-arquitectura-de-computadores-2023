.model SMALL
public delay
.data


.code

delay proc far
    mov cx, 02H      ; HIGH WORD. speed of delay.
    mov dx, 00h      ; LOW WORD.
    mov ah, 86h      ; WAIT.
    int 15h
    ret
delay endp
end
.model SMALL
extrn pattern:byte

public move
.data

movimiento db "AAAAAAAAAA"
cont240 db 0
.code
move PROC far
lea si, pattern
lea di, pattern
add di, 10

ciclo:
    movsb
    inc si
    inc di


    cmp si, 240
    je fin
    jmp ciclo
fin:

lea di, movimiento

ciclo2:
    movsb
    inc si
    inc di
    cmp si, 250
    je fin2
    jmp ciclo2
fin2:

    ret
move endp
end
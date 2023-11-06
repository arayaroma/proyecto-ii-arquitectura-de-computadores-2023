.model SMALL
extrn pattern:byte, collision:byte
public movimiento
public move
.data
movimiento db 10 dup(" "),"$"

.code

move PROC 
xor si,si
lea SI, pattern

XOR CX,CX

goend:
inc si
INC CX
mov al, [si]
cmp al,"$"
jne goend

sub si, 11
lea di, collision
push cx
mov cx, 10
    setCollision:
    mov al, [si]
    mov [di], al
    inc di
    inc si
    loop setCollision
pop cx
sub si, 10


ciclo:
    mov al,[si]
	mov [si+10], al
	dec si
    dec cx
    cmp CX, 9
    je fin
    jmp ciclo
fin:
ADD SI,11
xor di,di
lea di, movimiento
XOR AX,AX
mov cx, 10
ciclo2:
    mov ah, [di]
	mov [si], ah
	mov al,[si]
	dec si
	inc di 
    je fin2
    loop ciclo2
fin2:

    ret
move endp
end
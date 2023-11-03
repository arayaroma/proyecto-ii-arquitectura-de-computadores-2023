.model SMALL

extrn movimiento:byte

public openFilePatron, closePatron , getNextLine
extrn ShowMouse:far
extrn SetMousePosition:far
extrn PrintMessage:far
.data

    filename db "../src/patterns/arch"
    handle dw 0
    letterCount dw 0

.code

	
openFilePatron proc far
	xor cx,cx
	mov handle,0
	mov letterCount,0
	mov ah, 3Dh
	mov al,00h
	lea dx, filename
	int 21h
	mov handle, ax
	ret
openFilePatron endp

closePatron proc far
xor ax,ax
mov ah, 3Eh
mov bx, handle
int 21h

ret
closePatron endp 

getNextLine proc far
	init:
    mov ah, 3Fh
    mov bx, handle
    mov cx, 10
    lea dx, movimiento
    int 21h

	cmp ax,cx
	jne reOpen
	mov movimiento[10],"$"


	jmp return
	reOpen:
	call closePatron
	call openFilePatron
	jmp init
	return:
ret
getNextLine endp
end
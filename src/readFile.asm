.model SMALL

extrn movimiento:byte

public openFilePatron, closePatron , getNextLine
extrn ShowMouse:far
extrn SetMousePosition:far
extrn PrintMessage:far
.data

    filename db ".../src/arch"
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
    mov ah, 3Fh
    mov bx, handle
    mov cx, 10
    lea dx, movimiento
    int 21h
	
	INC letterCount
	mov movimiento[10],"$"
	
    mov dh,1
    mov dl,1
    call SetMousePosition
    mov dx, offset movimiento
    call PrintMessage  

	lea di, movimiento


	mov ah, 09h
	lea dx, movimiento
	int 21h
	
	CMP letterCount, 10
	JE reOpen
	jmp return
	reOpen:
	call closePatron
	call openFilePatron

	return:
ret
getNextLine endp
end
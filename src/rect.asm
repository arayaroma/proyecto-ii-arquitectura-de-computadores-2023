extrn px:word, py:word, colorPaint:byte, widthSize:word, highsize:word
extrn printLine:far 
public printRectangle
public col, row, color, direction, lengthLine

.model SMALL


include src\macros\util.inc
.data
col dw 0
row dw 0
color db 0
lengthLine dw 0
direction db 0
.code 


printRectangle proc far
    mov ax, px
    mov col, ax
    mov ax, py
    mov row, ax
    mov al, colorPaint
    mov color, al
    mov dx, widthSize
    mov lengthLine, dx
    
    mov cx, highsize
    prtRow:
        call printLine
    loop prtRow
    waitEvent
    ret
printRectangle endp

end
extrn px:word, py:word, colorPaint:byte, widthSize:word, highsize:word, color:byte, col:word, row:word, direction:byte, lenthLine:word
extrn printLine:far 
public printRectangle


.model SMALL


;include src\macros\util.inc
.data
;col dw 0
;row dw 0
;color db 0

;direction db 0
.code 


printRectangle proc far
    mov ax, px
    mov col, ax
    mov ax, py
    mov row, ax
    mov al, colorPaint
    mov color, al
    mov dx, widthSize
    mov lenthLine, 10
    
    mov cx, 10
    prtRow:
        push cx
        mov ax, py
        mov row, ax
        call printLine
        inc col
        pop cx
    loop prtRow
    ;waitEvent
    ret
printRectangle endp

end
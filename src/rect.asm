;extrn px:word, py:word, colorPaint:byte, widthSize:word, highsize:word, color:byte, row:word, col:word, direction:byte, lenthLine:word
extrn px:byte, py:byte, colorPaint:byte, widthSize:word, highsize:word, color:byte, row:word, col:word, direction:byte, lenthLine:word
extrn printLine:far 
public printRectangle


.model SMALL


;include src\macros\util.inc
.data
;row dw 0
;col dw 0
;color db 0

;direction db 0
.code 


; printRectangle proc far
;     mov ax, px
;     mov col, ax
;     mov ax, py
;     mov row, ax
;     mov al, colorPaint
;     mov color, al

;     mov dx, widthSize
;     mov lenthLine, dx
    
;     mov cx, highsize
;     prtRow:
;         push cx

;         mov ax, px
;         mov col, ax
;         call printLine
;         inc row
;         pop cx
;     loop prtRow
;     ;waitEvent
;     ret
; printRectangle endp


printRectangle proc far
    Mov ah, 07h
    Mov al, 0   ; DESPLASAMINETO //
    Mov bh, colorPaint  ; COLOR DE FONDO
    Mov ch, py 
    Mov cl, px
  ;  inc cl
    Mov dh, py
    ;add dh,1
    Mov dl, px
    add dl, 2
    Int 10h
    ret
printRectangle endp


end
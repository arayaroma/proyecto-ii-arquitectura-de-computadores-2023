;extrn px:word, py:word, colorPaint:byte, widthSize:word, highsize:word, color:byte, row:word, col:word, direction:byte, lenthLine:word
extrn px:byte, py:byte, colorPaint:byte
extrn printLine:far 
public printRectangle


.model SMALL


.data

.code 

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
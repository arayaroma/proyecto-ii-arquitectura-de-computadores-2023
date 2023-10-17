.model SMALL

extrn row:word, col:word, color:byte, direction:byte, lenthLine:word
public printLine
include src\macros\util.inc
.data

.code 

printLine proc far
    mov cx, lenthLine

    prtRow:
        push cx
            printPoint row col color ; print point
        pop cx
        cmp direction, 0
            je ptrCol
        inc row ; increment row position    
        jmp entPrt
        ptrCol:
            inc col ; increment col position
        entPrt:   
    loop prtRow

    ret
printLine endp

end
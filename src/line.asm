.model SMALL

extrn col:word, row:word, color:byte, direction:byte, lenthLine:word
public printLine
include src\macros\util.inc
.data

.code 

printLine proc far
    mov cx, lenthLine

    prtRow:
        push cx
            printPoint col row color ; print point
        pop cx
        cmp direction, 0
            je ptrCol
        inc col ; increment row position    
        jmp entPrt
        ptrCol:
            inc row ; increment row position
        entPrt:   
    loop prtRow

    ret
printLine endp

end
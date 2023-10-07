extrn printMenu:far
.model small
.stack 100H     

exit macro 
   mov ah, 4CH
   int 21H
endm

.code
   mov ax, @DATA            
   mov ds, ax                         
start:
   call printMenu
   exit

end start
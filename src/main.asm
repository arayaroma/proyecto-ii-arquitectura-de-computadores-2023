; main.asm
; author: arayaroma
;
.8086
.model small
.stack 200H
extrn MenuDriver:far
extrn configAudio:far
.data

exit macro
   mov ah, 4CH
   int 21H
endm

.code
   mov ax, @DATA
   mov ds, ax
   call configAudio

   ; mov ah, 0
   ; int 16h
  call MenuDriver
   exit

end
del target\*.* /Q

:: assemble the files
bin\tasm /zi src\main.asm
bin\tasm /zi src\ascii.asm
bin\tasm /zi src\graphics.asm
bin\tasm /zi src\menu.asm
bin\tasm /zi src\mouse.asm
bin\tasm /zi src\board.asm
pause
bin\tasm /zi src\move.asm
bin\tasm /zi src\readFile.asm
bin\tasm /zi src\score.asm
bin\tasm /zi src\about.asm
bin\tasm /zi src\option.asm
bin\tlink /v main.obj ascii.obj graphics.obj menu.obj mouse.obj board.obj move.obj readFile.obj score.obj option.obj about.obj
pause
copy *.obj target
del *.obj

copy *.map target

del *.map 
:: execute it
main.exe
:: remove all files from target
del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
bin\tasm /z src\ascii.asm
bin\tasm /z src\graphics.asm
bin\tasm /z src\menu.asm
pause
bin\tasm /z src\mouse.asm
bin\tasm /z src\board.asm

:: copy bin files into target
copy *.obj target
del *.obj

:: link the files
bin\tlink target\main.obj target\ascii.obj target\graphics.obj target\menu.obj target\mouse.obj target\board.obj

pause

:: execute it
target\main.exe
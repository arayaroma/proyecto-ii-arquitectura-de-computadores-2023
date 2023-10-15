:: remove all files from target
del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
pause
bin\tasm /z src\ascii.asm
pause
bin\tasm /z src\graphics.asm
pause
bin\tasm /z src\menu.asm
pause
bin\tasm /z src\mouse.asm
pause
bin\tasm /z src\board.asm
pause
bin\tasm /z src\line.asm
pause
bin\tasm /z src\rect.asm
pause
:: copy bin files into target
copy *.obj target
del *.obj
:: link the files
bin\tlink target\main.obj target\ascii.obj target\graphics.obj target\menu.obj target\mouse.obj target\board.obj target\line.obj target\rect.obj target\main.exe

pause

:: execute it
target\main.exe
:: remove all files from target
del target\*.* /Q

:: assemble the files
bin\tasm /z src\main.asm
bin\tasm /z src\graphics.asm
bin\tasm /z src\menu.asm
bin\tasm /z src\mouse.asm

:: copy bin files into target
copy *.obj target
del *.obj

:: link the files
bin\tlink target\main.obj target\graphics.obj target\menu.obj target\mouse.obj

pause

:: execute it
target\main.exe
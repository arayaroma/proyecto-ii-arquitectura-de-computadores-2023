:: remove all files from target
del target\*.* /Q

:: assemble the files
bin\tasm /z src\menu.asm
bin\tasm /z src\main.asm

:: copy bin files into target
copy *.obj target
del *.obj

:: link the files
bin\tlink target\main.obj target\menu.obj

:: execute it
target\main.exe
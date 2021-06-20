@echo off
cd /d "%~dp0"
)
set /a NEDEA=0
cd CHT
for %%X in (*.cht) do (
echo searching title for [%%X]

..\GP.EXE %%~nX >>..\Game_List.MD)
)


cd ..
PAUSE
PAUSE
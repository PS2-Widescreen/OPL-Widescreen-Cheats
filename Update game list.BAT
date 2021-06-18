@echo off
cd /d "%~dp0"
)
echo  Games included in this list: 
echo ```
)>..\Game_List.MD
set /a NEDEA=0
cd CHT
for %%X in (*.cht) do (
	for /f "tokens=1*" %%A in ( 'findstr %%~nX ..\gameid.txt' ) do (
						IF EXIST %%X echo %%A __[%%B]__>>..\Game_List.MD
						IF EXIST %%X echo %%A __[%%B]__
						IF EXIST %%x set /a NEDEA=%NEDEA%+1
	
	)
)
echo ```>>..\Game_List.MD


cd ..
color 0a
echo execution ended
echo Ammount of registered cheat files: [%NEDEA%]
PAUSE
PAUSE
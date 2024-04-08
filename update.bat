@echo off
title automated archive updater

where busybox.exe >nul 2>nul
if errorlevel 1 (
  echo ERROR: busybox.exe not found
  goto QUIT
)

where PS2_pnach_converter.exe >nul 2>nul
if errorlevel 1 (
  echo ERROR: PS2_pnach_converter.exe not found
  goto QUIT
)

if not exist ..\Bare-Mastercodes-bin\.git (
  echo Bare mastercodes bin archive is missing on parent dir! clone it there before running
  goto QUIT
)

if not exist ..\pcsx2_patches\.git (
  echo PCSX2 Cheats archive is missing on parent dir! clone it there before running
  goto QUIT
)


for %%a in (%*) do (
  if "%%a"=="--clean" (
    echo cleaning cache
    del LST.TXT 2>nul
    del LST2.TXT 2>nul
    del FINAL.TXT 2>nul
    del MISSING_MASTERCODE.TSV 2>nul
  )
)

if not exist LST.TXT (
  echo # listing widescreen hacks from pcsx2_patches...
  findstr /I /M "Widescreen" ..\pcsx2_patches\patches\*.*>LST.TXT
)

REM busybox.exe grep -Eo "[a-zA-Z]{4}-[0-9]{5}.*.pnach" LST.TXT | busybox.exe grep -Eo "[a-zA-Z]{4}-[0-9]{5}" > LST2.TXT
if not exist LST2.TXT (
  echo ## Temporal list of game ID not found, constructing. this will take a while...
  for /f %%g in ('busybox.exe grep -Eo "[a-zA-Z]{4}-[0-9]{5}.*.pnach" LST.TXT') do (
    for /f %%x in ('echo %%g ^| busybox.exe grep -Eo "[a-zA-Z]{4}-[0-9]{5}" ^| busybox.exe sed "s/-/_/g" ^| busybox.exe sed "s/./&./8"') do (
      echo %%x;%%g>>LST2.TXT
    )
  )
)

echo # Checking cheats missing in this repo with available mastercode...
del FINAL.TXT
echo ID	LINK>MISSING_MASTERCODE.TSV
set /a CNT=0
set /a CNT2=0
for /f "delims=; tokens=1,*" %%a in (LST2.TXT) do (
  if not exist CHT\%%a.cht (
    if exist ..\Bare-Mastercodes-bin\MASTERCODES\%%a.cht (
      echo %%a;%%b >>FINAL.TXT
      set /a CNT += 1
    ) else (
	  if not exist CHT\%%a.cht (
        set /a CNT2 += 1
        echo %%a	https://github.com/PCSX2/pcsx2_patches/blob/main/patches/%%b>>MISSING_MASTERCODE.TSV
	  )
    )
  )
)

for /f "delims=; tokens=1,*" %%a in (FINAL.TXT) do (
  if exist ..\pcsx2_patches\patches\%%b (
    copy ..\Bare-Mastercodes-bin\MASTERCODES\%%a.cht CHT\%%a.cht>nul
    PS2_pnach_converter.exe ..\pcsx2_patches\patches\%%b -g -l >>CHT\%%a.cht
  ) else echo HUSTON, WE HAVE A PROBLEM %%a @ %%b
)

echo found %CNT% candidates...
echo found %CNT2% cheat files wich need a mastercode to be included (see them on ./MISSING_MASTERCODE.TSV)
busybox.exe grep -Eqv "[a-zA-Z]{4}-[0-9]{5}.*.pnach" LST.TXT
if errorlevel 0 (
  echo --- Warning. widescreen hacks with non-standard naming found:
  busybox.exe grep -Ev "[a-zA-Z]{4}-[0-9]{5}.*.pnach" LST.TXT
)

REM del LST.TXT
REM del LST2.TXT
:QUIT
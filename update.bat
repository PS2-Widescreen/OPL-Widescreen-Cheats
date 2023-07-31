@echo off
title automated archive updater

for %%a in (%*) do (
  if "%%a"=="--clean" (
    echo cleaning cache
    del LST.TXT
    del LST2.TXT
    del FINAL.TXT
    del MISSING_MASTERCODE.TXT
  )
  echo %%a
)

if not exist LST.TXT (
  echo # listing widescreen hacks from pcsx2_patches...
  findstr /M "Widescreen" ..\pcsx2_patches\patches\*.*>LST.TXT
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
del MISSING_MASTERCODE.TXT
set /a CNT=0
set /a CNT2=0
for /f "delims=; tokens=1,*" %%a in (LST2.TXT) do (
  if not exist CHT\%%a.cht (
    if exist ..\Bare-Mastercodes-bin\MASTERCODES\%%a.cht (
      echo %%a;%%b >>FINAL.TXT
      set /a CNT += 1
    ) else (
      set /a CNT2 += 1
      echo %%a;https://github.com/PCSX2/pcsx2_patches/blob/main/patches/%%b>>MISSING_MASTERCODE.TXT
    )
  )
)
echo found %CNT% candidates...
echo found %CNT2% cheat files wich need a mastercode to be included
for /f "delims=; tokens=1,*" %%a in (FINAL.TXT) do (
  if exist ..\pcsx2_patches\patches\%%b (
    echo %%a
    copy ..\Bare-Mastercodes-bin\MASTERCODES\%%a.cht CHT\%%a.cht>nul
    PS2_pnach_converter.exe ..\pcsx2_patches\patches\%%b -g >>CHT\%%a.cht
  ) else echo HUSTON, WE HAVE A PROBLEM %%a @ %%b
)
REM del LST.TXT
REM del LST2.TXT
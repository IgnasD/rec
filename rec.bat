@echo off
cd /d "%~dp0"
cls
set pav=FripTV 0.18 rec script
set ver=2.4-vlcbackports
title %pav% %ver%
color 17
if exist friptv.exe goto pradzia
echo Nerastas friptv.exe
echo.
echo Scriptas turi buti patalpintas kartu su friptv.exe
goto isejimas_pause
:pradzia
if "%1"=="1" goto planinis
if "%1"=="n" goto planinis
set /p kanalas=Kanalo numeris: 
set /p failas=Failo pavadinimas (su galune, negali buti tarpu): 
set /p pradeti=Pradeti dabar? [T/N]: 
if /i "%pradeti%"=="T" goto pradeti_dabar
set /p laikas=Nurodykite irasymo pradzios laika (formatas: HH:MM:SS): 
:pradeti_dabar
set /p pabaiga=Nurodykite irasymo pabaigos laika (formatas: HH:MM:SS): 
set /p uzmigdymas=Uzmigdyti kompiuteri po irasymo? [T/N]: 
if /i "%pradeti%"=="T" goto irasymas
if /i "%uzmigdymas%"=="T" (set uzmigdyti=1) else (set uzmigdyti=0)
set /p daugkartinis=Daugkartinis irasymas? [T/N]: 
if /i "%daugkartinis%"=="T" goto daugkartinis
set kartai=1
set /p data=Nurodykite irasymo data (formatas: yyyy/mm/dd): 
set nustatymai=/SC ONCE /ST %laikas% /SD %data%
goto scheduleris
:daugkartinis
set kartai=n
echo Nurodykite savaites diena/dienas, kada bus vykdomas irasymas:
echo MON - pirmadienis;
echo TUE - antradienis;
echo WED - treciadienis;
echo THU - ketvirtadienis;
echo FRI - penktadienis;
echo SAT - sestadienis;
echo SUN - sekmadienis.
echo Jeigu nurodote keleta dienu, jas atskirkite kableliais (pvz.: MON,WED,FRI)
set /p dienos=
set nustatymai=/SC WEEKLY /D %dienos% /ST %laikas%
:scheduleris
schtasks /Create %nustatymai% /TN "%pav% %ver% start (%failas%)" /TR "'%~0' %kartai% %uzmigdyti% %kanalas% %failas% %pabaiga%">nul
echo Irasymas prasides tavo nurodytu laiku. Sis langas tau nebereikalingas.
goto isejimas
:planinis
echo Planinis irasymas
echo.
echo %DATE% %TIME%
set pabaiga=%5
echo Baigsis: %pabaiga%
echo.
set kanalas=%3
echo Kanalas: %kanalas%
set failas=%4
echo Failo pavadinimas: %DATE%_%failas%
if "%2"=="1" set uzmigdymas=T
if "%1"=="1" schtasks /Delete /TN "%pav% %ver% start (%failas%)" /F>nul
:irasymas
echo.
schtasks /Create /SC DAILY /ST %pabaiga% /TN "%pav% %ver% stop (%failas%)" /TR "taskkill /IM friptv.exe /T /F">nul
echo Pradedamas irasymas. Sekanti zinute pranes apie irasymo pabaiga.
friptv.exe /silent /ch=%kanalas% /file=%failas%
schtasks /Delete /TN "%pav% %ver% stop (%failas%)" /F>nul
echo Irasymas baigtas.
if /i not "%uzmigdymas%"=="T" goto isejimas
echo.
echo Vykdoma kompiuterio uzmigdymo komanda.
rundll32 powrprof.dll,SetSuspendState
:isejimas_pause
echo.
echo Spauskite bet kuri klavisa sio lango uzdarymui.
pause>nul
exit
:isejimas
echo.
echo Sis langas automatiskai issijungs po 10 sekundziu.
echo Jeigu nenorite laukti, galite ji isjungti tiesiog dabar.
ping 127.0.0.1 -n 10>nul
exit
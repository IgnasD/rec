@echo off
cd /d "%~dp0"
cls
title Rec script 3.0.2 VLC edition
color 17
if exist vlc.exe goto pradzia
echo Nerastas vlc.exe
goto isejimas
:pradzia
if "%1"=="1" goto planinis
if "%1"=="n" goto planinis
set /p streamas=Pilnas streamo URL (pvz. udp://@225.2.2.1:1234): 
set /p failas=Failo pavadinimas (su galune, negali buti tarpu): 
set /p pabaiga=Nurodykite irasymo pabaigos laika (formatas: HH:MM:SS): 
set /p uzmigdymas=Uzmigdyti kompiuteri po irasymo? [T/N]: 
set /p pradeti=Pradeti dabar? [T/N]: 
if /i "%pradeti%"=="T" goto irasymas
if /i "%uzmigdymas%"=="T" (set uzmigdyti=1) else (set uzmigdyti=0)
set /p laikas=Nurodykite irasymo pradzios laika (formatas: HH:MM:SS): 
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
schtasks /Create %nustatymai% /TN "Rec script (%failas%)" /TR "'%~0' %kartai% %uzmigdyti% %streamas% %failas% %pabaiga%">nul
echo Irasymas prasides tavo nurodytu laiku. Sis langas tau nebereikalingas.
goto isejimas
:planinis
echo Planinis irasymas
echo.
echo %DATE% %TIME%
set pabaiga=%5
echo Baigsis: %pabaiga%
echo.
set streamas=%3
echo Streamo URL: %streamas%
set failas=%4
echo Failo pavadinimas: %DATE%_%failas%
if "%2"=="1" set uzmigdymas=T
if "%1"=="1" schtasks /Delete /TN "Rec script (%failas%)" /F>nul
:irasymas
echo.
schtasks /Create /SC DAILY /ST %pabaiga% /TN "Rec script stop (%failas%)" /TR "taskkill /FI 'WINDOWTITLE eq vlc.exe  -I dummy %streamas%*' /T /F">nul
echo Pradedamas irasymas. Sekanti zinute pranes apie irasymo pabaiga.
del "%appdata%\vlc\crashdump" /F 2>nul
cmd /c vlc.exe -I dummy %streamas% --sout=file/ts:"D:\Recorder\%DATE%_%failas%"
schtasks /Delete /TN "Rec script stop (%failas%)" /F>nul
echo Irasymas baigtas.
if /i not "%uzmigdymas%"=="T" goto isejimas
echo Vykdoma kompiuterio uzmigdymo komanda.
rundll32 powrprof.dll,SetSuspendState
:isejimas
echo Sis langas automatiskai issijungs po 10 sekundziu.
echo Jeigu nenorite laukti, galite ji isjungti tiesiog dabar.
ping 127.0.0.1 -n 10>nul
exit
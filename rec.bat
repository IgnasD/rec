@echo off
cd /d "%~dp0"
cls
set pav=Rec script
set ver=3.1.4
title %pav% %ver% VLC edition
color 17
if not exist rec_dir.txt goto rec_dir_klaida
set /p dir=<rec_dir.txt
if "%dir%"=="" goto rec_dir_klaida
goto tikrinam_vlc
:rec_dir_klaida
echo Nerastas/tuscias rec_dir.txt
echo.
echo Sukurkite rec_dir.txt faila tame paciame kataloge, kur laikote si scripta.
echo I gauta tekstini faila iveskite irasymo direktorijos pilna kelia.
echo Pvz.:
echo C:\Katalogas\
echo PASTABOS:
echo #1. Galinis pasvires bruksnys butinas.
echo #2. Pasvirimo kryptis svarbi, t.y. \ nelygus /
goto isejimas_pause
:tikrinam_vlc
if exist vlc.exe goto pradzia
echo Nerastas vlc.exe
echo.
echo Scriptas turi buti patalpintas kartu su vlc.exe
goto isejimas_pause
:pradzia
if "%1"=="1" goto planinis
if "%1"=="n" goto planinis
set /p streamas=Pilnas streamo URL (pvz. udp://@225.2.2.1:1234): 
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
schtasks /Create %nustatymai% /TN "%pav% %ver% start (%failas%)" /TR "'%~0' %kartai% %uzmigdyti% %streamas% %failas% %pabaiga%">nul
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
if "%1"=="1" schtasks /Delete /TN "%pav% %ver% start (%failas%)" /F>nul
:irasymas
echo.
echo Pradedamas irasymas. Sekanti zinute pranes apie irasymo pabaiga.
del "%appdata%\vlc\crashdump" /F /Q 2>nul
for /f "tokens=2 delims==; " %%p in (
  'wmic process call create '"%~dp0vlc.exe" -I dummy %streamas% --demux=dump --demuxdump-file="%dir%%DATE%_%failas%"' 2^>nul ^| find "ProcessId"'
) do set vlc_pid=%%p
schtasks /Create /SC DAILY /ST %pabaiga% /TN "%pav% %ver% stop (%failas%)" /TR "taskkill /PID %vlc_pid% /T /F">nul
:laukti_vlc
tasklist /FI "PID eq %vlc_pid%" | find "%vlc_pid%" >nul
if not errorlevel 1 (
  ping 127.0.0.1 -n 3 >nul
  goto laukti_vlc
)
schtasks /Delete /TN "%pav% %ver% stop (%failas%)" /F>nul
echo Irasymas baigtas.
if /i not "%uzmigdymas%"=="T" goto isejimas
echo.
echo Vykdoma kompiuterio uzmigdymo komanda.
rundll32 powrprof.dll,SetSuspendState
goto isejimas
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
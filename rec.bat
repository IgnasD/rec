@echo off
cd /d %~dps0
cls
title FripTV 0.18 rec script v2-alpha
color 17
if exist friptv.exe goto pradzia
echo Nerastas friptv.exe
goto isejimas
:pradzia
if "%1"=="planinis" goto planinis
set /p kanalas=Kanalo numeris: 
set /p trukme=Iraso trukme (minutemis): 
set /p failas=Failo pavadinimas (su galune): 
set /p isjungimas=Isjungti kompiuteri po irasymo? [T/N]: 
set /p pradeti=Pradeti dabar? [T/N]: 
if /i "%pradeti%"=="T" goto irasymas
if /i "%isjungimas%"=="T" (set isjungti=1) else (set isjungti=0)
set /p laikas=Nurodykite irasymo pradzios laika (formatas: HH:MM:SS): 
set /p daugkartinis=Daugkartinis irasymas? [T/N]: 
if /i "%daugkartinis%"=="T" goto daugkartinis
set /p data=Nurodykite irasymo data (formatas: yyyy/mm/dd): 
set nustatymai=/SC ONCE /ST %laikas% /SD %data%
goto scheduleris
:daugkartinis
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
schtasks /Create %nustatymai% /TN "FripTV rec (%failas%)" /TR "%~s0 planinis %isjungti% %kanalas% %trukme% %failas%" > nul
echo Irasymas prasides tavo nurodytu laiku. Sis langas tau nebereikalingas.
goto isejimas
:planinis
echo Planinis irasymas (%DATE% %TIME%):
set kanalas=%3
echo Kanalo numeris: %kanalas%
set trukme=%4
echo Iraso trukme (minutemis): %trukme%
set failas=%5
echo Failo pavadinimas (su galune): %failas%
if "%2"=="1" set isjungimas=T
:irasymas
echo Pradedamas irasymas. Sekanti zinute pranes apie irasymo pabaiga.
friptv.exe /silent /ch=%kanalas% /file=%failas% /t=%trukme%
echo Irasymas baigtas.
if /i not "%isjungimas%"=="T" goto isejimas
echo Paleidziama kompiuterio isjungimo seka.
shutdown -s -t 60 -c "Irasymas baigtas." -f
:isejimas
echo Spauskite betkoki klavisa, kad iseitumete.
pause>nul
exit
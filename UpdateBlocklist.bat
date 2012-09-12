@echo off
set tempfolder=temp
set httpsite=http://list.iblocklist.com/?list=bt_level1&fileformat=dat&archiveformat=gz
set httpsite2=http://list.iblocklist.com/?list=bt_level2&fileformat=p2p&archiveformat=gz
set httpsite3=http://list.iblocklist.com/?list=bt_level3&fileformat=p2p&archiveformat=gz 

set httpfile=bt_level1.gz
set httpfile2=bt_level2.gz
set httpfile3=bt_level3.gz

set httpfileuncompressed=bt_level1
set httpfileuncompressed2=bt_level2
set httpfileuncompressed3=bt_level3
set blocklist=bt_level1.txt
set blocklist2=bt_level2.txt
set blocklist3=bt_level3.txt

echo.
echo -------------------------------------
echo Blocklist auto-update script


echo                           version 1.0


echo                     created by Malleho
echo -------------------------------------
echo.
echo ::**:: Creating temp folder and removing files
if not exist "%tempfolder%" mkdir "%tempfolder%
"


if exist "%tempfolder%\%httpfile%" del "%tempfolder%\%httpfile%*"
if exist "%tempfolder%\%httpfile2%" del "%tempfolder%\%httpfile2%*"
if exist "%tempfolder%\%httpfile3%" del "%tempfolder%\%httpfile3%*"
if exist "%tempfolder%\%blocklist%" del "%tempfolder%\%blocklist%"
if exist "%tempfolder%\%blocklist2%" del "%tempfolder%\%blocklist2%"
if exist "%tempfolder%\%blocklist3%" del "%tempfolder%\%blocklist3%"

echo ::**:: Downloading the blocklist from %httpsite%/%httpfile%
wget "%httpsite%" --no-cache -O "%tempfolder%\%httpfile%"
echo ::**::        wget returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Downloading the blocklist from %httpsite%
wget "%httpsite2%" --no-cache -O "%tempfolder%\%httpfile2%"
echo ::**::        wget returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Downloading the blocklist from %httpsite%
wget "%httpsite3%" --no-cache -O "%tempfolder%\%httpfile3%"
echo ::**::        wget returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Uncompressing "%httpfile%" to "%httpfileuncompressed%" 
gunzip "%tempfolder%\%httpfile%"
echo ::**:: Uncompressing "%httpfile2%" to "%httpfileuncompressed2%" 
gunzip "%tempfolder%\%httpfile2%"
echo ::**:: Uncompressing "%httpfile3%" to "%httpfileuncompressed3%" 
gunzip "%tempfolder%\%httpfile3%"


echo ::**::        gunzip returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Renaming the blocklist from "%httpfileuncompressed%" to "%blocklist%"
ren "%tempfolder%\%httpfileuncompressed%" "%blocklist%"
echo ::**:: Renaming the blocklist from "%httpfileuncompressed2%" to "%blocklist2%"
ren "%tempfolder%\%httpfileuncompressed2%" "%blocklist2%"
echo ::**:: Renaming the blocklist from "%httpfileuncompressed3%" to "%blocklist3%"
ren "%tempfolder%\%httpfileuncompressed3%" "%blocklist3%"

echo ::**::        ren returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Removing the current blocklist from uTorrent
if exist "Z:\Apps\Transmission\config\blocklists\%blocklist%" del "Z:\Apps\Transmission\config\blocklists\%blocklist%"
if exist "Z:\Apps\Transmission\config\blocklists\%blocklist2%" del "Z:\Apps\Transmission\config\blocklists\%blocklist2%"
if exist "Z:\Apps\Transmission\config\blocklists\%blocklist3%" del "Z:\Apps\Transmission\config\blocklists\%blocklist3%"

echo ::**::        del returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

echo ::**:: Copying the new blocklist to uTorrent
copy "%tempfolder%\%blocklist%" "Z:\Apps\Transmission\config\blocklists\%blocklist%"
copy "%tempfolder%\%blocklist2%" "Z:\Apps\Transmission\config\blocklists\%blocklist2%"
copy "%tempfolder%\%blocklist3%" "Z:\Apps\Transmission\config\blocklists\%blocklist3%"

echo ::**::        copy returned errorlevel: %errorlevel%
if %errorlevel% NEQ 0 goto AppError

goto ProgramEndOK

:AppError
echo ::**:: An error occured!
goto ProgramEndNothing

:ProgramEndOK
echo Update Complete!
if "%1" == "" (pause)

:ProgramEndNothing
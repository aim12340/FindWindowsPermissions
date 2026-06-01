@echo off
setlocal enabledelayedexpansion

:: Check if a folder was dropped
if "%~1"=="" (
    echo Error: Please drag and drop a folder onto this batch file.
    pause
    exit /b
)

:: Get folder path and safely join the name and extension (dots)
set "TARGET_DIR=%~1"
set "FOLDER_NAME=%~n1%~x1"
set "LOG_FILE=%~dp0%FOLDER_NAME%.permissions.log"

:: Clear previous log if it exists and start logging headers
echo Logging explicit permissions for: %TARGET_DIR% > "%LOG_FILE%"
echo Generated on: %date% %time% >> "%LOG_FILE%"
echo -------------------------------------------------- >> "%LOG_FILE%"

echo ==================================================
echo Scanning folder hierarchy and decoding flags...
echo ==================================================
echo.

:: 1. CHECK THE PARENT FOLDER FIRST
echo Processing Parent: %TARGET_DIR%
set "HAS_EXPLICIT="
for /f "delims=" %%A in ('icacls "%TARGET_DIR%"') do (
    set "LINE=%%A"
    if "!LINE:processed=!"=="!LINE!" (
        if "!LINE::(I)=!"=="!LINE!" (
            if not defined HAS_EXPLICIT (
                echo [ROOT FOLDER] >> "%LOG_FILE%"
                set "HAS_EXPLICIT=1"
            )
            
            :: Decode Inheritance Flags
            set "LINE=!LINE:(OI)= [Object Inherit]!"
            set "LINE=!LINE:(CI)= [Container Inherit]!"
            set "LINE=!LINE:(IO)= [Inherit Only]!"
            set "LINE=!LINE:(NP)= [No Propagate]!"
            
            :: Decode Common Access Permissions
            set "LINE=!LINE:(F)= [Full Control]!"
            set "LINE=!LINE:(M)= [Modify]!"
            set "LINE=!LINE:(RX)= [Read & Execute]!"
            set "LINE=!LINE:(R)= [Read Only]!"
            set "LINE=!LINE:(W)= [Write Only]!"
            set "LINE=!LINE:(AD)= [Append Data]!"
            set "LINE=!LINE:(WD)= [Write Data]!"
            
            echo !LINE! >> "%LOG_FILE%"
        )
    )
)
if defined HAS_EXPLICIT echo. >> "%LOG_FILE%"

:: 2. LOOP THROUGH ALL SUBFOLDERS RECURSIVELY
for /f "delims=" %%D in ('dir "%TARGET_DIR%" /ad /b /s') do (
    echo Processing: %%D
    set "HAS_EXPLICIT="
    
    for /f "delims=" %%A in ('icacls "%%D"') do (
        set "LINE=%%A"
        if "!LINE:processed=!"=="!LINE!" (
            if "!LINE::(I)=!"=="!LINE!" (
                if not defined HAS_EXPLICIT (
                    echo --- Folder: %%D >> "%LOG_FILE%"
                    set "HAS_EXPLICIT=1"
                )
                
                :: Decode Inheritance Flags
                set "LINE=!LINE:(OI)= [Object Inherit]!"
                set "LINE=!LINE:(CI)= [Container Inherit]!"
                set "LINE=!LINE:(IO)= [Inherit Only]!"
                set "LINE=!LINE:(NP)= [No Propagate]!"
                
                :: Decode Common Access Permissions
                set "LINE=!LINE:(F)= [Full Control]!"
                set "LINE=!LINE:(M)= [Modify]!"
                set "LINE=!LINE:(RX)= [Read & Execute]!"
                set "LINE=!LINE:(R)= [Read Only]!"
                set "LINE=!LINE:(W)= [Write Only]!"
                set "LINE=!LINE:(AD)= [Append Data]!"
                set "LINE=!LINE:(WD)= [Write Data]!"
                
                echo !LINE! >> "%LOG_FILE%"
            )
        )
    )
    if defined HAS_EXPLICIT echo. >> "%LOG_FILE%"
)

echo.
echo ==================================================
echo Scan complete. Log saved to:
echo "%LOG_FILE%"
echo ==================================================


@echo off
chcp 65001 > nul

set CURRENT_DIR=%~dp0
echo Current Directory: %CURRENT_DIR%
echo Building CascLib...

rem Try to find MSBuild if not in path
where msbuild >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set MSBUILD_PATH=msbuild
) else (
    rem Fallback to VS 2025 (v18)
    if exist "C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe" (
        set MSBUILD_PATH="C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe"
    ) else if exist "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
        set MSBUILD_PATH="C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
    ) else (
        echo [ERROR] MSBuild not found.
        exit /b 1
    )
)

echo Using MSBuild: %MSBUILD_PATH%
%MSBUILD_PATH% "%CURRENT_DIR%CascLib_dll.vcxproj" /p:Configuration=Release /p:Platform=x64

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] CascLib MSBuild failed.
    exit /b %ERRORLEVEL%
)

echo Copying CascLib.dll to Mod Master project...
if not exist "%CURRENT_DIR%..\mod\d2r-mod-master" mkdir "%CURRENT_DIR%..\mod\d2r-mod-master"
copy /Y "%CURRENT_DIR%bin\CascLib_dll\x64\Release\CascLib.dll" "%CURRENT_DIR%..\mod\d2r-mod-master\CascLib.dll"

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Copying CascLib.dll failed.
    exit /b %ERRORLEVEL%
)

echo CascLib build and copy completed successfully.

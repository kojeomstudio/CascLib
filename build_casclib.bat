@echo off
set MSBUILD_PATH="C:\Program Files\Microsoft Visual Studio\18\Community\MSBuild\Current\Bin\MSBuild.exe"
set CURRENT_DIR=%~dp0

echo Current Directory: %CURRENT_DIR%
echo Building CascLib...

%MSBUILD_PATH% "%CURRENT_DIR%CascLib_dll.vcxproj" /p:Configuration=Release /p:Platform=x64

if %ERRORLEVEL% NEQ 0 (
    echo CascLib build failed.
    exit /b %ERRORLEVEL%
)

echo Copying CascLib.dll to WPF project...
copy /Y "%CURRENT_DIR%bin\CascLib_dll\x64\Release\CascLib.dll" "%CURRENT_DIR%..\mod\casc-viewer-wpf\CascLib.dll"

echo CascLib build and copy completed successfully.

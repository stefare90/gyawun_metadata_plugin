#!/bin/bash

@echo off
echo 🚀 Starting the build of the Gywuan metadata plugin...

echo 📦 Checking and activating dart_eval...
call dart pub global activate dart_eval >nul

if exist plugin_output.evc del plugin_output.evc
if exist gywuan_plugin_build.zip del gywuan_plugin_build.zip

echo ⚙️ Compiling the lib/ folder into .evc format...
call dart_eval compile -p . -o plugin_output.evc

if %errorlevel% neq 0 (
    echo ❌ Error: Compilation failed. Check the code in lib/.
    exit /b %errorlevel%
)

if not exist plugin.json (
    echo ❌ Error: The plugin.json file was not found in the project root!
    exit /b 1
)

echo 🗜️ Creating the zip archive...
tar -a -c -f gywuan_plugin_build.zip plugin_output.evc plugin.json

echo ✅ Build completed successfully!
echo 🎉 You can find your plugin ready for distribution here: gywuan_plugin_build.zip
pause
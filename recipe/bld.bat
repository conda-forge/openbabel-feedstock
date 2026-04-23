cmake ^
      -G "NMake Makefiles" ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
      -DWITH_INCHI=ON ^
      -DOB_USE_PREBUILT_BINARIES=OFF ^
      -DPYTHON_EXECUTABLE=%PYTHON% ^
      -DPYTHON_BINDINGS=ON ^
      -DRUN_SWIG=ON ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DWITH_MAEPARSER=OFF ^
      .
if errorlevel 1 exit 1

cmake --build . --target install --config Release
if errorlevel 1 exit 1

echo d|xcopy %LIBRARY_PREFIX%\bin\data %PREFIX%\share\openbabel /e /c
rmdir /s /q %LIBRARY_PREFIX%\bin\data

xcopy %LIBRARY_PREFIX%\Lib\site-packages %PREFIX%\Lib /e /c
rmdir /s /q %LIBRARY_PREFIX%\Lib\site-packages

setlocal EnableDelayedExpansion

:: Copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %RECIPE_DIR%\%%F-env_vars.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F-env_vars.bat
    copy %RECIPE_DIR%\%%F-env_vars.ps1 %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F-env_vars.ps1
)

endlocal

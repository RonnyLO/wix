@setlocal
@pushd %~dp0

@set _C=Debug
@set _L=%~dp0..\..\build\logs
:parse_args
@if /i "%1"=="release" set _C=Release
@if not "%1"=="" shift & goto parse_args

@echo Building libs %_C%

msbuild -Restore libs_t.proj -p:Configuration=%_C% -nologo -m -warnaserror -bl:%_L%\libs_build.binlog || exit /b

msbuild dutil\test\DutilUnitTest -t:Test -p:Configuration=%_C% -p:Platform=Win32 -nologo -p:CppCliTestResultsFile="%_L%\TestResults\DutilUnitTest32.xunit2.xml" || exit /b
msbuild dutil\test\DutilUnitTest -t:Test -p:Configuration=%_C% -p:Platform=x64 -nologo -p:CppCliTestResultsFile="%_L%\TestResults\DutilUnitTest64.xunit2.xml" || exit /b

@popd
@endlocal

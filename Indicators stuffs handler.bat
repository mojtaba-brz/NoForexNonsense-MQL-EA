@echo off
cls
REM This batch script will search for the MetaEditor* process and get the path of the executable

REM Use the wmic command to get the process ID and executable path of the MetaEditor* process and store it in a variable
for /f "tokens=1,2 delims=," %%a in ('wmic process where "name like 'MetaEditor%%'" get processid^,executablepath /format:csv ^| findstr /i /v /c:"Node"') do set pid=%%a & set MetaEditorApp=%%b

if "%MetaEditorApp%"=="" (
    echo.
    echo.
    echo ***************************************************
    echo **     MetaEditor not found                      **
    echo **     Please open MetaEditor and try again      **
    echo ***************************************************
    echo.
    echo.
    pause
    exit /b 0
)


set folder=Indicators\MT4-5-IndicatorCollection\MT5-Indicators

REM Use a for loop to iterate over the files in the folder
echo Compiling indicators. please wait...

for %%f in ("%folder%\*.mq5") do (
    "%MetaEditorApp%" /compile:"%%f"
)
set folder=Indicators\MT4-5-IndicatorCollection\MT4-Indicators

for %%f in ("%folder%\*.mq4") do (
    "%MetaEditorApp%" /compile:"%%f"
)

echo Moving compiled indicators to Indicators folder...
move "%folder%\*.ex4" "../../Indicators/"
set folder=Indicators\MT4-5-IndicatorCollection\MT5-Indicators
move "%folder%\*.ex5" "../../Indicators/"
cls

echo Creating requaired .mqh files. please wait...

setlocal EnableDelayedExpansion

set enums_file="Indicators/IndicatorEnums.mqh"
@echo enum ConfirmationIndicatorIndex { > !enums_file!
set addresses_file="Indicators/IndicatorsAddresses.mqh"
@echo string ConfirmationIndicatorAddresses[] { > !addresses_file!
set signals_file="Indicators/IndicatorsSignalType.mqh"
@echo IndicatorSignalType ConfirmationIndicatorSignalType[] { > !signals_file!

set file_name=""

for %%f in ("Indicators/Table_Conf*.csv") do (
    set file_name=%%f
)

for /f "usebackq tokens=*" %%a in ("Indicators/%file_name%") do (
    set temp_var=%%~a
    @REM check if the line starts with //
    if not "!temp_var:~0,2!"=="//" (
        REM Split the line by comma and store the elements in an array
        set i=0
        for %%b in (%%~a) do (
            set /a i+=1
            set element[!i!]=%%~b
        )
        
        @echo  CI_!element[1]!, >> !enums_file!
        @echo "!element[2]!", >> !addresses_file!
        @echo INDICATOR_SIGNAL_TYPE_!element[3]!, >> !signals_file!
    )
)

@echo NO_CONFIRMATION_INDICATOR >> !enums_file!
@echo }; >> !enums_file!
@echo. >> !enums_file!
@echo "" >> !addresses_file!
@echo }; >> !addresses_file!
@echo. >> !addresses_file!
@echo INDICATOR_SIGNAL_TYPE_DUMMY >> !signals_file!
@echo }; >> !signals_file!
@echo. >> !signals_file!

@echo enum BaselineIndicatorIndex { >> !enums_file!
@echo string BaselineIndicatorAddresses[] { >> !addresses_file!
@echo IndicatorSignalType BaselineIndicatorSignalType[] { >> !signals_file!

for %%f in ("Indicators/Table_Bas*.csv") do (
    set file_name=%%f
)

for /f "usebackq tokens=*" %%a in ("Indicators/%file_name%") do (
    set temp_var=%%~a
    @REM check if the line starts with //
    if not "!temp_var:~0,2!"=="//" (
        REM Split the line by comma and store the elements in an array
        set i=0
        for %%b in (%%~a) do (
            set /a i+=1
            set element[!i!]=%%~b
        )
        
        @echo  BI_!element[1]!, >> !enums_file!
        @echo "!element[2]!", >> !addresses_file!
        @echo INDICATOR_SIGNAL_TYPE_!element[3]!, >> !signals_file!
    )
)

@echo NO_BASELINE_INDICATOR >> !enums_file!
@echo }; >> !enums_file!
@echo. >> !enums_file!
@echo "" >> !addresses_file!
@echo }; >> !addresses_file!
@echo. >> !addresses_file!
@echo INDICATOR_SIGNAL_TYPE_DUMMY >> !signals_file!
@echo }; >> !signals_file!
@echo. >> !signals_file!

@echo enum VolumeIndicatorIndex { >> !enums_file!
@echo string VolumeIndicatorAddresses[] { >> !addresses_file!
@echo IndicatorSignalType VolumeIndicatorSignalType[] { >> !signals_file!

for %%f in ("Indicators/Table_Vol*.csv") do (
    set file_name=%%f
)

for /f "usebackq tokens=*" %%a in ("Indicators/%file_name%") do (
    set temp_var=%%~a
    @REM check if the line starts with //
    if not "!temp_var:~0,2!"=="//" (
        REM Split the line by comma and store the elements in an array
        set i=0
        for %%b in (%%~a) do (
            set /a i+=1
            set element[!i!]=%%~b
        )
        
        @echo  VI_!element[1]!, >> !enums_file!
        @echo "!element[2]!", >> !addresses_file!
        @echo INDICATOR_SIGNAL_TYPE_!element[3]!, >> !signals_file!
    )
)

@echo NO_VOLUME_INDICATOR >> !enums_file!
@echo }; >> !enums_file!
@echo. >> !enums_file!
@echo "" >> !addresses_file!
@echo }; >> !addresses_file!
@echo. >> !addresses_file!
@echo INDICATOR_SIGNAL_TYPE_DUMMY >> !signals_file!
@echo }; >> !signals_file!
@echo. >> !signals_file!

@echo enum ExitIndicatorIndex { >> !enums_file!
@echo string ExitIndicatorAddresses[] { >> !addresses_file!
@echo IndicatorSignalType ExitIndicatorSignalType[] { >> !signals_file!

for %%f in ("Indicators/Table_Exi*.csv") do (
    set file_name=%%f
)

for /f "usebackq tokens=*" %%a in ("Indicators/%file_name%") do (
    set temp_var=%%~a
    @REM check if the line starts with //
    if not "!temp_var:~0,2!"=="//" (
        REM Split the line by comma and store the elements in an array
        set i=0
        for %%b in (%%~a) do (
            set /a i+=1
            set element[!i!]=%%~b
        )
        
        @echo  EI_!element[1]!, >> !enums_file!
        @echo "!element[2]!", >> !addresses_file!
        @echo INDICATOR_SIGNAL_TYPE_!element[3]!, >> !signals_file!
    )
)

@echo NO_EXIT_INDICATOR >> !enums_file!
@echo }; >> !enums_file!
@echo. >> !enums_file!
@echo "" >> !addresses_file!
@echo }; >> !addresses_file!
@echo. >> !addresses_file!
@echo INDICATOR_SIGNAL_TYPE_DUMMY >> !signals_file!
@echo }; >> !signals_file!
@echo. >> !signals_file!

cls
echo.
echo.
echo ***************************************************
echo **                                               **
echo **                     Done.                     **
echo **                                               **
echo ***************************************************
echo.
echo.
pause
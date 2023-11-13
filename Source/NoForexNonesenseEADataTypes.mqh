//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

enum ConfirmationSignal
{
    CI_BUY_SIGNAL = 0,
    CI_SELL_SIGNAL = 1,
    CI_NO_SIGNAL = 2,
    CI_NO_INDICATOR_SIGNAL = 4
};

enum EA_Mode
{
    WAIT_FOR_ENTRY_SIGNAL,
    ENTER_IN_TWO_POSITIONS,
    MANAGE_THE_POSITION
};
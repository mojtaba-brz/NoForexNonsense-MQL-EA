//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

enum EA_Mode
{
    WAIT_FOR_ENTRY_SIGNAL,
    EXECUTE_TWO_MARKET_ORDER,
    MANAGE_THE_POSITION
};

enum ConfirmationSignal
{
    CI_NO_INDICATOR_SIGNAL,
    CI_BUY_SIGNAL,
    CI_SELL_SIGNAL,
    CI_NO_SIGNAL
};

enum ExitSignal
  {
   EI_NO_SIGNAL,
   EI_SAFE_TO_BUY,
   EI_SAFE_TO_SELL
  };

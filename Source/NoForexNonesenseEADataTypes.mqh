//+------------------------------------------------------------------+
//|                                          NoForexNonsense-MQL4-EA |
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

enum IndicatorType 
{
    I_TYPE_ATR,
    I_TYPE_BASELINE,
    I_TYPE_CONFIRMATION,
    I_TYPE_2ND_CONFIRMATION,
    I_TYPE_VOLUME,
    I_TYPE_EXIT
};

enum BaselineSignal
  {
   BI_NO_SIGNAL,
   BI_CLOSE_IS_TOO_FAR_SIGNAL,
   BI_SAFE_TO_BUY,
   BI_SAFE_TO_SELL
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

enum VolumeIndicatorSignal
  {
   VI_NO_SIGNAL,
   VI_SAFE_TO_BUY,
   VI_SAFE_TO_SELL
  };
//+------------------------------------------------------------------+

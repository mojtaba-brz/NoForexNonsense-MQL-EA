#include "../../Libs/NNFMethodLibs.mqh"

enum BaselineSignal
{
    CLOSE_IS_TOO_FAR = -1,
    BUY_ALLOWED = 0,
    SELL_ALLOWED = 1,
    NO_BASE_LINE = 2
};

BaselineSignal get_baseline_signal(string sym, int &handle, BaselineIndicatorIndex idx, int &atr_handle)
  {
   if(handle < 0) return NO_BASE_LINE;
   double last_baseline = get_indicator_value_by_handle(handle);
   double last_close = iClose(sym, PERIOD_CURRENT, 1);
   double last_atr   = get_indicator_value_by_handle(atr_handle);

   if(MathAbs(last_close - last_baseline) > last_atr) return CLOSE_IS_TOO_FAR;
   else if (last_close < last_baseline) return SELL_ALLOWED;
   else return BUY_ALLOWED;
   
  }
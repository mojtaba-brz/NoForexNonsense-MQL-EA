//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

#include "../../Libs/NNFMethodLibs.mqh"

enum ConfirmationSignal
{
    CI_BUY_SIGNAL = 0,
    CI_SELL_SIGNAL = 1,
    CI_NO_SIGNAL = 2,
    CI_NO_INDICATOR_SIGNAL = 4
};

ConfirmationSignal get_first_confirmation_indicator_signal(string sym, int &first_handle, ConfirmationIndicatorIndex idx, int &atr_handle, bool check_one_candle_rule = true)
  {
// gather data ==========================================
   ConfirmationSignal signal;
   int signal_index;
   double last_close, close_at_signal_index, last_atr_value;
   get_confirmation_indicator_current_signal_and_its_index(sym, first_handle, idx, signal, signal_index);
   if(check_one_candle_rule){
      last_atr_value = get_indicator_value_by_handle(atr_handle, 1);
      last_close = iClose(sym, PERIOD_CURRENT, 1);

      switch (signal)
      {
      case CI_BUY_SIGNAL:
         break;
      
      default:
         break;
      }

   } else {
      if(signal_index < 3)
         return signal;
      else
         return CI_NO_SIGNAL;
   }
  }


void get_confirmation_indicator_handle(int &handle, ConfirmationIndicatorIndex idx, ENUM_TIMEFRAMES timeframe)
{
switch(idx)
   {
   case  NO_CONFIRMATION_INDICATOR:
      handle = -1;
      break;
      
   case CI_AO:
      handle = iAO(Symbol(), timeframe);
      break;

   case CI_AC:
      handle = iAC(Symbol(), timeframe);
      break;

   case CI_SMA:
      handle = iMA(Symbol(), timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
      break;

   default:
      handle = iCustom(Symbol(), timeframe, ConfirmationIndicatorAddresses[idx]);
      break;
   }

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_confirmation_indicator_signal(string sym, int &handle, ConfirmationIndicatorIndex idx, int shift = 1)
  {
   GeneralSignal signal;
   switch(ConfirmationIndicatorSignalType[idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS: signal = get_zero_cross_general_signal(handle, shift); break;
      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE: signal = get_change_slope_general_signal(handle, shift); break;
      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS: signal = get_two_line_cross_general_signal(handle, shift); break;
      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS: signal = get_close_price_cross_general_signal(sym, handle, shift); break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default: return CI_NO_INDICATOR_SIGNAL;
     }

      // manual GeneralSignal casting to ConfirmationSignal
     switch (signal)
     {
     case BUY_SIGNAL:   return CI_BUY_SIGNAL;   break;
     case SELL_SIGNAL:   return CI_SELL_SIGNAL;   break;
     case NO_SIGNAL:   return CI_NO_SIGNAL;   break;
     default: return CI_NO_INDICATOR_SIGNAL; break;
     }
  }

void get_confirmation_indicator_current_signal_and_its_index(  string sym, int &handle, ConfirmationIndicatorIndex indicator_idx, 
                                                               ConfirmationSignal &current_signal, int &index)
{
   current_signal = get_confirmation_indicator_signal(sym, handle, indicator_idx);
   ConfirmationSignal pre_signal = current_signal;
   index = 2;
   while(pre_signal == current_signal){
      pre_signal = get_confirmation_indicator_signal(sym, handle, indicator_idx, index);
      index++;
   }
}

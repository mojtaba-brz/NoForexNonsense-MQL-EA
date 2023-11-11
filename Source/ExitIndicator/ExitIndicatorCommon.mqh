//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "../../Libs/NNFMethodLibs.mqh"

enum ExitSignal
  {
   SAFE_TO_BUY,
   SAFE_TO_SELL,
   NO_EXIT_SIGNAL
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ExitSignal get_exit_indicator_signal(string sym, int &handle, ExitIndicatorIndex idx)
  {
   ConfirmationSignal temp_confirmation_signal = NO_SIGNAL;

   switch(ExitIndicatorSignalType[idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         temp_confirmation_signal = get_zero_cross_confirmation_signal(handle, 1);
         break;

      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         temp_confirmation_signal = get_change_slope_confirmation_signal(handle, 1);
         break;

      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         // pass!
         break;

      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         temp_confirmation_signal = get_close_price_cross_confirmation_signal(sym, handle);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         // pass!
         break;
     }

   if(temp_confirmation_signal == BUY_SIGNAL)
     {
      return SAFE_TO_BUY;
     }
   else
      if(temp_confirmation_signal == SELL_SIGNAL)
        {
         return SAFE_TO_SELL;
        }
   return NO_EXIT_SIGNAL;
  }
//+------------------------------------------------------------------+

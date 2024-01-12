//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ExitSignal CNoForexNonesenseEA::get_exit_indicator_signal(int shift = 1)
  {
   GeneralSignal temp_confirmation_signal = NO_SIGNAL;

   switch(ExitIndicatorSignalType[exit_indicator_idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         temp_confirmation_signal = get_zero_cross_general_signal(exit_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         temp_confirmation_signal = get_change_slope_general_signal(exit_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         temp_confirmation_signal = get_two_line_cross_general_signal(exit_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         temp_confirmation_signal = get_close_price_cross_general_signal(symbol, exit_indicator_handle, ea_timeframe, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         // pass!
         break;
     }

   if(temp_confirmation_signal == BUY_SIGNAL)
     {
      return EI_SAFE_TO_BUY;
     }
   else
      if(temp_confirmation_signal == SELL_SIGNAL)
        {
         return EI_SAFE_TO_SELL;
        }
   return EI_NO_SIGNAL;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifdef __MQL4__
double CNoForexNonesenseEA::get_exit_indicator_value_mt4(int shift = 1, int line_index = 0)
{
   double temp_var;
#else
int CNoForexNonesenseEA::get_exit_indicator_handle()
  {
   int temp_var;
#endif
   switch(exit_indicator_idx)
     {
      case  NO_EXIT_INDICATOR:
         temp_var = (int)EMPTY_VALUE;
         break;
#ifdef __MQL4__
      case EI_SMA:
         temp_var = iMA(symbol, ea_timeframe, exit_config_parameter, 0, MODE_SMA, PRICE_CLOSE, shift);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, ExitIndicatorAddresses[volume_indicator_idx], line_index, shift, exit_config_parameter);
         break;
#else
      case EI_SMA:
         temp_var = iMA(symbol, ea_timeframe, exit_config_parameter, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, ExitIndicatorAddresses[volume_indicator_idx], exit_config_parameter);
         break;
#endif
     }
   return temp_var;
  }
//+------------------------------------------------------------------+

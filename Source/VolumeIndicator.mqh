//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::set_volume_indicator_handle()
  {
   switch(volume_indicator_idx)
     {
      case  NO_VOLUME_INDICATOR:
         volume_indicator_handle = -1;

      case VI_SMA:
         volume_indicator_handle = iMA(symbol, ea_timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         volume_indicator_handle = iCustom(symbol, ea_timeframe, VolumeIndicatorAddresses[volume_indicator_idx]);
         break;
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
VolumeIndicatorSignal CNoForexNonesenseEA::get_volume_indicator_signal(int shift = 1)
  {
   GeneralSignal temp_confirmation_signal = NO_SIGNAL;

   switch(ExitIndicatorSignalType[volume_indicator_idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         temp_confirmation_signal = get_zero_cross_general_signal(volume_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         temp_confirmation_signal = get_change_slope_general_signal(volume_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         temp_confirmation_signal = get_two_line_cross_general_signal(volume_indicator_handle, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         temp_confirmation_signal = get_close_price_cross_general_signal(symbol, volume_indicator_handle, ea_timeframe, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         // pass!
         break;
     }

   if(temp_confirmation_signal == BUY_SIGNAL)
     {
      return VI_SAFE_TO_BUY;
     }
   else
      if(temp_confirmation_signal == SELL_SIGNAL)
        {
         return VI_SAFE_TO_SELL;
        }
   return VI_NO_SIGNAL;
  }
//+------------------------------------------------------------------+

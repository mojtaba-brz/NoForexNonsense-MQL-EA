
#ifdef __MQL4__
double CNoForexNonesenseEA::get_indicator_value(int indicator_type, int shift = 1, int line_index = 0, int confirmation_index = NO_CONFIRMATION_INDICATOR)
{
    switch (indicator_type)
    {
    case I_TYPE_ATR:
        return iATR(symbol, ea_timeframe, atr_indicator_scope, shift);
        break;

    case I_TYPE_BASELINE:
        return get_baseline_value_mt4(shift, line_index);
        break;

    case I_TYPE_CONFIRMATION:
        return get_confirmation_indicator_value_mt4(confirmation_index, shift, line_index);
        break;

    case I_TYPE_VOLUME:
        return get_volume_indicator_value_mt4(shift, line_index);
        break;

    case I_TYPE_EXIT:
        return get_exit_indicator_value_mt4(shift, line_index);
        break;
    
    default:
        Alert("bug when calling get_indicator_value");
        return EMPTY_VALUE;
        break;
    }
}

GeneralSignal CNoForexNonesenseEA::get_close_price_cross_general_signal(string sym, int &handle, ENUM_TIMEFRAMES time_frame, int shift = 1)
  {
   if(handle < 0) return NO_SIGNAL;

   double last_close = iClose(sym, time_frame, shift);
   double last_base_value = get_indicator_value(handle, shift);

   if(last_close > last_base_value)
      return BUY_SIGNAL;
   else
      return SELL_SIGNAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GeneralSignal CNoForexNonesenseEA::get_zero_cross_general_signal(int &handle, int shift = 1)
  {
   if(handle < 0) return NO_SIGNAL;
   
   double last_indicator_value = get_indicator_value(handle, shift);

   if(last_indicator_value > 0)
      return BUY_SIGNAL;
   else
      return SELL_SIGNAL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GeneralSignal CNoForexNonesenseEA::get_change_slope_general_signal(int &handle, int shift = 1)
  {
   if(handle < 0) return NO_SIGNAL;

// gather data ==========================================
   double last_indicator_value = get_indicator_value(handle, shift);
   double pre_indicator_value = get_indicator_value(handle, shift + 1);

   int i = 1;
   while(last_indicator_value == pre_indicator_value){
      i++;
      pre_indicator_value = get_indicator_value(handle, shift + i);
      if(i > 500){
         return NO_SIGNAL;
      }
   }

   if(last_indicator_value > pre_indicator_value)
      return BUY_SIGNAL;
   else
      return SELL_SIGNAL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GeneralSignal CNoForexNonesenseEA::get_two_line_cross_general_signal(int &handle, int shift = 1)
  {
   if(handle < 0) return NO_SIGNAL;

// gather data ==========================================
   double line1 = get_indicator_value(handle, shift, 0);
   double line2 = get_indicator_value(handle, shift, 1);

   if(line1 > line2)
      return BUY_SIGNAL;
   else
      return SELL_SIGNAL;
  }
#endif
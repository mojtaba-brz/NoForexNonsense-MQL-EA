//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaselineSignal CNoForexNonesenseEA::get_baseline_signal()
  {
   if(baseline_indicator_handle < 0)
      return BI_NO_SIGNAL;

   double last_baseline = get_indicator_value_by_handle(baseline_indicator_handle);
   double last_close = iClose(symbol, ea_timeframe, 1);
   double last_atr   = get_indicator_value_by_handle(atr_indicator_handle);

   if(MathAbs(last_close - last_baseline) > last_atr)
      return BI_CLOSE_IS_TOO_FAR_SIGNAL;
   else
      if(last_close < last_baseline)
         return BI_SAFE_TO_SELL;
      else
         return BI_SAFE_TO_BUY;

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::set_baseline_indicator_handle()
  {
   switch(base_line_indicator_idx)
     {
      case NO_BASELINE_INDICATOR:
         baseline_indicator_handle = -1;
         break;

      case BI_SMA:
         baseline_indicator_handle = iMA(symbol, ea_timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         baseline_indicator_handle = iCustom(symbol, ea_timeframe, BaselineIndicatorAddresses[base_line_indicator_idx]);
         break;
     }

  }
//+------------------------------------------------------------------+

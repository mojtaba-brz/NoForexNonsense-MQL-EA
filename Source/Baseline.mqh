//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaselineSignal CNoForexNonesenseEA::get_baseline_signal()
  {
   if(baseline_indicator_handle < 0)
      return BI_NO_SIGNAL;
#ifdef __MQL5__
   double last_baseline = get_indicator_value(baseline_indicator_handle);
   double last_atr   = get_indicator_value(atr_indicator_handle);
#else  
   double last_baseline = get_indicator_value(baseline_indicator_handle);
   double last_atr   = iATR(symbol, ea_timeframe, 14, 1);
#endif

   double last_close = iClose(symbol, ea_timeframe, 1);

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
#ifdef __MQL4__
double CNoForexNonesenseEA::get_baseline_value_mt4(int shift = 1, int line_index = 0)
{
   double temp_var;
#else
int CNoForexNonesenseEA::get_baseline_indicator_handle()
  {
   int temp_var;
#endif

   switch(base_line_indicator_idx)
     {
      case NO_BASELINE_INDICATOR:
         temp_var = (int)EMPTY_VALUE;
         break;

#ifdef __MQL4__
      case BI_SMA:
         temp_var = iMA(symbol, ea_timeframe, baseline_config_parameter, 0, MODE_SMA, PRICE_CLOSE, shift);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, BaselineIndicatorAddresses[base_line_indicator_idx], line_index, shift, baseline_config_parameter);
         break;
#else
      case BI_SMA:
         temp_var = iMA(symbol, ea_timeframe, baseline_config_parameter, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, BaselineIndicatorAddresses[base_line_indicator_idx], baseline_config_parameter);
         break;
#endif

     }

   return temp_var;
  }
//+------------------------------------------------------------------+

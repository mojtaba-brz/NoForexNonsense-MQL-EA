//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::determine_first_confirmation_indicator_entry_signal()
  {
// gather data ==========================================
   ConfirmationSignal signal;
   int signal_index;
   double last_close, close_at_signal_index, last_atr_value;
   get_first_confirmation_indicator_current_signal_and_its_index(signal, signal_index);
   if(use_one_candle_rule)
     {
      last_atr_value = get_indicator_value(atr_indicator_handle, 1);
      last_close = iClose(symbol, ea_timeframe, 1);
      close_at_signal_index = iClose(symbol, ea_timeframe, signal_index);

      switch(signal)
        {
         case CI_BUY_SIGNAL:
            if(last_close - close_at_signal_index >= last_atr_value)
               last_first_confirmation_indicator_signal = CI_NO_SIGNAL;
            else
               last_first_confirmation_indicator_signal = signal;
            break;

         case CI_SELL_SIGNAL:
            if(close_at_signal_index - last_close >= last_atr_value)
               last_first_confirmation_indicator_signal = CI_NO_SIGNAL;
            else
               last_first_confirmation_indicator_signal = signal;

         default:
            // pass
            break;
        }

     }
   else
     {
      if(signal_index < 3)
         last_first_confirmation_indicator_signal = signal;
      else
         last_first_confirmation_indicator_signal = CI_NO_SIGNAL;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#ifdef __MQL4__
double CNoForexNonesenseEA::get_confirmation_indicator_value_mt4(int indicator_index = NO_CONFIRMATION_INDICATOR, int shift = 1, int line_index = 0)
  {
   double temp_var;
#else
int CNoForexNonesenseEA::get_confirmation_indicators_handle(int indicator_index = NO_CONFIRMATION_INDICATOR, int config_param = 14)
  {
   int temp_var;
#endif

   switch(indicator_index)
     {
      case  NO_CONFIRMATION_INDICATOR:
         temp_var = (int)EMPTY_VALUE;
         break;

#ifdef __MQL4__
      case CI_AO:
         temp_var = iAO(symbol, ea_timeframe, shift);
         break;

      case CI_AC:
         temp_var = iAC(symbol, ea_timeframe, shift);
         break;

      case CI_SMA:
         temp_var = iMA(symbol, ea_timeframe, config_param, 0, MODE_SMA, PRICE_CLOSE, shift);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, ConfirmationIndicatorAddresses[indicator_index], config_param, line_index, shift);
         break;
#else
      case CI_AO:
         temp_var = iAO(symbol, ea_timeframe);
         break;

      case CI_AC:
         temp_var = iAC(symbol, ea_timeframe);
         break;

      case CI_SMA:
         temp_var = iMA(symbol, ea_timeframe, config_param, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         temp_var = iCustom(symbol, ea_timeframe, ConfirmationIndicatorAddresses[indicator_index], config_param);
         break;
#endif
     }

   return temp_var;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal CNoForexNonesenseEA::get_first_confirmation_indicator_signal(int shift = 1)
  {
   GeneralSignal signal;
   switch(ConfirmationIndicatorSignalType[first_confirmation_indicator_idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         signal = get_zero_cross_general_signal(first_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         signal = get_change_slope_general_signal(first_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         signal = get_two_line_cross_general_signal(first_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         signal = get_close_price_cross_general_signal(symbol, first_confirmation_indicator_handle, ea_timeframe, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         return CI_NO_INDICATOR_SIGNAL;
     }

   return general_signal_to_confirmation_signal(signal);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::set_second_confirmation_indicator_signal(int shift = 1)
  {
   GeneralSignal signal;
   switch(ConfirmationIndicatorSignalType[second_confirmation_indicator_idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         signal = get_zero_cross_general_signal(second_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         signal = get_change_slope_general_signal(second_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         signal = get_two_line_cross_general_signal(second_confirmation_indicator_handle, shift);
         break;
      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         signal = get_close_price_cross_general_signal(symbol, second_confirmation_indicator_handle, ea_timeframe, shift);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         signal = NO_INDICATOR;
     }

   last_second_confirmation_indicator_signal = general_signal_to_confirmation_signal(signal);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::get_first_confirmation_indicator_current_signal_and_its_index(ConfirmationSignal &current_signal, int &index)
  {
   current_signal = get_first_confirmation_indicator_signal();
   ConfirmationSignal pre_signal = current_signal;
   index = 1;
   if(current_signal == CI_NO_SIGNAL || current_signal == CI_NO_INDICATOR_SIGNAL)
      return;
   while(pre_signal == current_signal)
     {
      index++;
      pre_signal = get_first_confirmation_indicator_signal(index);
     }
   index--;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal CNoForexNonesenseEA::general_signal_to_confirmation_signal(GeneralSignal signal)
  {
   switch(signal)
     {
      case BUY_SIGNAL:
         return CI_BUY_SIGNAL;
         break;
      case SELL_SIGNAL:
         return CI_SELL_SIGNAL;
         break;
      case NO_SIGNAL:
         return CI_NO_SIGNAL;
         break;
      default:
         return CI_NO_INDICATOR_SIGNAL;
         break;
     }
  }
//+------------------------------------------------------------------+

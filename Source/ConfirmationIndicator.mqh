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
      last_atr_value = get_indicator_value_by_handle(atr_indicator_handle, 1);
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
void CNoForexNonesenseEA::set_confirmation_indicators_handle()
  {
   switch(first_confirmation_indicator_idx)
     {
      case  NO_CONFIRMATION_INDICATOR:
         first_confirmation_indicator_handle = -1;
         break;

      case CI_AO:
         first_confirmation_indicator_handle = iAO(symbol, ea_timeframe);
         break;

      case CI_AC:
         first_confirmation_indicator_handle = iAC(symbol, ea_timeframe);
         break;

      case CI_SMA:
         first_confirmation_indicator_handle = iMA(symbol, ea_timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         first_confirmation_indicator_handle = iCustom(symbol, ea_timeframe, ConfirmationIndicatorAddresses[first_confirmation_indicator_idx]);
         break;
     }

   switch(second_confirmation_indicator_idx)
     {
      case  NO_CONFIRMATION_INDICATOR:
         second_confirmation_indicator_handle = -1;
         break;

      case CI_AO:
         second_confirmation_indicator_handle = iAO(symbol, ea_timeframe);
         break;

      case CI_AC:
         second_confirmation_indicator_handle = iAC(symbol, ea_timeframe);
         break;

      case CI_SMA:
         second_confirmation_indicator_handle = iMA(symbol, ea_timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         second_confirmation_indicator_handle = iCustom(symbol, ea_timeframe, ConfirmationIndicatorAddresses[second_confirmation_indicator_idx]);
         break;
     }
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

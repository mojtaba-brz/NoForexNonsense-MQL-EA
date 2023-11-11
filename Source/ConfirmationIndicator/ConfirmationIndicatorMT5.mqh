//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

#include "ConfirmationIndicatorCommon.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_first_and_second_confirmation_indicator_signal(string sym, int &first_handle, ConfirmationIndicatorIndex idx1,
      int &second_handle, ConfirmationIndicatorIndex idx2, int limit = 2)
  {
// gather data ==========================================
   ConfirmationSignal signal1 = get_confirmation_indicator_signal(sym, first_handle, idx1, limit);
   ConfirmationSignal signal2 = get_confirmation_indicator_signal(sym, second_handle, idx2, 20);

// buy_signal signal ===========================================
   bool buy_signal =
      (signal1 == BUY_SIGNAL && signal2 == BUY_SIGNAL) ||
      (signal1 == BUY_SIGNAL && signal2 == NO_INDICATOR_SIGNAL) ||
      (signal1 == NO_INDICATOR_SIGNAL && signal2 == BUY_SIGNAL);

   if(buy_signal)
      return BUY_SIGNAL;

// sell_signal signal ==========================================
   bool sell_signal =
      (signal1 == SELL_SIGNAL && signal2 == SELL_SIGNAL) ||
      (signal1 == SELL_SIGNAL && signal2 == NO_INDICATOR_SIGNAL) ||
      (signal1 == NO_INDICATOR_SIGNAL && signal2 == SELL_SIGNAL);

   if(sell_signal)
      return SELL_SIGNAL;

// ======================================================
   bool no_indicator = signal1 == NO_INDICATOR_SIGNAL && signal2 == NO_INDICATOR_SIGNAL;

   if(no_indicator)
      return NO_INDICATOR_SIGNAL;

// ======================================================
   return NO_SIGNAL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_confirmation_indicator_signal(string sym, int &handle, ConfirmationIndicatorIndex idx, int limit)
  {
   switch(ConfirmationIndicatorSignalType[idx])
     {
      case  INDICATOR_SIGNAL_TYPE_ZERO_CROSS:
         return get_zero_cross_confirmation_signal(handle, limit);
         break;

      case  INDICATOR_SIGNAL_TYPE_SLOPE_CHANGE:
         return get_change_slope_confirmation_signal(handle, limit);
         break;

      case  INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS:
         return NO_INDICATOR_SIGNAL;
         break;

      case  INDICATOR_SIGNAL_TYPE_CLOSE_PRICE_CROSS:
         return get_close_price_cross_confirmation_signal(sym, handle);
         break;

      case  INDICATOR_SIGNAL_TYPE_DUMMY:
      default:
         return NO_INDICATOR_SIGNAL;
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_close_price_cross_confirmation_signal(string sym, int &handle)
  {
   double last_close = iClose(sym, PERIOD_CURRENT, 1);
   double last_base_value = get_indicator_value_by_handle(handle);

   if(last_close > last_base_value)
      return BUY_SIGNAL;
   else
      return SELL_SIGNAL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_zero_cross_confirmation_signal(int &handle, int limit = 5)
  {
   double last_indicator_value = get_indicator_value_by_handle(handle, 1);

   double ith_indicator_value;
   int pre_opposite_index = 0;
   for(int i=2; i<=limit; i++)
     {
      ith_indicator_value = get_indicator_value_by_handle(handle, i);
      if(last_indicator_value > 0 && ith_indicator_value < 0)
        {
         pre_opposite_index = i-1;
         break;
        }
      if(last_indicator_value < 0 && ith_indicator_value > 0)
        {
         pre_opposite_index = i-1;
         break;
        }
     }

   bool buy_signal = last_indicator_value > 0 && pre_opposite_index == 0;
   bool sell_signal = last_indicator_value < 0 && pre_opposite_index == 0;

   if(buy_signal)
      return BUY_SIGNAL;
   if(sell_signal)
      return SELL_SIGNAL;
   return NO_SIGNAL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_change_slope_confirmation_signal(int &handle, int limit = 5)
  {
// gather data ==========================================
   double last_indicator_value = get_indicator_value_by_handle(handle);
   double pre_indicator_value = get_indicator_value_by_handle(handle, 2);

   double pre_opposite, last_opposite;
   int pre_opposite_index = 0;
   for(int i=2; i<50; i++)
     {

      last_opposite = get_indicator_value_by_handle(handle, i);
      pre_opposite = get_indicator_value_by_handle(handle, i+1);
      if(last_opposite > pre_opposite && last_indicator_value < pre_indicator_value)
        {
         pre_opposite_index = i-1;
         break;
        }
      if(last_opposite < pre_opposite && last_indicator_value > pre_indicator_value)
        {
         pre_opposite_index = i-1;
         break;
        }
     }

// buy_signal signal ===========================================
   bool buy_signal =
      last_indicator_value > pre_indicator_value && pre_opposite_index < limit
      ;
// sell_signal signal ==========================================
   bool sell_signal =
      last_indicator_value < pre_indicator_value && pre_opposite_index < limit
      ;

   if(buy_signal)
      return BUY_SIGNAL;
   if(sell_signal)
      return SELL_SIGNAL;
   return NO_SIGNAL;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ConfirmationSignal get_INDICATOR_SIGNAL_TYPE_TWO_LINE_CROSS_confirmation_signal(int &handle, int limit = 5)
  {
// gather data ==========================================
   double line1 = get_indicator_value_by_handle(handle, 1, 0);
   double line2 = get_indicator_value_by_handle(handle, 1, 1);

   double line2_opposite, line1_opposite;
   int pre_opposite_index = 0;
   for(int i=2; i<50; i++)
     {

      line1_opposite = get_indicator_value_by_handle(handle, i, 0);
      line2_opposite = get_indicator_value_by_handle(handle, i, 1);
      if(line1_opposite > line2_opposite && line1 < line2)
        {
         pre_opposite_index = i-1;
         break;
        }
      if(line1_opposite < line2_opposite && line1 > line2)
        {
         pre_opposite_index = i-1;
         break;
        }
     }

// buy_signal signal ===========================================
   bool buy_signal =
      line1 > line2 && pre_opposite_index < limit
      ;
// sell_signal signal ==========================================
   bool sell_signal =
      line1 < line2 && pre_opposite_index < limit
      ;

   if(buy_signal)
      return BUY_SIGNAL;
   if(sell_signal)
      return SELL_SIGNAL;
   return NO_SIGNAL;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                TimeUtils.mqh.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime current_candle_time_sec(string symbol = NULL, ENUM_TIMEFRAMES period = PERIOD_CURRENT)
  {
   if(symbol == NULL)
      symbol = Symbol();

   datetime time[1];
   CopyTime(Symbol(), PERIOD_CURRENT, 0, 1, time);

   return time[0];
  }
//+------------------------------------------------------------------+
int get_day_of_the_week()
  {
   long time = SymbolInfoInteger(Symbol(), SYMBOL_TIME);
   MqlDateTime time_struct;
   TimeToStruct(time, time_struct);
   return time_struct.day_of_week;
  }

int get_hour()
  {
   long time = SymbolInfoInteger(Symbol(), SYMBOL_TIME);
   MqlDateTime time_struct;
   TimeToStruct(time, time_struct);
   return time_struct.hour;
  }
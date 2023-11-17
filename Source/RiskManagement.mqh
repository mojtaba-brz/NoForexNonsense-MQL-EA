//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifdef __MQL5__
#include <Math/Stat/Math.mqh>
#else

#endif
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CNoForexNonesenseEA::get_lot_by_sl_diff_and_risk(int risk_percent = 1)
  {
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);

   double lot = (equity * risk_percent*0.01)/
                (100000*sl_diff*currency_base_in_dollar(symbol));
   lot = MathMax(lot, 0.01);
   return NormalizeDouble(lot, 2);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::sl_tp_diff_nnf_method()
  {
#ifdef __MQL5__
   double atr[];
   ArraySetAsSeries(atr, true);
   CopyBuffer(atr_indicator_handle, 0, 1, 1,atr);
#else
   double atr[1];
   atr[0] = iATR(symbol, ea_timeframe, atr_indicator_period, 1);
#endif

   long digits;
   SymbolInfoInteger(symbol, SYMBOL_DIGITS, digits);

   sl_diff = NormalizeDouble(1.5 * atr[0], (int)digits);
   tp_diff = NormalizeDouble(1.0 * atr[0], (int)digits);
  }

//+------------------------------------------------------------------+

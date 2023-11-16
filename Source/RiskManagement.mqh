#include <Math/Stat/Math.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CNoForexNonesenseEA::get_lot_by_sl_diff_and_risk(int risk_percent = 1)
  {
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);

   double lot = (equity * risk_percent*0.01)/
                (100000*sl_diff*currency_base_in_dollar(symbol));
   lot = MathMax(lot, 0.01);
   return MathRound(lot, 2);
  }

void CNoForexNonesenseEA::sl_tp_diff_nnf_method()
{
   double atr[];
   ArraySetAsSeries(atr, true);
   CopyBuffer(atr_indicator_handle, 0, 1, 1,atr);
   
   long digits;
   SymbolInfoInteger(symbol, SYMBOL_DIGITS, digits);
   
   sl_diff = MathRound(1.5 * atr[0], (int)digits);
   tp_diff = MathRound(1.0 * atr[0], (int)digits);
}

//+------------------------------------------------------------------+

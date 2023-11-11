//+------------------------------------------------------------------+
//|                                               RiskManagement.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

#include <Math/Stat/Math.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double currency_base_in_dollar(string symbol = NULL)
  {
   if(symbol == NULL)
     {
      symbol = Symbol();
     }
   double price;
   switch(symbol[3])
     {
      case  'U':
         return 1.;
         break;

      case 'A':
         SymbolInfoDouble("AUDUSD", SYMBOL_ASK, price);
         return price;
         break;

      case 'E':
         SymbolInfoDouble("EURUSD", SYMBOL_ASK, price);
         return price;
         break;

      case 'J':
         SymbolInfoDouble("USDJPY", SYMBOL_ASK, price);
         return MathRound(1/price, 5);
         break;

      case 'G':
         SymbolInfoDouble("GBPUSD", SYMBOL_ASK, price);
         return price;
         break;

      case 'N':
         SymbolInfoDouble("NZDUSD", SYMBOL_ASK, price);
         return price;
         break;

      case 'C':
         if(symbol[4] == 'A')
            SymbolInfoDouble("USDCAD", SYMBOL_ASK, price);
         else
            SymbolInfoDouble("USDCHF", SYMBOL_ASK, price);
         return MathRound(1/price, 5);
         break;

      default:
         Print("warning : symbol not found in price_of_currency_base_in_dollar function");
         return 1.;
         break;
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_lot_by_sl_diff_and_risk(double sl_diff, string symbol = NULL, int risk = 2)
  {
   if(symbol == NULL)
     {
      symbol = Symbol();
     }

   double equity = AccountInfoDouble(ACCOUNT_EQUITY);

   double lot = (equity * risk*0.01)/
                (100000*sl_diff*currency_base_in_dollar(symbol));

   return MathRound(lot, 2);
  }

void sl_tp_diff_nnf_method(string symbol, int &atr_handle, double &sl_diff, double &tp_diff)
{
   double atr[];
   ArraySetAsSeries(atr, true);
   CopyBuffer(atr_handle, 0, 1, 1,atr);
   
   long digits;
   SymbolInfoInteger(symbol, SYMBOL_DIGITS, digits);
   
   sl_diff = MathRound(1.5 * atr[0], (int)digits);
   tp_diff = MathRound(1.0 * atr[0], (int)digits);
}

//+------------------------------------------------------------------+

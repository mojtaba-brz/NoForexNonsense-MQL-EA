#include "../../Libs/NNFMethodLibs.mqh"

double calculate_last_daily_atr(string symbol)
  {
   double close[14], high[14], low[14];
   CopyClose(symbol, PERIOD_D1, 2, 14, close);
   CopyHigh(symbol,  PERIOD_D1, 1, 14, high);
   CopyLow(symbol,   PERIOD_D1, 1, 14, low);

   double sum = 0, true_range;

   for(int i=0; i<14; i++)
     {
      true_range = MathMax(high[i]-low[i], MathAbs(low[i] - close[i]));
      true_range = MathMax(true_range,             MathAbs(high[i] - close[i]));
      sum += true_range;
     }

   return (sum/14);
  }

  
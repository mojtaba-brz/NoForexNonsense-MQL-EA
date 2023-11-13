#include "../../Libs/NNFMethodLibs.mqh"
  
  void get_volume_indicator_handle(int &handle, VolumeIndicatorIndex idx, ENUM_TIMEFRAMES timeframe)
  {
   switch(idx)
     {
      case  NO_VOLUME_INDICATOR:
         handle = -1;

      case VI_SMA:
         handle = iMA(Symbol(), timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         handle = iCustom(Symbol(), timeframe, VolumeIndicatorAddresses[idx]);
         break;
     }

  }
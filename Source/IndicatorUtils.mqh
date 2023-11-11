#include "../Libs/NNFMethodLibs.mqh"

double get_indicator_value_by_handle(int indicator_handle, int shift = 1, int line_index = 0)
  {
   double temp_buffer[];
   ArraySetAsSeries(temp_buffer, true);
   CopyBuffer(indicator_handle, line_index, shift, 1, temp_buffer);

   return temp_buffer[0];
  }

  void get_confirmation_indicator_handle(int &handle, ConfirmationIndicatorIndex idx, ENUM_TIMEFRAMES timeframe)
  {
   switch(idx)
     {
      case  NO_CONFIRMATION_INDICATOR:
         handle = -1;
         break;
         
      case CI_AO:
         handle = iAO(Symbol(), timeframe);
         break;

      case CI_AC:
         handle = iAC(Symbol(), timeframe);
         break;

      case CI_SMA:
         handle = iMA(Symbol(), timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         handle = iCustom(Symbol(), timeframe, ConfirmationIndicatorAddresses[idx]);
         break;
     }

  }
  
  void get_baseline_indicator_handle(int &handle, BaselineIndicatorIndex idx, ENUM_TIMEFRAMES timeframe)
  {
   switch(idx)
     {
      case  NO_BASELINE_INDICATOR:
         handle = -1;

      case BI_SMA:
         handle = iMA(Symbol(), timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         handle = iCustom(Symbol(), timeframe, BaselineIndicatorAddresses[idx]);
         break;
     }

  }
  
  void get_exit_indicator_handle(int &handle, ExitIndicatorIndex idx, ENUM_TIMEFRAMES timeframe)
  {
   switch(idx)
     {
      case  NO_EXIT_INDICATOR:
         handle = -1;

      case EI_SMA:
         handle = iMA(Symbol(), timeframe, 14, 0, MODE_SMA, PRICE_CLOSE);
         break;

      default:
         handle = iCustom(Symbol(), timeframe, ExitIndicatorAddresses[idx]);
         break;
     }

  }
  
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
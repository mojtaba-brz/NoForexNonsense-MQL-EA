#include "../Libs/NNFMethodLibs.mqh"

PositionState get_current_position_state(string symbol, long magic)
  {
   CPosition cp(symbol, magic);

   if(cp.get_total_specified_positions() == 1)
     {
      int pos_type = cp.get_position_type();
      if(pos_type == POSITION_TYPE_BUY)
        {
         return POS_STATE_LONG_POSITION;
        }
      if(pos_type == POSITION_TYPE_SELL)
        {
         return POS_STATE_SHORT_POSITION;
        }
      return POS_STATE_NO_POSITION;
     }
   else
      if(cp.get_total_specified_positions() > 1)
        {
         return POS_STATE_MORE_THAN_ONE_POSITION;
        }
      else
        {
         return POS_STATE_NO_POSITION;
        }
  }
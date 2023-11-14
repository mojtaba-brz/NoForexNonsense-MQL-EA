//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::enter_two_positions()
  {
   if(ea_action == TRADING_ACTION_BUY)
     {
      enter_long_positions_nnf_method();
     }
   else
      if(ea_action == TRADING_ACTION_SELL)
        {
         enter_short_positions_nnf_method();
        }
   ea_mode = MANAGE_THE_POSITION;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::manage_the_positions()
  {

   handle_position_management_logic();
   if(ea_action == TRADING_ACTION_MANAGE_POSITIONS || ea_action == TRADING_ACTION_DO_NOTHING)
     {
      manage_positions_nnf_method();
     }

   else
      if(ea_action == TRADING_ACTION_CLOSE_POSITIONS)
        {
         close_all_specified_positions();
         ea_mode = WAIT_FOR_ENTRY_SIGNAL;
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::set_current_position_state()
  {
   ea_position_state = get_current_position_state(symbol, robot_magic_number);
  }
//+------------------------------------------------------------------+

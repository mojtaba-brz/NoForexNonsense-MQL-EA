void CNoForexNonesenseEA::set_current_position_state()
  {
   CPosition cp(symbol, robot_magic_number);

   if(cp.get_total_specified_positions() == 1)
     {
      int pos_type = cp.get_position_type();
      if(pos_type == POSITION_TYPE_BUY)
        {
         ea_position_state = POS_STATE_LONG_POSITION;
        }
      if(pos_type == POSITION_TYPE_SELL)
        {
         ea_position_state = POS_STATE_SHORT_POSITION;
        }
      ea_position_state = POS_STATE_NO_POSITION;
     }
   else
      if(cp.get_total_specified_positions() > 1)
        {
         ea_position_state = POS_STATE_MORE_THAN_ONE_POSITION;
        }
      else
        {
         ea_position_state = POS_STATE_NO_POSITION;
        }
  }
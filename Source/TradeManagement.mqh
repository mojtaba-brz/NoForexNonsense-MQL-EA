// enter the position with tp ==============================================================
void CNoForexNonesenseEA::enter_long_positions_nnf_method()
  {
   CExecute ex1(symbol, robot_magic_number); // without tp
   CExecute ex2(symbol, robot_magic_number + 1); // with tp
   double vol, ask_price;

   ask_price = SymbolInfoDouble(symbol, SYMBOL_ASK);
   sl_tp_diff_nnf_method();
   vol = get_lot_by_sl_diff_and_risk();

   ex1.Position(TYPE_POSITION_BUY, vol, ask_price-sl_diff);
   Sleep(5);
   ex2.Position(TYPE_POSITION_BUY, vol, ask_price-sl_diff, ask_price+tp_diff);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::enter_short_positions_nnf_method()
  {
   CExecute ex1(symbol, robot_magic_number); // without tp
   CExecute ex2(symbol, robot_magic_number + 1); // with tp
   double vol, ask_price;

   ask_price = SymbolInfoDouble(symbol, SYMBOL_BID);
   sl_tp_diff_nnf_method();
   vol = get_lot_by_sl_diff_and_risk();

   ex1.Position(TYPE_POSITION_SELL, vol, ask_price+sl_diff);
   Sleep(5);
   ex2.Position(TYPE_POSITION_SELL, vol, ask_price+sl_diff, ask_price-tp_diff);
  }

// close position ============================================================================
void CNoForexNonesenseEA::close_all_specified_positions()
  {
   CPosition cp1(symbol, robot_magic_number), cp2(symbol, robot_magic_number + 1);
   cp1.close_all_specified_positions();
   cp2.close_all_specified_positions();
  }

// manage the position without tp ===========================================================
void CNoForexNonesenseEA::manage_positions_nnf_method()
  {
   CPosition   cp1(symbol, robot_magic_number),
               cp2(symbol, robot_magic_number + 1);
   sl_diff = 1.5*get_indicator_value_by_handle(atr_indicator_handle);
   manage_the_trailing_sl_of_position(cp1, sl_diff, pre_sl);
   manage_the_trailing_sl_of_position(cp2, sl_diff, pre_sl);
  }

//+------------------------------------------------------------------+

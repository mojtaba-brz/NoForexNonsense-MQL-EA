//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#include "../Libs/NNFMethodLibs.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void warn_if_there_are_POS_STATE_MORE_THAN_ONE_POSITION(PositionState pos_state)
  {
   if(pos_state == POS_STATE_MORE_THAN_ONE_POSITION)
     {
      Alert("There are more than one trade");
     }
  }

// enter the position with tp ==============================================================
void enter_POS_STATE_LONG_POSITION_nnf_method(string symbol, long magic, int &atr_handle)
  {
   CExecute ex1(symbol, magic); // without tp
   CExecute ex2(symbol, magic + 1); // with tp
   double sl_diff, tp_diff, vol, ask_price;

   ask_price = SymbolInfoDouble(symbol, SYMBOL_ASK);
   sl_tp_diff_nnf_method(symbol, atr_handle, sl_diff, tp_diff);
   vol = get_lot_by_sl_diff_and_risk(sl_diff, symbol, 1);
   vol = MathMin(vol, 1);

   ex1.Position(TYPE_POSITION_BUY, vol, ask_price-sl_diff);
   Sleep(5);
   ex2.Position(TYPE_POSITION_BUY, vol, ask_price-sl_diff, ask_price+tp_diff);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void enter_POS_STATE_SHORT_POSITION_nnf_method(string symbol, long magic, int &atr_handle)
  {
   CExecute ex1(symbol, magic); // without tp
   CExecute ex2(symbol, magic + 1); // with tp
   double sl_diff, tp_diff, vol, ask_price;

   ask_price = SymbolInfoDouble(symbol, SYMBOL_BID);
   sl_tp_diff_nnf_method(symbol, atr_handle, sl_diff, tp_diff);
   vol = get_lot_by_sl_diff_and_risk(sl_diff, symbol, 1);

   ex1.Position(TYPE_POSITION_SELL, vol, ask_price+sl_diff);
   Sleep(5);
   ex2.Position(TYPE_POSITION_SELL, vol, ask_price+sl_diff, ask_price-tp_diff);
  }

// close position ============================================================================
void close_all_specified_positions(string symbol, long magic)
  {
   CPosition cp1(symbol, magic), cp2(symbol, magic + 1);
   cp1.close_all_specified_positions();
   cp2.close_all_specified_positions();
  }

// manage the position without tp ===========================================================
void manage_positions_nnf_method(string symbol, long magic, int &atr_handle, double &pre_sl)
  {
   CPosition   cp1(symbol, magic),
               cp2(symbol, magic + 1);
   PositionState cp1_state = get_current_position_state(symbol, magic),
                 cp2_state = get_current_position_state(symbol, magic + 1);

   if(cp2_state == POS_STATE_NO_POSITION)
     {
      if(cp1_state == POS_STATE_LONG_POSITION)
        {
         double sl = MathMax(cp1.GetPriceOpen() + 10*SymbolInfoDouble(symbol, SYMBOL_POINT), SymbolInfoDouble(symbol, SYMBOL_ASK)-get_indicator_value_by_handle(atr_handle));
         if(pre_sl != EMPTY_VALUE)
            sl = MathMax(sl, pre_sl);
         cp1.Modify(sl);
         pre_sl = sl;
        }
      else
         if(cp1_state == POS_STATE_SHORT_POSITION)
           {
            double sl = MathMin(cp1.GetPriceOpen() - 10*SymbolInfoDouble(symbol, SYMBOL_POINT), SymbolInfoDouble(symbol, SYMBOL_BID)+get_indicator_value_by_handle(atr_handle));
            if(pre_sl != EMPTY_VALUE)
               sl = MathMin(sl, pre_sl);
            cp1.Modify(sl);
            pre_sl = sl;
           }

     }

  }

//+------------------------------------------------------------------+

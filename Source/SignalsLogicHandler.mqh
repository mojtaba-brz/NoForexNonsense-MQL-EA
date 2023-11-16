//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"


// generates do nothing, buy and sell signal
void CNoForexNonesenseEA::handle_the_entry_logic()
  {
   determine_first_confirmation_indicator_entry_signal();
   update_all_indicator_signals();

   bool to_buy_signal = last_first_confirmation_indicator_signal == CI_BUY_SIGNAL;
   bool to_sell_signal = last_first_confirmation_indicator_signal == CI_SELL_SIGNAL;


   bool to_buy_green_light = baseline_buy_signal && second_confirmation_buy_signal && volume_indicator_buy_signal && exit_indicator_buy_signal;
   bool to_sell_green_light = baseline_sell_signal && second_confirmation_sell_signal && volume_indicator_sell_signal && exit_indicator_sell_signal;

   if(to_buy_signal && to_buy_green_light)
     {
      ea_mode = EXECUTE_TWO_MARKET_ORDER;
      ea_action = TRADING_ACTION_BUY;
     }

   else
      if(to_sell_signal && to_sell_green_light)
        {
         ea_mode = EXECUTE_TWO_MARKET_ORDER;
         ea_action = TRADING_ACTION_SELL;
        }
  }

// generates close all and do nothing signal
void CNoForexNonesenseEA::handle_position_management_logic()
  {
   set_current_position_state();
   update_all_indicator_signals_for_entry();

   bool long_position_green_light = baseline_buy_signal && first_confirmation_buy_signal && second_confirmation_buy_signal &&
                                    volume_indicator_buy_signal && exit_indicator_buy_signal;
   bool short_position_green_light = baseline_sell_signal && first_confirmation_sell_signal &&
                                     volume_indicator_sell_signal && exit_indicator_sell_signal;

   switch(ea_position_state)
     {
      case POS_STATE_NO_POSITION:
         ea_mode = WAIT_FOR_ENTRY_SIGNAL;
         ea_action = TRADING_ACTION_DO_NOTHING;
         break;

      case POS_STATE_LONG_POSITION:
         if(long_position_green_light)
           {
            ea_action = TRADING_ACTION_MANAGE_POSITIONS;
           }
         else
           {
            ea_action = TRADING_ACTION_CLOSE_POSITIONS;
           }
         break;

      case POS_STATE_SHORT_POSITION:
         if(short_position_green_light)
           {
            ea_action = TRADING_ACTION_MANAGE_POSITIONS;
           }
         else
           {
            ea_action = TRADING_ACTION_CLOSE_POSITIONS;
           }
         break;

      default:
         Alert("handle_position_management_logic");
         break;
     }


  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::update_all_indicator_signals_for_entry()
  {
   baseline_indicator_signal = get_baseline_signal();
   ConfirmationSignal ci_signal = get_first_confirmation_indicator_signal();
   set_second_confirmation_indicator_signal();
   volume_indicator_signal = get_volume_indicator_signal();
   exit_indicator_signal = get_exit_indicator_signal();


   baseline_sell_signal = baseline_indicator_signal == BI_NO_SIGNAL || baseline_indicator_signal == BI_SAFE_TO_SELL;
   baseline_buy_signal = baseline_indicator_signal == BI_NO_SIGNAL || baseline_indicator_signal == BI_SAFE_TO_BUY;

   first_confirmation_sell_signal = ci_signal == CI_NO_SIGNAL || ci_signal == CI_SELL_SIGNAL;
   first_confirmation_buy_signal = ci_signal == CI_NO_SIGNAL || ci_signal == CI_BUY_SIGNAL;

   second_confirmation_sell_signal = last_second_confirmation_indicator_signal != CI_BUY_SIGNAL;
   second_confirmation_buy_signal = last_second_confirmation_indicator_signal != CI_SELL_SIGNAL;

   volume_indicator_sell_signal = volume_indicator_signal == VI_SAFE_TO_SELL || volume_indicator_signal == VI_NO_SIGNAL;
   volume_indicator_buy_signal = volume_indicator_signal == VI_SAFE_TO_BUY || volume_indicator_signal == VI_NO_SIGNAL;

   exit_indicator_sell_signal = exit_indicator_signal == EI_SAFE_TO_SELL || exit_indicator_signal == EI_NO_SIGNAL;
   exit_indicator_buy_signal = exit_indicator_signal == EI_SAFE_TO_BUY || exit_indicator_signal == EI_NO_SIGNAL;

  }
//+------------------------------------------------------------------+

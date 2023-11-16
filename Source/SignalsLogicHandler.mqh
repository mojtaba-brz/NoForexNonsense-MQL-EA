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
    bool exit_indicator_sell_signal, exit_indicator_buy_signal;

   determine_first_confirmation_indicator_entry_signal();
   
   switch(last_first_confirmation_indicator_signal)
     {
      case CI_BUY_SIGNAL:

         exit_indicator_signal = get_exit_indicator_signal();
         exit_indicator_buy_signal = exit_indicator_signal == EI_SAFE_TO_BUY || exit_indicator_signal == EI_NO_SIGNAL;

         if(exit_indicator_buy_signal){
               ea_mode = EXECUTE_TWO_MARKET_ORDER;
               ea_action = TRADING_ACTION_BUY;
         }
         break;

      case CI_SELL_SIGNAL:

         exit_indicator_signal = get_exit_indicator_signal();
         exit_indicator_sell_signal = exit_indicator_signal == EI_SAFE_TO_SELL || exit_indicator_signal == EI_NO_SIGNAL;

         if(exit_indicator_buy_signal){
               ea_mode = EXECUTE_TWO_MARKET_ORDER;
               ea_action = TRADING_ACTION_SELL;
         }
         break;

      default:
         break;
     }
  }

// generates close all and do nothing signal
void CNoForexNonesenseEA::handle_position_management_logic()
  {
   last_first_confirmation_indicator_signal = get_first_confirmation_indicator_signal();
   set_current_position_state();

   switch(ea_position_state)
     {
      case POS_STATE_NO_POSITION:
         ea_mode = WAIT_FOR_ENTRY_SIGNAL;
         ea_action = TRADING_ACTION_DO_NOTHING;
         break;

      case POS_STATE_LONG_POSITION:
         if(last_first_confirmation_indicator_signal == CI_SELL_SIGNAL)
           {
            ea_action = TRADING_ACTION_CLOSE_POSITIONS;
           }
         else
           {
            ea_action = TRADING_ACTION_MANAGE_POSITIONS;
           }
         break;

      case POS_STATE_SHORT_POSITION:
         if(last_first_confirmation_indicator_signal == CI_BUY_SIGNAL)
           {
            ea_action = TRADING_ACTION_CLOSE_POSITIONS;
           }
         else
           {
            ea_action = TRADING_ACTION_MANAGE_POSITIONS;
           }
         break;

      default:
         Alert("handle_position_management_logic");
         break;
     }


  }
//+------------------------------------------------------------------+

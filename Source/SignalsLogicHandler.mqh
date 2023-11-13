//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

void CNoForexNonesenseEA::handle_the_entry_logic_of_signals()
{
    if(last_first_confirmation_indicator_signal == CI_BUY_SIGNAL)
    {
      ea_mode = ENTER_IN_TWO_POSITIONS;
      ea_action = TRADING_ACTION_BUY;
    }
  
  if(last_first_confirmation_indicator_signal == CI_SELL_SIGNAL)
  {
      ea_mode = ENTER_IN_TWO_POSITIONS;
      ea_action = TRADING_ACTION_SELL;  
  }
    
 }
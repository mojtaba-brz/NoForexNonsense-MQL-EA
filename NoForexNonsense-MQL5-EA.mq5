//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

#include "Libs/NNFMethodLibs.mqh"

// Robot Configs =======================================================
input static long robot_magic_number = 1454536879;
input static ENUM_TIMEFRAMES main_timeframe = PERIOD_D1;

// User Config =======================================================

// Indicators
input BaselineIndicatorIndex base_line_indicator_idx = NO_BASELINE_INDICATOR;
input ConfirmationIndicatorIndex first_confirmation_indicator_idx = CI_SMA;
input ConfirmationIndicatorIndex second_confirmation_indicator_idx = NO_CONFIRMATION_INDICATOR;
input VolumeIndicatorIndex volume_indicator_idx = NO_VOLUME_INDICATOR;
input ExitIndicatorIndex exit_indicator_idx = NO_EXIT_INDICATOR;

// ATR Settings
input ENUM_TIMEFRAMES atr_period = PERIOD_D1;
input int atr_scope = 14;

// Global Variables ==================================================

// flags
static bool    new_candle = false,
               modes_cycle_done = false;
// ints
static int current_time, pre_time = 0;
static int  first_confirmation_indicator_handle,
       second_confirmation_indicator_handle,
       ATRHanlde,
       baseline_handle,
       exit_indicator_handle,
       dummy_hanlde;

static PositionState position_state = POS_STATE_NO_POSITION;
// Doubles
static double pre_sl_aux = EMPTY_VALUE;

// Structs
NNF_EA_Settings nnf_ea_settings;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
// Base ATR
   ATRHanlde = iATR(Symbol(), atr_period, atr_scope);

// Confirmations
   get_confirmation_indicator_handle(first_confirmation_indicator_handle, first_confirmation_indicator_idx, main_timeframe);
   get_confirmation_indicator_handle(second_confirmation_indicator_handle, second_confirmation_indicator_idx, main_timeframe);

// Baselines
   get_baseline_indicator_handle(baseline_handle, base_line_indicator_idx, main_timeframe);

// Exit Indicator
   get_exit_indicator_handle(exit_indicator_handle, exit_indicator_idx, main_timeframe);

   nnf_ea_settings.robot_magic_number = robot_magic_number;
   nnf_ea_settings.main_timeframe = main_timeframe;
   nnf_ea_settings.base_line_indicator_idx = base_line_indicator_idx;
   nnf_ea_settings.first_confirmation_indicator_idx = first_confirmation_indicator_idx;
   nnf_ea_settings.second_confirmation_indicator_idx = second_confirmation_indicator_idx;
   nnf_ea_settings.volume_indicator_idx = volume_indicator_idx;
   nnf_ea_settings.exit_indicator_idx = exit_indicator_idx;
   nnf_ea_settings.atr_period = atr_period;
   nnf_ea_settings.atr_scope = atr_scope;
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   IndicatorRelease(ATRHanlde);
   IndicatorRelease(first_confirmation_indicator_handle);
   IndicatorRelease(second_confirmation_indicator_handle);
   IndicatorRelease(baseline_handle);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   current_time = (int)current_candle_time_sec();
   new_candle = current_time > pre_time;

   if(new_candle)
     {
      position_state = get_current_position_state(Symbol(), robot_magic_number);
      warn_if_there_are_POS_STATE_MORE_THAN_ONE_POSITION(position_state);
      modes_cycle_done = false;
      TradingAction requested_action = TRADING_ACTION_DO_NOTHING;
      ConfirmationSignal confirmation_signal = NO_SIGNAL;
      ExitSignal exit_signal = NO_EXIT_SIGNAL;
      BaselineSignal base_line = CLOSE_IS_TOO_FAR;
      NNF_EA_Mode MainEAState = MARKET_STATES_CALCULATION;
      MqlDateTime c_time;
      TimeToStruct(current_candle_time_sec(), c_time);
      bool allowed_trade_time = true;
      while(!modes_cycle_done)
        {
         switch(MainEAState)
           {
            case  MARKET_STATES_CALCULATION:// ===============================================================
               //---
               // baseline : safe to buy/sell and 
               base_line = get_baseline_signal(Symbol(), baseline_handle, base_line_indicator_idx, ATRHanlde);
               // confirmation : buy, sell, close, do nothing,
               confirmation_signal = get_first_and_second_confirmation_indicator_signal(Symbol(), first_confirmation_indicator_handle, first_confirmation_indicator_idx,
                                     second_confirmation_indicator_handle, second_confirmation_indicator_idx, 2);
               // volume : is safe to trade
               // Exit Indicator : safe to buy/sell signal
               exit_signal = get_exit_indicator_signal(Symbol(), exit_indicator_handle, exit_indicator_idx);

               MainEAState = ACTION_DETERMINATION;
               break;

            case  ACTION_DETERMINATION:// ===============================================================
              {
               bool to_buy =
                  ((confirmation_signal == BUY_SIGNAL && (base_line == BUY_ALLOWED || base_line == NO_BASE_LINE)) ||
                   (confirmation_signal == NO_INDICATOR_SIGNAL && base_line == BUY_ALLOWED))  && (exit_signal == SAFE_TO_BUY || exit_signal == NO_EXIT_SIGNAL)
                  ;
               bool to_sell =
                  ((confirmation_signal == SELL_SIGNAL && (base_line == SELL_ALLOWED || base_line == NO_BASE_LINE)) ||
                   (confirmation_signal == NO_INDICATOR_SIGNAL && base_line == SELL_ALLOWED))  && (exit_signal == SAFE_TO_SELL || exit_signal == NO_EXIT_SIGNAL)
                  ;
               bool to_close =
                  (position_state == POS_STATE_SHORT_POSITION && (confirmation_signal == BUY_SIGNAL || base_line == BUY_ALLOWED || exit_signal == SAFE_TO_BUY)) ||
                  (position_state == POS_STATE_LONG_POSITION && (confirmation_signal == SELL_SIGNAL || base_line == SELL_ALLOWED || exit_signal == SAFE_TO_SELL));

               if(to_buy && allowed_trade_time)
                  requested_action = TRADING_ACTION_BUY;
               else
                  if(to_sell && allowed_trade_time)
                     requested_action = TRADING_ACTION_SELL;
                  else
                     if(to_close)
                        requested_action = TRADING_ACTION_CLOSE_POSITIONS;
                     else
                        requested_action = TRADING_ACTION_DO_NOTHING;
              }
            if((requested_action == TRADING_ACTION_DO_NOTHING || requested_action == TRADING_ACTION_CLOSE_POSITIONS) && position_state == POS_STATE_NO_POSITION)
              {
               MainEAState = IDLE_MODE;
              }
            else
              {
               MainEAState = MANAGE_THE_POSITION;
              }
            break;

            case  MANAGE_THE_POSITION:// ===============================================================
               if(position_state == POS_STATE_NO_POSITION)
                 {
                  pre_sl_aux = EMPTY_VALUE;
                  if(requested_action == TRADING_ACTION_BUY)
                    {
                     enter_POS_STATE_LONG_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                    }
                  else
                     if(requested_action == TRADING_ACTION_SELL)
                       {
                        enter_POS_STATE_SHORT_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                       }

                 }
               else
                  if(position_state == POS_STATE_LONG_POSITION)
                    {
                     if(requested_action == TRADING_ACTION_BUY || requested_action == TRADING_ACTION_DO_NOTHING)
                       {
                        manage_positions_nnf_method(Symbol(), robot_magic_number, ATRHanlde, pre_sl_aux);
                       }
                     else
                        if(requested_action == TRADING_ACTION_SELL)
                          {
                           close_all_specified_positions(Symbol(), robot_magic_number);
                           enter_POS_STATE_SHORT_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                          }
                        else
                           if(requested_action == TRADING_ACTION_CLOSE_POSITIONS)
                             {
                              close_all_specified_positions(Symbol(), robot_magic_number);
                             }
                    }
                  else
                     if(position_state == POS_STATE_SHORT_POSITION)
                       {
                        if(requested_action == TRADING_ACTION_SELL || requested_action == TRADING_ACTION_DO_NOTHING)
                          {
                           manage_positions_nnf_method(Symbol(), robot_magic_number, ATRHanlde, pre_sl_aux);
                          }
                        else
                           if(requested_action == TRADING_ACTION_BUY)
                             {
                              close_all_specified_positions(Symbol(), robot_magic_number);
                              enter_POS_STATE_LONG_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                             }
                           else
                              if(requested_action == TRADING_ACTION_CLOSE_POSITIONS)
                                {
                                 close_all_specified_positions(Symbol(), robot_magic_number);
                                }
                       }
               MainEAState = IDLE_MODE;
               break;

            case IDLE_MODE:
            default:
               modes_cycle_done = true;
               MainEAState = MARKET_STATES_CALCULATION;
               break; // ===============================================================
           }
        }
      pre_time = current_time;
     }
  }
//+------------------------------------------------------------------+

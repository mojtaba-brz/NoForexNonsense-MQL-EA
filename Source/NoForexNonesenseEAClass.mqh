//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

#include "../Libs/NNFMethodLibs.mqh"
#include "NoForexNonesenseEADataTypes.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CNoForexNonesenseEA
  {
private:
   // Private functions --------------------------------------------------------------------------------------------------
   void                 determine_first_confirmation_indicator_signal();
   void                 set_confirmation_indicators_handle();
   ConfirmationSignal   get_confirmation_indicator_signal(int shift = 1);
   void                 get_confirmation_indicator_current_signal_and_its_index(ConfirmationSignal &current_signal, int &index);
   void                 set_current_position_state();
   void                 handle_the_entry_logic_of_signals();

   // Private Variables --------------------------------------------------------------------------------------------------
   // Class config params
   long                          robot_magic_number;
   ENUM_TIMEFRAMES               main_timeframe;
   string                        symbol;

   ENUM_TIMEFRAMES               atr_indicator_period;
   int                           atr_indicator_scope;
   int                           atr_indicator_handle;

   BaselineIndicatorIndex        base_line_indicator_idx;
   int                           baseline_indicator_handle;

   ConfirmationIndicatorIndex    first_confirmation_indicator_idx;
   int                           first_confirmation_indicator_handle;
   ConfirmationSignal            last_first_confirmation_indicator_signal;

   ConfirmationIndicatorIndex    second_confirmation_indicator_idx;
   int                           second_confirmation_indicator_handle;
   ConfirmationSignal            last_second_confirmation_indicator_signal;

   VolumeIndicatorIndex          volume_indicator_idx;
   int                           volume_indicator_handle;

   ExitIndicatorIndex            exit_indicator_idx;
   int                           exit_indicator_handle;

   bool                          use_one_candle_rule;
   bool                          use_continuation_trades;
   bool                          use_pullbacks;
   bool                          use_dollor_evz_as_the_volatility_index;

   // class memory
   int                           current_time, pre_time;
   bool                          new_candle, mode_changed;
   EA_Mode                       ea_mode, pre_ea_mode;
   PositionState                 ea_position_state;
   TradingAction                 ea_action;

public:
                     CNoForexNonesenseEA() {}
                    ~CNoForexNonesenseEA();

   // Main functions -----------------------------------------------------------------------------------------------------
   void              init(string _symbol,
                          long _robot_magic_number = 1454536879,
                          ENUM_TIMEFRAMES _main_timeframe = PERIOD_D1,

                          BaselineIndicatorIndex _base_line_indicator_idx = NO_BASELINE_INDICATOR,
                          ConfirmationIndicatorIndex _first_confirmation_indicator_idx = CI_SMA,
                          ConfirmationIndicatorIndex _second_confirmation_indicator_idx = NO_CONFIRMATION_INDICATOR,
                          VolumeIndicatorIndex _volume_indicator_idx = NO_VOLUME_INDICATOR,
                          ExitIndicatorIndex _exit_indicator_idx = NO_EXIT_INDICATOR,

                          ENUM_TIMEFRAMES _atr_period = PERIOD_D1,
                          int _atr_scope = 14);

   void              set_params();
   void              step();
   void              reset();

   // Output and Report functions ----------------------------------------------------------------------------------------


   // Public Variables ---------------------------------------------------------------------------------------------------
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::~CNoForexNonesenseEA()
  {
   IndicatorRelease(atr_indicator_handle);
   IndicatorRelease(first_confirmation_indicator_handle);
   IndicatorRelease(second_confirmation_indicator_handle);
//    IndicatorRelease(baseline_handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::init(string _symbol,
                               long _robot_magic_number = 1454536879,
                               ENUM_TIMEFRAMES _main_timeframe = PERIOD_D1,

                               BaselineIndicatorIndex _base_line_indicator_idx = NO_BASELINE_INDICATOR,
                               ConfirmationIndicatorIndex _first_confirmation_indicator_idx = CI_SMA,
                               ConfirmationIndicatorIndex _second_confirmation_indicator_idx = NO_CONFIRMATION_INDICATOR,
                               VolumeIndicatorIndex _volume_indicator_idx = NO_VOLUME_INDICATOR,
                               ExitIndicatorIndex _exit_indicator_idx = NO_EXIT_INDICATOR,

                               ENUM_TIMEFRAMES _atr_period = PERIOD_D1,
                               int _atr_scope = 14)
  {
   pre_time = 0;
   symbol = _symbol;
   robot_magic_number = _robot_magic_number;
   main_timeframe     = _main_timeframe;

   base_line_indicator_idx = _base_line_indicator_idx;
   first_confirmation_indicator_idx = _first_confirmation_indicator_idx;
   second_confirmation_indicator_idx = _second_confirmation_indicator_idx;
   volume_indicator_idx = _volume_indicator_idx;
   exit_indicator_idx = _exit_indicator_idx;
   atr_indicator_period = _atr_period;
   atr_indicator_scope = _atr_scope;


// Base ATR
   atr_indicator_handle = iATR(_symbol, atr_indicator_period, atr_indicator_scope);

// Confirmations
   set_confirmation_indicators_handle();

// Baselines
//get_baseline_indicator_handle(baseline_handle, base_line_indicator_idx, main_timeframe);

// Exit Indicator
//get_exit_indicator_handle(exit_indicator_handle, exit_indicator_idx, main_timeframe);

   set_current_position_state();
   if(ea_position_state == POS_STATE_NO_POSITION)
     {
      ea_mode = WAIT_FOR_ENTRY_SIGNAL;
     }
   else
     {
      ea_mode = MANAGE_THE_POSITION;
     }
     pre_ea_mode = ENTER_IN_TWO_POSITIONS;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::step()
  {
   current_time = (int)current_candle_time_sec(symbol, main_timeframe);
   new_candle = current_time > pre_time;
   mode_changed = pre_ea_mode != ea_mode;

   if(new_candle || mode_changed)
     {
      switch(ea_mode)
        {
// ===============================================================================================================================
         case  WAIT_FOR_ENTRY_SIGNAL:
            determine_first_confirmation_indicator_signal();
            handle_the_entry_logic_of_signals();
            break;
// ===============================================================================================================================
            
         case ENTER_IN_TWO_POSITIONS:
            
            break;
// ===============================================================================================================================
            
         case MANAGE_THE_POSITION:
            if(ea_position_state == POS_STATE_NO_POSITION)
              {
               pre_sl_aux = EMPTY_VALUE;
               if(ea_action == TRADING_ACTION_BUY)
                 {
                  enter_POS_STATE_LONG_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                 }
               else
                  if(ea_action == TRADING_ACTION_SELL)
                    {
                     enter_POS_STATE_SHORT_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                    }

              }
            else
               if(ea_position_state == POS_STATE_LONG_POSITION)
                 {
                  if(ea_action == TRADING_ACTION_BUY || ea_action == TRADING_ACTION_DO_NOTHING)
                    {
                     manage_positions_nnf_method(Symbol(), robot_magic_number, ATRHanlde, pre_sl_aux);
                    }
                  else
                     if(ea_action == TRADING_ACTION_SELL)
                       {
                        close_all_specified_positions(Symbol(), robot_magic_number);
                        enter_POS_STATE_SHORT_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                       }
                     else
                        if(ea_action == TRADING_ACTION_CLOSE_POSITIONS)
                          {
                           close_all_specified_positions(Symbol(), robot_magic_number);
                          }
                 }
               else
                  if(ea_position_state == POS_STATE_SHORT_POSITION)
                    {
                     if(ea_action == TRADING_ACTION_SELL || ea_action == TRADING_ACTION_DO_NOTHING)
                       {
                        manage_positions_nnf_method(Symbol(), robot_magic_number, ATRHanlde, pre_sl_aux);
                       }
                     else
                        if(ea_action == TRADING_ACTION_BUY)
                          {
                           close_all_specified_positions(Symbol(), robot_magic_number);
                           enter_POS_STATE_LONG_POSITION_nnf_method(Symbol(), robot_magic_number, ATRHanlde);
                          }
                        else
                           if(ea_action == TRADING_ACTION_CLOSE_POSITIONS)
                             {
                              close_all_specified_positions(Symbol(), robot_magic_number);
                             }
                    }

            break;
        }

      pre_time = current_time;
      pre_ea_mode = ea_mode;
     }

  }

#include "ConfirmationIndicator.mqh"
#include "PositionManagement.mqh"
//+------------------------------------------------------------------+

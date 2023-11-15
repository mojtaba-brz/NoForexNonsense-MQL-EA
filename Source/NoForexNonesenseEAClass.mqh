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
   void                 determine_first_confirmation_indicator_entry_signal();
   void                 set_confirmation_indicators_handle();
   ConfirmationSignal   get_first_confirmation_indicator_signal(int shift = 1);
   ConfirmationSignal   general_signal_to_confirmation_signal(GeneralSignal signal);
   ConfirmationSignal   get_second_confirmation_indicator_signal(int shift = 1);
   void                 get_first_confirmation_indicator_current_signal_and_its_index(ConfirmationSignal &current_signal, int &index);

   void                 enter_long_positions_nnf_method();
   void                 enter_short_positions_nnf_method();
   void                 close_all_specified_positions();
   void                 manage_positions_nnf_method();
   double               get_lot_by_sl_diff_and_risk(int risk_percent = 1);
   void                 sl_tp_diff_nnf_method();
   void                 enter_two_positions();
   void                 manage_the_positions();
   void                 set_current_position_state();

   void                 handle_position_management_logic();
   void                 handle_the_entry_logic();


   // Private Variables --------------------------------------------------------------------------------------------------
   // Class config params
   long                          robot_magic_number;
   ENUM_TIMEFRAMES               ea_timeframe;
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
   double                        pre_sl, sl_diff, tp_diff;

public:
                     CNoForexNonesenseEA() {}
                    ~CNoForexNonesenseEA();

   // Main functions -----------------------------------------------------------------------------------------------------
   void              init(string _symbol,
                          long _robot_magic_number = 1454536879,
                          ENUM_TIMEFRAMES _ea_timeframe = PERIOD_D1,

                          BaselineIndicatorIndex _base_line_indicator_idx = NO_BASELINE_INDICATOR,
                          ConfirmationIndicatorIndex _first_confirmation_indicator_idx = CI_SMA,
                          ConfirmationIndicatorIndex _second_confirmation_indicator_idx = NO_CONFIRMATION_INDICATOR,
                          VolumeIndicatorIndex _volume_indicator_idx = NO_VOLUME_INDICATOR,
                          ExitIndicatorIndex _exit_indicator_idx = NO_EXIT_INDICATOR,

                          ENUM_TIMEFRAMES _atr_period = PERIOD_D1,
                          int _atr_scope = 14);

   void              set_params() {}
   void              on_tick();
   void              reset() {}

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
                               ENUM_TIMEFRAMES _ea_timeframe = PERIOD_D1,

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
   ea_timeframe     = _ea_timeframe;

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
//get_baseline_indicator_handle(baseline_handle, base_line_indicator_idx, ea_timeframe);

// Exit Indicator
//get_exit_indicator_handle(exit_indicator_handle, exit_indicator_idx, ea_timeframe);

   use_one_candle_rule = true;
   use_continuation_trades = true;
   use_pullbacks = true;
   use_dollor_evz_as_the_volatility_index = true;

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

   pre_sl = EMPTY_VALUE;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::on_tick()
  {
   current_time = (int)current_candle_time_sec(symbol, ea_timeframe);
   new_candle = current_time > pre_time;
   mode_changed = pre_ea_mode != ea_mode;

   if(new_candle || mode_changed)
     {
      pre_ea_mode = ea_mode;
      
      switch(ea_mode)
        {
         // ===============================================================================================================================
         case  WAIT_FOR_ENTRY_SIGNAL:
            handle_the_entry_logic();
            break;
         // ===============================================================================================================================

         case ENTER_IN_TWO_POSITIONS:
            enter_two_positions();
            break;
         // ===============================================================================================================================

         case MANAGE_THE_POSITION:
            manage_the_positions();
            break;
        }

      pre_time = current_time;
     }

  }



#include "ConfirmationIndicator.mqh"
#include "PositionManagement.mqh"
#include "RiskManagement.mqh"
#include "TradeManagement.mqh"
#include "SignalsLogicHandler.mqh"
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                          NoForexNonsense-MQL4-EA |
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
   BaselineSignal        get_baseline_signal();

#ifdef __MQL4__
   double                get_indicator_value(int indicator_type, int shift = 1, int line_index = 0);
   double                get_baseline_value_mt4(int shift = 1, int line_index = 0);
   double                get_confirmation_indicator_value_mt4(int indicator_index = NO_CONFIRMATION_INDICATOR, int shift = 1, int line_index = 0, int config_param = 14);
   double                get_volume_indicator_value_mt4(int shift = 1, int line_index = 0);
   double                get_exit_indicator_value_mt4(int shift = 1, int line_index = 0);

   GeneralSignal         get_close_price_cross_general_signal(string sym, int &handle, ENUM_TIMEFRAMES time_frame, int shift = 1);
   GeneralSignal         get_zero_cross_general_signal(int &handle, int shift = 1);
   GeneralSignal         get_change_slope_general_signal(int &handle, int shift = 1);
   GeneralSignal         get_two_line_cross_general_signal(int &handle, int shift = 1);
#else
   int                   get_baseline_indicator_handle();
   int                   get_confirmation_indicators_handle(int index, int config_param = 14);
   int                   get_volume_indicator_handle();
   int                   get_exit_indicator_handle();
#endif

   void                 determine_first_confirmation_indicator_entry_signal();
   ConfirmationSignal   get_first_confirmation_indicator_signal(int shift = 1);
   ConfirmationSignal   general_signal_to_confirmation_signal(GeneralSignal signal);
   void                 set_second_confirmation_indicator_signal(int shift = 1);
   void                 get_first_confirmation_indicator_current_signal_and_its_index(ConfirmationSignal &current_signal, int &index);

   VolumeIndicatorSignal   get_volume_indicator_signal(int shift = 1);

   ExitSignal           get_exit_indicator_signal(int shift = 1);

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
   void                 update_all_indicator_signals_for_entry();
   void                 update_all_indicator_signals_for_position_management();


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
   BaselineSignal                baseline_indicator_signal;
   int                           baseline_config_parameter;

   ConfirmationIndicatorIndex    first_confirmation_indicator_idx;
   int                           first_confirmation_indicator_handle;
   ConfirmationSignal            last_first_confirmation_indicator_signal;
   int                           first_confirmation_config_parameter;

   ConfirmationIndicatorIndex    second_confirmation_indicator_idx;
   int                           second_confirmation_indicator_handle;
   ConfirmationSignal            last_second_confirmation_indicator_signal;
   int                           second_confirmation_config_parameter;

   VolumeIndicatorIndex          volume_indicator_idx;
   int                           volume_indicator_handle;
   VolumeIndicatorSignal         volume_indicator_signal;
   int                           volume_config_parameter;

   ExitIndicatorIndex            exit_indicator_idx;
   int                           exit_indicator_handle;
   ExitSignal                    exit_indicator_signal;
   int                           exit_config_parameter;

   bool                          use_one_candle_rule;
   bool                          use_continuation_trades;
   bool                          use_pullbacks;
   bool                          use_dollor_evz_as_the_volatility_index;

   // class memory
   int                           current_time, pre_time;
   bool                          new_candle, mode_changed;
   bool                          exit_indicator_sell_signal, exit_indicator_buy_signal,
                                 baseline_sell_signal, baseline_buy_signal,
                                 first_confirmation_sell_signal, first_confirmation_buy_signal,
                                 second_confirmation_sell_signal, second_confirmation_buy_signal,
                                 volume_indicator_green_light;
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
                          int _atr_scope = 14,
                          int _baseline_config_parameter = 14,
                          int _first_confirmation_config_parameter = 14,
                          int _second_confirmation_config_parameter = 14,
                          int _volume_config_parameter = 14,
                          int _exit_config_parameter = 14);

   void              set_params() {}
   void              on_tick();
   void              reset() {}
  };

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CNoForexNonesenseEA::~CNoForexNonesenseEA()
  {
#ifdef __MQL5__
   IndicatorRelease(atr_indicator_handle);
   IndicatorRelease(first_confirmation_indicator_handle);
   IndicatorRelease(second_confirmation_indicator_handle);
   IndicatorRelease(baseline_indicator_handle);
#endif
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
                               int _atr_scope = 14,
                               int _baseline_config_parameter = 14,
                               int _first_confirmation_config_parameter = 14,
                               int _second_confirmation_config_parameter = 14,
                               int _volume_config_parameter = 14,
                               int _exit_config_parameter = 14)
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

   baseline_config_parameter = _baseline_config_parameter;
   first_confirmation_config_parameter = _first_confirmation_config_parameter;
   second_confirmation_config_parameter = _second_confirmation_config_parameter;
   volume_config_parameter = _volume_config_parameter;
   exit_config_parameter = _exit_config_parameter;

#ifdef __MQL5__
   atr_indicator_handle = iATR(symbol, atr_indicator_period, atr_indicator_scope);
   baseline_indicator_handle = get_baseline_indicator_handle();
   first_confirmation_indicator_handle =  get_confirmation_indicators_handle(first_confirmation_indicator_idx, first_confirmation_config_parameter);
   second_confirmation_indicator_handle =  get_confirmation_indicators_handle(second_confirmation_indicator_idx, second_confirmation_config_parameter);
   volume_indicator_handle = get_volume_indicator_handle();
   exit_indicator_handle = get_exit_indicator_handle();
#else
   atr_indicator_handle = I_TYPE_ATR;
   baseline_indicator_handle = I_TYPE_BASELINE;
   first_confirmation_indicator_handle = I_TYPE_CONFIRMATION;
   second_confirmation_indicator_handle = I_TYPE_2ND_CONFIRMATION;
   volume_indicator_handle = I_TYPE_VOLUME;
   exit_indicator_handle = I_TYPE_EXIT;
#endif

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
   pre_ea_mode = EXECUTE_TWO_MARKET_ORDER;

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

         case EXECUTE_TWO_MARKET_ORDER:
            enter_two_positions();
            break;

         case MANAGE_THE_POSITION:
            manage_the_positions();
            break;

         default:
            // pass
            break;
        }

      pre_time = current_time;
     }

   switch(ea_mode)
     {
      case EXECUTE_TWO_MARKET_ORDER:
         enter_two_positions();
         break;
      case MANAGE_THE_POSITION:
         manage_positions_nnf_method();
         break;
      default:
         // pass
         break;
     }

  }


#include "IndicatorUtilsMT4.mqh"
#include "Baseline.mqh"
#include "ConfirmationIndicator.mqh"
#include "VolumeIndicator.mqh"
#include "ExitIndicator.mqh"
#include "PositionManagement.mqh"
#include "RiskManagement.mqh"
#include "TradeManagement.mqh"
#include "SignalsLogicHandler.mqh"
//+------------------------------------------------------------------+

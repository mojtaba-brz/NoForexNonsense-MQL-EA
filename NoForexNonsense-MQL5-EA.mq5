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

static PositionState position_state = POS_STATE_NO_POSITION;
// Doubles
static double pre_sl_aux = EMPTY_VALUE;

// Classes
CNoForexNonesenseEA nnf_ea;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   nnf_ea.init(Symbol());
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
      nnf_ea.step();
  }
//+------------------------------------------------------------------+

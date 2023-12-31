//+------------------------------------------------------------------+
//|                                                   Mql Side TRBot |
//|                              Email : mojtababahrami147@gmail.com |
//+------------------------------------------------------------------+
#property description "Main TRBot EA"
#property description "Athur : Mojtaba Bahrami"
#property description "Email : mojtababahrami147@gmail.com"
#property copyright "MIT"

#include "Libs/NNFMethodLibs.mqh"

// Robot Configs =====================================================
input static long robot_magic_number = 1454536879;
input static ENUM_TIMEFRAMES ea_timeframe = PERIOD_D1;

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
// Classes
CNoForexNonesenseEA nnf_ea;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(first_confirmation_indicator_idx == NO_CONFIRMATION_INDICATOR) ExpertRemove();
   nnf_ea.init(Symbol(),
               robot_magic_number,
               ea_timeframe,
               base_line_indicator_idx,
               first_confirmation_indicator_idx,
               second_confirmation_indicator_idx,
               volume_indicator_idx,
               exit_indicator_idx,
               atr_period,
               atr_scope);

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
   nnf_ea.on_tick();
  }
//+------------------------------------------------------------------+

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
input BaselineIndicatorIndex base_line_indicator_idx = NO_BASELINE_INDICATOR; //Baseline
input int baseline_config_param = 14; // Baseline Param

input ConfirmationIndicatorIndex first_confirmation_indicator_idx = CI_SMA; // 1st Confirmation
input int first_confirmation_config_param = 14; // 1st Confirmation Param

input ConfirmationIndicatorIndex second_confirmation_indicator_idx = NO_CONFIRMATION_INDICATOR; // 2nd Confirmation
input int second_confirmation_config_param = 14; // 2nd Confirmation Param

input VolumeIndicatorIndex volume_indicator_idx = NO_VOLUME_INDICATOR; // Volume Indicator
input int volume_config_param = 14; // Volume Indicator Param

input ExitIndicatorIndex exit_indicator_idx = NO_EXIT_INDICATOR; // Exit Indicator
input int exit_config_param = 14; // Exit Indicator Param

// ATR Settings
input ENUM_TIMEFRAMES atr_period = PERIOD_D1; // ATR Period
input int atr_scope = 14; // ATR Length

// Global Variables ==================================================
// Classes
CNoForexNonesenseEA nnf_ea;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(first_confirmation_indicator_idx == NO_CONFIRMATION_INDICATOR)
      ExpertRemove();
      
   nnf_ea.init(Symbol(),
               robot_magic_number,
               ea_timeframe,
               base_line_indicator_idx,
               first_confirmation_indicator_idx,
               second_confirmation_indicator_idx,
               volume_indicator_idx,
               exit_indicator_idx,
               atr_period,
               atr_scope,
               baseline_config_param,
               first_confirmation_config_param,
               second_confirmation_config_param,
               volume_config_param,
               exit_config_param);

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

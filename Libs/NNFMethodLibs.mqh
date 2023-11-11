//+------------------------------------------------------------------+
//|                                                AllNeededLibs.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

// this file include all libraries is needed for main EA

// Local Sources and Libs
#include "typedefs.mqh"
#include "IndicatorsBank.mqh"
#include "../Source/TimeUtils.mqh"
#include "../Source/RiskManagement.mqh"
#include "../Source/TradeManagement.mqh"
#include "../Source/PositionManagementUtils.mqh"
#include "../Source/IndicatorUtils.mqh"

#include "../Source/ConfirmationIndicator/ConfirmationIndicatorCommon.mqh"
#ifdef __MQL5__
    #include "../Source/ConfirmationIndicator/ConfirmationIndicatorMT5.mqh"
#else
    #include "../Source/ConfirmationIndicator/ConfirmationIndicatorMT4.mqh"
#endif

#include "../Source/Baseline/BaselineCommon.mqh"
#include "../Source/ExitIndicator/ExitIndicatorCommon.mqh"

// Submodules
#include "MQL_Easy/MQL_Easy/MQL_Easy.mqh"
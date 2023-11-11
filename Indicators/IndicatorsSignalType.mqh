#include "../Libs/typedefs.mqh"

#undef add_confirmation_indicator
#undef add_baseline_indicator
#undef add_exit_indicator
#undef add_volume_indicator

#define add_confirmation_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_baseline_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_exit_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_volume_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address, 

IndicatorSignalType ConfirmationIndicatorSignalType[] {
#include "Table_ConfirmationIndicators.mqh"
INDICATOR_SIGNAL_TYPE_DUMMY
};

IndicatorSignalType BaselineIndicatorSignalType[] {
#include "Table_BaselineIndicators.mqh"
INDICATOR_SIGNAL_TYPE_DUMMY
};

IndicatorSignalType ExitIndicatorSignalType[] {
#include "Table_ExitIndicators.mqh"
INDICATOR_SIGNAL_TYPE_DUMMY
};

IndicatorSignalType VolumeIndicatorSignalType[] {
#include "Table_VolumeIndicators.mqh"
INDICATOR_SIGNAL_TYPE_DUMMY
};
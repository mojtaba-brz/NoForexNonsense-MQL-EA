#undef add_confirmation_indicator
#undef add_baseline_indicator
#undef add_exit_indicator
#undef add_volume_indicator

#define add_confirmation_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_baseline_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_exit_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address,
#define add_volume_indicator(indicator_enum_name, indicator_address, indicator_signal_type) indicator_address, 

string ConfirmationIndicatorAddresses[] {
#include "Table_ConfirmationIndicators.mqh"
""
};

string BaselineIndicatorAddresses[] {
#include "Table_BaselineIndicators.mqh"
""
};

string ExitIndicatorAddresses[] {
#include "Table_ExitIndicators.mqh"
""
};

string VolumeIndicatorAddresses[] {
#include "Table_VolumeIndicators.mqh"
""
};
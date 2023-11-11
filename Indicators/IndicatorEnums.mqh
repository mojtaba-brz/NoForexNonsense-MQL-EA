#undef add_confirmation_indicator
#undef add_baseline_indicator
#undef add_exit_indicator
#undef add_volume_indicator

#define add_confirmation_indicator(indicator_enum_name, indicator_address, indicator_signal_type) CI_##indicator_enum_name,
#define add_baseline_indicator(indicator_enum_name, indicator_address, indicator_signal_type) BI_##indicator_enum_name,
#define add_exit_indicator(indicator_enum_name, indicator_address, indicator_signal_type) EI_##indicator_enum_name,
#define add_volume_indicator(indicator_enum_name, indicator_address, indicator_signal_type) VI_##indicator_enum_name, 

enum ConfirmationIndicatorIndex {
#include "Table_ConfirmationIndicators.mqh"
NO_CONFIRMATION_INDICATOR
};

enum BaselineIndicatorIndex {
#include "Table_BaselineIndicators.mqh"
NO_BASELINE_INDICATOR
};

enum ExitIndicatorIndex {
#include "Table_ExitIndicators.mqh"
NO_EXIT_INDICATOR
};

enum VolumeIndicatorIndex {
#include "Table_VolumeIndicators.mqh"
NO_VOLUME_INDICATOR
};
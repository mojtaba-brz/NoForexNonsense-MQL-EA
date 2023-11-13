struct NNF_EA_Settings
{
   long robot_magic_number;
   ENUM_TIMEFRAMES main_timeframe;
   
   BaselineIndicatorIndex base_line_indicator_idx;
   ConfirmationIndicatorIndex first_confirmation_indicator_idx;
   ConfirmationIndicatorIndex second_confirmation_indicator_idx;
   VolumeIndicatorIndex volume_indicator_idx;
   ExitIndicatorIndex exit_indicator_idx;

   ENUM_TIMEFRAMES atr_period;
   int atr_scope;
};
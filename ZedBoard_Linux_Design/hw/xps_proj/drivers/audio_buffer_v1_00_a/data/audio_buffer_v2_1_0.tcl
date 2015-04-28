##############################################################################
## Filename:          C:\SoC_project\Audio_2015_v0.01\adau1761\adau1761\ZedBoard_Linux_Design\hw\xps_proj/drivers/audio_buffer_v1_00_a/data/audio_buffer_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Apr 13 19:59:52 2015 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "audio_buffer" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}

# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z020clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.cache/wt [current_project]
set_property parent.project_path /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_repo_paths {
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator
} [current_project]
set_property ip_output_repo /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/4bit_CLA.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/CLA_258.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/CLA_258_top.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/CLS.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/CSA.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/FM_mod_mult_top.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/LUT.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/MUX.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/PISO_Nto1.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/mod_exp_fsm.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/mod_mult.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/r_shift.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/reg.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/reg_N.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator/hdl/rsa_core.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/edit_rsa_accelerator/edit_rsa_accelerator.srcs/sources_1/imports/hdl/rsa_exp.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator/hdl/rsa_regio.vhd
}
read_vhdl -vhdl2008 -library xil_defaultlib {
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator/hdl/rsa_msgin.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator/hdl/rsa_msgout.vhd
  /home/gabor7669/Desktop/TFE4141/tfe4141_term_project_integration_kit_v2/rsa_accelerator/hdl/rsa_accelerator.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top rsa_accelerator -part xc7z020clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef rsa_accelerator.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file rsa_accelerator_utilization_synth.rpt -pb rsa_accelerator_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]

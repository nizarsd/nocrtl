open_hw_target {localhost/xilinx_tcf/Digilent/210203355642A}
set_property PROGRAM.FILE {/home/nd706/work/graceful_basic/graceful_noc/graceful_noc.runs/impl_1/node_wrapper.bit} [lindex [get_hw_devices] 1]
set_property PROBES.FILE {/home/nd706/work/graceful_basic/graceful_noc/graceful_noc.runs/impl_1/debug_nets.ltx} [lindex [get_hw_devices] 1]
program_hw_devices [lindex [get_hw_devices] 1]
close_hw_target {localhost/xilinx_tcf/Digilent/210203355642A}

open_hw_target {localhost/xilinx_tcf/Digilent/210203823865A}
set_property PROGRAM.FILE {/home/nd706/work/graceful_basic/graceful_noc/graceful_noc.runs/impl_1/node_wrapper.bit} [lindex [get_hw_devices] 1]
set_property PROBES.FILE {/home/nd706/work/graceful_basic/graceful_noc/graceful_noc.runs/impl_1/debug_nets.ltx} [lindex [get_hw_devices] 1]
program_hw_devices [lindex [get_hw_devices] 1]
close_hw_target {localhost/xilinx_tcf/Digilent/210203823865A}


set PRJ_DIR [get_property DIRECTORY [current_project]]
puts $PRJ_DIR

set IMPL_DIR [get_property DIRECTORY [get_runs impl_1]]
puts $IMPL_DIR

set SCR_DIR [file dirname [info script]]
puts $SCR_DIR

cd ../localbin

#file copy -force $IMPL_DIR/design_1_wrapper.bit ./bitstream.bit
file copy -force $IMPL_DIR/design_${TARGET_DESIGN}_wrapper.bit ./bitstream.bit
set outfile [open "bitstream.bif" w]
puts $outfile "all:\n{\n\t[pwd]/bitstream.bit\n}"
close $outfile
exec bootgen -image bitstream.bif -arch zynq -process_bitstream bin

cd ../scripts




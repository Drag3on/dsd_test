onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -L xpm -L lib_pkg_v1_0_2 -L axi_apb_bridge_v3_0_17 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.axi_to_apb xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi_to_apb.udo}

run -all

quit -force

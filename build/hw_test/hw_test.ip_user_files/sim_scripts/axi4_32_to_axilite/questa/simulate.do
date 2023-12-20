onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib axi4_32_to_axilite_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {axi4_32_to_axilite.udo}

run 1000ns

quit -force
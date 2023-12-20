onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib sram_32x131072_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {sram_32x131072.udo}

run 1000ns

quit -force

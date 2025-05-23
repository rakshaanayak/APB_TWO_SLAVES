vlib work

vlog -sv +acc +cover +fcover -l apb_top. apb_top.sv

vsim -vopt work.apb_top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; coverage report -detail; exit"

vcover report -html coverage.ucdb -htmldir covReport -details





 TC = ;
target_link_speed = ;
SEED = `date "+%m%d%H%M%S"`


  vcs_opt =  -debug_pp -sverilog  -full64 -cm line+cond+fsm+tgl +error+100  -P /tools/eda/novas/Verdi3_I-2014.03-SP1/share/PLI/vcs/LINUX64/novas.tab \
             /tools/eda/novas/Verdi3_I-2014.03-SP1/share/PLI/vcs/LINUX64/pli.a +access+rwc   \
             +vcsd   +define+CPU_AHB32_SLAVE   +notimingchecks  -timescale=1ns/100ps \
		        -assert enable_diag  +vpi  -Marchive=100  +plusarg_save       -l ./vcs_elabrate.log \
             +nospecify  
###########################################################
#COMMANDS
###########################################################
all:cmp sim 


cmp:	
	vcs $(vcs_opt)  -debug_all -f ./list_fifo.f  +define+${TC} -o ./simv

sim:
	 ./simv  +ntb_random_seed=$(SEED) -cm line+cond+fsm+tgl -l ./sim_${TC}.log  +fsdbfile+./tc_${TC}.fsdb   -q \
  -assert nopostproc  -assert global_finish_maxfail=2000  -assert no_default_msg  +warn=noFCICIO 

verdi:
	verdi  -full64 +error+100  -P /tools/eda/novas/Verdi3_I-2014.03-SP1/share/PLI/vcs/LINUX64/novas.tab \
      /tools/eda/novas/Verdi3_I-2014.03-SP1/share/PLI/vcs/LINUX64/pli.a +access+rwc -timescale=1ns/100ps -sverilog \
      -top tb_fifo +vcsd +systemverilogext+.sv   +notimingchecks \
       -timescale=1ns/1ps \
		  -assert enable_diag  +vpi  -Marchive=100  +plusarg_save   \
		  -f ./list_fifo.f \
      -ssf ./tc_$(TC).fsdb   &
   
dve:
	dve -cov -full64 &


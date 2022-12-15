#include <Vtop.h>
#include <nvboard.h>
//#include "verilated.h"

static TOP_NAME dut;

void nvboard_bind_all_pins(Vtop* top);
void single_cycle() {
	dut.clk = 0; dut.eval();
	dut.clk = 1; dut.eval();
}
void reset(int n) {
	dut.reset = 0;
	while(n-- > 0) single_cycle();
	dut.reset = 1;
}

int main(int argc, char** argv, char** env) {
	nvboard_bind_all_pins(&dut);
	nvboard_init();
	//if (false && argc && argv && env) {}

	//Verilated::mkdir("logs");
	
	//const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
   	//const std::unique_ptr<Vtop> top{new Vtop{contextp.get(),"TOP"}};

	//contextp->traceEverOn(true);

	//int cnt = 0;
    //contextp->commandArgs(argc, argv);
//    while ((contextp->time() < 100) && (!contextp->gotFinish())) {
	reset(10);
	while(1) {
	//contextp->timeInc(1);
		/*if(dut.ready) {
			dut.nextdata_n = 0;
			nvboard_update();
			single_cycle();
			dut.nextdata_n = 1;
		}else {*/
			nvboard_update();
			single_cycle();
		//}
		//printf("a = %d, b = %d, f = %d\n", a, b, top->f);
		//assert(top->f == (a ^ b));
   	}

//#if VM_COVERAGE
//	Verilated::mkdir("logs");
//	contextp->coveragep()->write("logs/coverage.dat");
//#endif

    return 0;
}

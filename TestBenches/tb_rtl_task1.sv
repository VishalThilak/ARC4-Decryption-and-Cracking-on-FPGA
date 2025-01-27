`timescale 1ps / 1ps
module tb_rtl_task1();

// Your testbench goes here.
    logic CLOCK_50 = 0;
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [6:0] HEX0; 
    logic [6:0] HEX1;
    logic [6:0] HEX2;
    logic [6:0] HEX3; 
    logic [6:0] HEX4; 
    logic [6:0] HEX5;
    logic [9:0] LEDR;
    task1 dut(.*);

    always #5 CLOCK_50 = ~CLOCK_50;

    initial begin
        KEY[3] = 0;
        #10;
        
        dut.en = 1;
        KEY[3] = 1;
        #10;

        dut.en = 0;
        for(int i = 0; i <= 255; i++) begin
            #10;
            $display("Memory: %d",dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[i]);
            assert(dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[i] == i);
        end

        $stop;
    end

endmodule: tb_rtl_task1

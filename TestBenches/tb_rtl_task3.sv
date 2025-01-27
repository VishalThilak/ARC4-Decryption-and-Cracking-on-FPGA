`timescale 1ps / 1ps
module tb_rtl_task3();

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
    task3 dut(.*);

    always #5 CLOCK_50 = ~CLOCK_50; 
    
    initial begin
        
        KEY[3] = 0;
        #10;

        KEY[3] = 1;
        #10;


        #10;
        //init function
        for(int i = 0; i <= 53; i++) begin
            $display("Memory: %d",dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data[i]);
            assert(dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data[i] == i);
        end

        #10;


        //ksa function
        for(int i = 0; i <= 255; i++) begin
            wait (dut.a4.k.state == dut.a4.k.GEI);
            #20;
            assert(dut.a4.k.addr == dut.a4.k.i);
        end

        #10;
        //prga function
        for(int k = 1; k < 53; k++) begin
            wait (dut.a4.p.state == dut.a4.p.SETLEN);
            #10;
            assert(dut.a4.p.pt_wrdata == dut.a4.p.ct_rddata);
            $display("len: %d", dut.a4.p.message_length);

            wait (dut.a4.p.state == dut.a4.p.CALCPLAIN);
            #10;
            assert(dut.a4.p.pt_addr == dut.a4.p.k);
            $display("pt_value: %d", dut.a4.pt_wrdata);

            #20;
        end

        $finish("finished");
    end
endmodule: tb_rtl_task3

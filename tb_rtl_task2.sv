`timescale 1ps / 1ps
module tb_rtl_task2();

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
    task2 dut(.*);

    
    always #5 CLOCK_50 = ~CLOCK_50;


    initial begin
        KEY[3] = 0;
        #10;

        $display("state: %d", dut.state);
        $display("init_done; %d", dut.init_done);

        KEY[3] = 1;
        #10;

        #10;
        //fill up memory first usiing init function
        for(int i = 0; i <= 255; i++) begin
            $display("state: %d", dut.state);
            $display("wren: %d, addr %d, data: %d", dut.wren, dut.addr, dut.data);
            #10;
            $display("Memory: %d",dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[i]);
            assert(dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[i] == i);
        end

        #10;
        $display("state: %d", dut.state);
        $display("init_done; %d", dut.init_done);

        //verify ksa function 
        for(int i = 0; i <= 255; i++) begin
            wait (dut.k.state == dut.k.GETJ)
            #10;
            assert(dut.k.addr == dut.k.j);
            $display("temp_i: %d", dut.k.temp_i);
            $display("j: %d", dut.k.j);

            wait (dut.k.state == dut.k.WRITEI);
            #10;
            assert(dut.k.addr == dut.k.i);

            wait (dut.k.state == dut.k.WRITEJ);
            #10;
            assert(dut.k.wrdata == dut.k.temp_i);
            
            $display("wren: %d, addr %d, data: %d", dut.wren, dut.addr, dut.data);  
            $display("Memory written at i: %d",dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[dut.k.j]);
            
            $display("wren: %d, addr %d, data: %d", dut.wren, dut.addr, dut.data);  
            $display("Memory written at j: %d",dut.s.altsyncram_component.m_default.altsyncram_inst.mem_data[dut.k.i]);
            #20;
        end

   
        $finish;
    end
endmodule: tb_rtl_task2

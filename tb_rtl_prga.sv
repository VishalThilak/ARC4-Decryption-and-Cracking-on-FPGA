`timescale 1ps / 1ps
module tb_rtl_prga();

// Your testbench goes here.
    logic clk, rst_n;
    logic en, rdy;
    logic [23:0] key;
    logic [7:0] s_addr, s_rddata, s_wrdata;
    logic s_wren;
    logic [7:0] ct_addr, ct_rddata;
    logic [7:0] pt_addr, pt_rddata, pt_wrdata;
    logic pt_wren;
    
    prga dut(.*);

    always #5 clk = ~clk; 

    initial begin
        rst_n = 0;
        #10;

        assert(dut.state == dut.IDLE);

        rst_n = 1;
        #10;
        
        en = 1;
        #10;

        assert(dut.next_state == dut.MESSLEN);
        #20;

        

        wait(dut.state == dut.CALCI);
        #10;

        assert(dut.i == 1);

        wait(dut.state == dut.CALCJ);
        #10;

        assert(dut.temp_i == dut.s_rddata);
        assert(dut.j == 1);

        wait(dut.state == dut.WRITEI);
        #10;
        assert(dut.temp_j == dut.s_rddata);
        

        wait(dut.rdy == 1);
        #10;

        $stop;
    end
endmodule: tb_rtl_prga

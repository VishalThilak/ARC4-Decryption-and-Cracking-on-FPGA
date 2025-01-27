`define BLANK 7'b1111111 
`define ZERO 7'b1000000
`define ONE 7'b1111001 
`define TWO 7'b0100100
`define THREE 7'b0110000
`define FOUR 7'b0011001
`define FIVE 7'b0010010
`define SIX 7'b0000010
`define SEVEN 7'b1111000
`define EIGHT 7'b0000000
`define NINE 7'b0010000
`define A 7'b0001000
`define B 7'b0000011
`define C 7'b1000110
`define D 7'b0100001
`define E 7'b0000110
`define F 7'b0001110
`define DEBUG 7'b0111111

`timescale 1ps / 1ps
module tb_rtl_task5();

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
    task5 dut(.*);

    logic clk, rst_n, key_valid, pt_wren;
    logic [23:0] key_in;
    logic [7:0] ct_addr, ct_rddata, message_length, pt_addr, pt_wrdata, index, ml_c1, ml_c2;
    logic [3:0] state_crack;
    logic key_valid_c1;
    logic key_valid_dc;
    logic [3:0] state_dc;
    assign key_valid_dc = dut.dc.key_valid;
    assign ml_c1 = dut.dc.message_length_c1;
    assign ml_c2 = dut.dc.message_length_c2;
    assign state_dc = dut.dc.state;
    assign index  = dut.dc.index;
    assign key_valid_c1 = dut.dc.key_valid_c1;
    assign state_crack = dut.dc.c1.state;
    assign key_valid = dut.dc.c1.key_valid;
    assign key_in = dut.dc.c1.key_in;
    assign ct_addr = dut.dc.c1.ct_addr;
    assign ct_rddata = dut.dc.c1.ct_rddata;
    assign message_length = dut.dc.c1.message_length;
    assign pt_addr = dut.dc.c1.pt_addr;
    assign pt_wrdata = dut.dc.c1.pt_wrdata;
    assign pt_wren = dut.dc.c1.pt_wren;


    always #5 CLOCK_50 = ~CLOCK_50;

    initial begin
        KEY[3] = 0;
        #10;
        
        assert(dut.state == dut.ENABLE);
        KEY[3] = 1;
        #10;

        assert(dut.state == dut.OFF);
        #10;

        assert(dut.dc.state == dut.dc.IDLE);
        
        assert(dut.dc.pt_addr_c1 == 0);
        
        assert(dut.dc.pt_addr_c2 == 0);
        #10;
        
        wait(dut.dc.state == dut.dc.START);
        #10;
        
        assert(dut.dc.key_valid_c1 == 1);
        
        assert(dut.dc.key_valid_c2 == 0);
        #10;

        wait(dut.dc.state == dut.dc.WRITE);
        assert(dut.dc.pt_wrdata == dut.dc.pt_rddata_c1);
        
        assert(dut.dc.pt_addr == 0);
        
        assert(dut.dc.pt_wren == 1);
        #10;
        
        wait(dut.dc.rdy == 1);
        #10;

        assert(dut.key == 24'h000018);
        
        assert(HEX5 == 7'b1000000);
        
        assert(HEX4 == 7'b1000000);
        
        assert(HEX3 == 7'b1000000);
        
        assert(HEX2 == 7'b1000000);
        
        assert(HEX1 == 7'b1111001);
        
        assert(HEX0 == 7'b0000000);

        $finish("finished");
    end


endmodule: tb_rtl_task5

`timescale 1ps / 1ps
module tb_rtl_task4();

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
    task4 dut(.*);

    logic [7:0] pt_rddata;
    logic [7:0] pt_wrdata;
    // logic [7:0] count;
    logic [7:0] pt_addr;
    logic pt_wren;
    logic rdy_arc4;
    logic en_arc4;
    logic key_flag;
    logic [23:0] key_in;
    logic [2:0] state;
    logic [7:0] message_length;
    logic key_valid;
    logic rst_n_arc4;
    assign rst_n_arc4 = dut.c.rst_n_arc4;
    assign key_valid = dut.c.key_valid;
    assign message_length = dut.c.message_length;
    assign state = dut.c.state;
    assign key_in  = dut.c.key_in;
    assign key_flag = dut.c.key_flag;
    assign en_arc4 = dut.c.en_arc4;
    assign rdy_arc4 = dut.c.rdy_arc4;
    assign pt_wren = dut.c.pt_wren;
    assign pt_wrdata = dut.c.pt_wrdata;
    assign pt_addr = dut.c.pt_addr;
    assign pt_rddata = dut.c.pt_rddata;
    // assign count = dut.c.count;


    always #5 CLOCK_50 = ~CLOCK_50;

    initial begin
        KEY[3] = 0;
        #10;

        assert(dut.state == dut.ENABLE);

        KEY[3] = 1;
        #10;

        assert(dut.state == dut.OFF);

        wait(dut.c.state == dut.c.IDLE);
        #10;
        assert(en_arc4 == 1);
        
        wait(dut.c.state == dut.c.READLEN);
        #10;
        assert(message_length == pt_wrdata);

        wait(dut.c.state == dut.c.ARC4);

        wait(dut.c.state == dut.c.VALID_KEY);
        #10;
        assert(key_valid == 0);

        wait(dut.c.state == dut.c.DONE);
        #10;
        assert(dut.c.rdy == 0);

        // wait(dut.c.state == dut.c.ARC4);
        #10;

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



endmodule: tb_rtl_task4

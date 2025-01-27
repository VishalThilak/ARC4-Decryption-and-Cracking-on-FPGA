`timescale 1ps / 1ps
module tb_rtl_arc4();

// Your testbench goes here.
    logic clk = 0;
    logic rst_n;
    logic en, rdy;
    logic [23:0] key;
    logic [7:0] ct_addr, ct_rddata;
    logic [7:0] pt_addr, pt_rddata, pt_wrdata;
    logic pt_wren;

    arc4 dut(.*);

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        en = 0;
        key = 24'h000018;

        #10;
        rst_n = 1;
        en = 1;

        wait (rdy == 1);
        #10;

        if(dut.p.rdy_prga) begin
            $display("Sucessfully finished");
        end else begin
            $display("Did not finish");
        end

        //check memory contents

        $stop;

    end
endmodule: tb_rtl_arc4


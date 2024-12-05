module tb_syn_prga();

// Your testbench goes here.
    logic clk, logic rst_n;
    logic en, logic rdy;
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

        assert(dut.state == IDLE);

        rst_n = 1;
        #10;

        assert(dut.state == MESSLEN);
        #10;

        assert(dut.message_length == dut.ct_rddata);

        #10;




        $stop;

    end


endmodule: tb_syn_prga

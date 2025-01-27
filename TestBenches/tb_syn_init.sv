module tb_syn_init();

// Your testbench goes here.
     logic clk = 0;
    logic rst_n, en, rdy;
    logic [7:0] addr, wrdata;
    logic wren;

    init dut(.*);

    always #5 clk = ~clk;

    initial begin
        rst_n = 0;
        #10;
        assert(dut.state == dut.IDLE);
        
        en = 1;
        rst_n = 1;
        #10;
        $display(dut.state == dut.WRITE);

        en = 0;
    
        for(int i = 0; i < 255; i++) begin
            #10;
            $display("Addr: %d, Wrdata: %d, wren :%d", addr, wrdata, wren);
        end

        $stop;

    end
endmodule: tb_syn_init

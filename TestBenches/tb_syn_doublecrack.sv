`timescale 1ps / 1ps
module tb_syn_doublecrack();

// Your testbench goes here.

logic clk = 0;
logic rst_n;
logic en; 
logic rdy;
logic [23:0] key;
logic key_valid;
logic [7:0] ct_addr;
logic [7:0] ct_rddata;

doublecrack dut (.*);

always #5 clk = ~clk;

initial begin
    rst_n = 0;
    #10;
    
    assert(dut.state == dut.IDLE);
    
    assert(dut.pt_wren == 0);
    
    assert(dut.pt_addr == 0);
    
    assert(dut.pt_addr_c1 == 0);
    
    assert(dut.pt_addr_c2 == 0);
    rst_n = 1;
    #10;
    
    wait(dut.state == dut.START);
    #10;

    assert(dut.key_valid_c1 == 1);
    
    assert(dut.pt_addr_c1 == 0);
    
    assert(dut.pt_addr_c2 == 0);
    #10;
    
    wait(dut.state == dut.WRITE);
    #10;
    
    assert(dut.pt_wrdata == dut.pt_rddata_c1);
    
    assert(dut.message_length_c1 == 24'h35);
    
    assert(dut.message_length_c1 == dut.message_length_c2);
    #10;
    
    $finish("finished");

end

endmodule: tb_syn_doublecrack

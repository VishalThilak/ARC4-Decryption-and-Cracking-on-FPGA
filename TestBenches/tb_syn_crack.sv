`timescale 1ps / 1ps
module tb_syn_crack();

// Your testbench goes here.

logic clk = 0;
logic rst_n;
logic en; 
logic rdy;
logic [23:0] key;
logic key_valid;
logic [7:0] ct_addr;
logic [7:0] ct_rddata; 
logic c1;  
logic [7:0] message_length;
logic [7:0] pt_addr_dc;
logic [7:0] pt_rddata;

crack dut(.*);

always #5 clk = ~clk;

initial begin
    rst_n = 0;
    #10;
    
    assert(dut.state == dut.IDLE);
    #10;
    rst_n = 1;
    #10;
    
    wait(dut.state == dut.READLEN);
    #10;
    
    assert(dut.message_length == 24'h35);
    #10;
    
    wait(dut.state == dut.ARC4);
    #10;
    
    assert(dut.pt_wren == 1);
    assert(dut.pt_addr != message_length);
    #10;
    
    wait(dut.state == dut.VALID_KEY);
    #10;
    
    assert(dut.key_valid == 0);
    assert(dut.key_in == 2);
    wait(dut.state == dut.DONE);
    #10;
    
    assert(dut.key == 24'h000018);
    assert(dut.key_valid == 1);
    assert(dut.rdy == 1);
    #10;

    $finish("finished");
end

endmodule: tb_syn_crack

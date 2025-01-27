module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic [7:0] addr;
    logic [7:0] data;
    logic en, rdy;
    logic [7:0] q;
    logic wren;

    s_mem s(.address(addr), .clock(CLOCK_50), .data(data), .wren(wren), .q(q));

    init in(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(rdy), .addr(addr), .wrdata(data), .wren(wren));

    // your code here
endmodule: task1

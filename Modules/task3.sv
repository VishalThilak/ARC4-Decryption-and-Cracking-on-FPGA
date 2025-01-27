module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic en, rdy, pt_wren, ct_wren;
    logic [23:0] key;
    logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata, data_ct;
    enum {IDLE, ENABLE, OFF} state;

    assign key = 24'h000018;
    assign ct_wren = 0;

    ct_mem ct(.address(ct_addr), .clock(CLOCK_50), .data(data_ct), .wren(ct_wren), .q(ct_rddata));
    pt_mem pt(.address(pt_addr), .clock(CLOCK_50), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));
    arc4 a4(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(rdy), .key(key), .ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here
    // Sequential block to assert the enable and update the execution state 
    // on every positive rising edge of the clock    
    always_ff@(posedge CLOCK_50) begin 
        if(~KEY[3]) begin
            en <= 0;
            state <= ENABLE;
        end else begin
            if(state == ENABLE) begin
                en <= 1;
                state <= OFF;
            end
        end
    end
endmodule: task3
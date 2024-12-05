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
module task5(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic en, rdy, ct_wren;
    logic [23:0] key;
    logic key_valid;

    logic [7:0] ct_addr, ct_rddata, data_ct;
    logic [3:0] hex_seg_0, hex_seg_1, hex_seg_2, hex_seg_3, hex_seg_4, hex_seg_5;
    enum {IDLE, ENABLE, OFF} state;

    assign ct_wren = 0;
    assign hex_seg_0 = key[3:0];
    assign hex_seg_1 = key[7:4];
    assign hex_seg_2 = key[11:8];
    assign hex_seg_3 = key[15:12];
    assign hex_seg_4 = key[19:16];
    assign hex_seg_5 = key[23:20];

    ct_mem ct(.address(ct_addr), .clock(CLOCK_50), .data(data_ct), .wren(ct_wren), .q(ct_rddata));
    doublecrack dc(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(rdy), .key(key), .key_valid(key_valid), .ct_addr(ct_addr), .ct_rddata(ct_rddata));

    

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

    drawseg hex0(.key_valid(key_valid), .val(hex_seg_0), .seg(HEX0));
    drawseg hex1(.key_valid(key_valid), .val(hex_seg_1), .seg(HEX1));
    drawseg hex2(.key_valid(key_valid), .val(hex_seg_2), .seg(HEX2));
    drawseg hex3(.key_valid(key_valid), .val(hex_seg_3), .seg(HEX3));
    drawseg hex4(.key_valid(key_valid), .val(hex_seg_4), .seg(HEX4));
    drawseg hex5(.key_valid(key_valid), .val(hex_seg_5), .seg(HEX5));

endmodule: task5

module drawseg(input logic key_valid, input logic [3:0] val, output logic [6:0] seg);


// Combinational block to update the 7-segment display based on the hexadecimal value of
// the input 4 bit value of key, otherwise blank while computation
always_comb begin
    if(key_valid) begin
        case(val)
        4'b0000: seg = `ZERO;
        4'b0001: seg = `ONE;
        4'b0010: seg = `TWO;
        4'b0011: seg = `THREE;
        4'b0100: seg = `FOUR;
        4'b0101: seg = `FIVE;
        4'b0110: seg = `SIX;
        4'b0111: seg = `SEVEN;
        4'b1000: seg = `EIGHT;
        4'b1001: seg = `NINE;
        4'b1010: seg = `A;
        4'b1011: seg = `B;
        4'b1100: seg = `C;
        4'b1101: seg = `D;
        4'b1110: seg = `E;
        4'b1111: seg = `F;
        default: seg = `DEBUG;
        endcase
    end
    else begin
        seg = `BLANK;
    end
end
endmodule: drawseg

module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata, input logic c1, output logic [7:0] message_length, 
             input logic [7:0] pt_addr_dc, output logic [7:0] pt_rddata
         /* any other ports you need to add */);

    // For Task 5, you may modify the crack port list above,
    // but ONLY by adding new ports. All predefined ports must be identical.

    // your code here

    // this memory must have the length-prefixed plaintext if key_valid
    // your code here
    logic [7:0] pt_addr, pt_wrdata, pt_addr_mem, pt_wrdata_mem;
    logic pt_wren, en_arc4, rdy_arc4;
    logic [23:0] key_in;
    logic key_flag;
    logic rst_n_arc4, pt_wren_mem;

    enum {IDLE, READLEN, ARC4, VALID_KEY, DONE} state; 

    // Combinational always block to keep track of when arc4 should be reset once
    // a key is deemed invalid
    always_comb begin
        if(state == VALID_KEY) rst_n_arc4 = 0;
        else rst_n_arc4 = rst_n; 
    end

    // Sequential block to iterate through keys in increments of 2 to find if the decrypted ciphertext is valid
    // and ensuring that the correct data is being written to PT.
    always_ff@(posedge clk) begin
        if(!rst_n) begin
            en_arc4 <= 0;
            state <= IDLE;
            key_in <= c1 ? 0 : 1;
            key_valid <= 0;
            message_length <= 0;
        end
        else begin
        case(state)
            IDLE: begin
                if(en) begin
                    en_arc4 <= 1;
                    state <= READLEN;
                    
                    key_flag <= 1;
                    rdy <= 0;
                end
                else begin
                    rdy <= 1;
                end
            end
            READLEN: begin
                if(pt_wren) begin
                message_length <= pt_wrdata;
                // state <= ARC4;
                // key_flag <= 1;
                state <= ARC4;
                end
            end
            ARC4: begin
                if(rdy_arc4) begin
                    en_arc4 <= 0;
                    state <= VALID_KEY;
                end
                else begin
                    if(pt_wren) begin
                        if(pt_addr == message_length) begin
                            en_arc4 <= 0;
                            state <= VALID_KEY;
                        end
                        else begin
                            state <= ARC4;
                        end
                        if(pt_wrdata < 24'h20 || pt_wrdata > 24'h7E) begin
                            key_flag <= 0;
                            state <= VALID_KEY;
                        end
                    end
                end
            end
            VALID_KEY: begin
                if(key_flag) begin
                    key_valid <= 1;
                    key <= key_in;
                    state <= DONE;
                end
                else begin
                    key_in <= key_in + 2;
                    state <= IDLE;
                end 
            end
            DONE: begin
                rdy <= 1;
            end
        endcase
        end
    end

    // Combinational always block to verify if we are writing to PT or reading from PT once a key is valid
    always_comb begin
        if(!key_valid) begin
            pt_addr_mem = pt_addr;
            pt_wren_mem = pt_wren;
        end else begin
            pt_addr_mem = pt_addr_dc;
            pt_wren_mem = 0;
        end
    end

    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(.address(pt_addr_mem), .clock(clk), .data(pt_wrdata), .wren(pt_wren_mem), .q(pt_rddata));
    arc4 a4(.clk(clk), .rst_n(rst_n_arc4), .en(en_arc4), .rdy(rdy_arc4), .key(key_in), .ct_addr(ct_addr),
            .ct_rddata(ct_rddata), .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here
endmodule: crack


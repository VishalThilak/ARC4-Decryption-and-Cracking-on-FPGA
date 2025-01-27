module doublecrack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here
    logic [7:0] pt_addr_c1, pt_rddata_c1, pt_addr_c2, pt_rddata_c2, pt_addr, pt_wrdata, pt_rddata, index, message_length_c1, message_length_c2, data_ct,
                ct_addr_c2, ct_rddata_c2;
    logic is_c1, key_valid_c1, key_valid_c2, pt_wren, rdy_c1, rdy_c2;
    logic [23:0] key_c1, key_c2;
    assign ct_wren = 0;
    assign is_c1 = 1;
    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt(.address(pt_addr), .clock(clk), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

    // for this task only, you may ADD ports to crack
    crack c1(.message_length(message_length_c1), .pt_addr_dc(pt_addr_c1), .pt_rddata(pt_rddata_c1), .clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy_c1), .key(key_c1), .key_valid(key_valid_c1), .ct_addr(ct_addr), .ct_rddata(ct_rddata), .c1(is_c1));
    crack c2(.message_length(message_length_c2), .pt_addr_dc(pt_addr_c2), .pt_rddata(pt_rddata_c2), .clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy_c2), .key(key_c2), .key_valid(key_valid_c2), .ct_addr(ct_addr_c2), .ct_rddata(ct_rddata_c2), .c1(~is_c1)); ct_mem ct2(.address(ct_addr_c2), .clock(clk), .data(data_ct), .wren(ct_wren), .q(ct_rddata_c2));
    enum {IDLE, START, WRITE} state;


    // Sequential block in charge of keeping track of the states to read from the correct PT once 
    // a valid key is found, ensuring that index is incremented appropriately to write to the correct pt_addr
    // and read from the correct PT within c1 or c2
    always_ff @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            state <= IDLE;
            index <= 0;
            key_valid <= 0;
        end else begin
            case(state)
                IDLE: begin
                    if(en) begin
                        if(key_valid_c1 || key_valid_c2) begin
                            key_valid <= 1;
                            state <= START;
                        end
                    end
                end
                START: begin
                    if(key_valid_c1) begin
                        key <= key_c1;

                    end else begin
                        key <= key_c2;
                    end
                    state <= WRITE;
                end
                WRITE: begin
                    if(index == message_length_c1) begin
                        state <= IDLE;
                    end else begin
                        index <= index + 1;
                        state <= START;
                    end
                end
            endcase
        end
    end

    // Combinational always block to write the correct values for PT and ensure that the correct values
    // are read from c1 or c2's PT
    always_comb begin

            case(state) 

                IDLE: begin
                    if(en) begin
                        rdy = 0;
                    end else begin
                        rdy = 1;
                    end

                    pt_wren = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_addr_c1 = 0;
                    pt_addr_c2 = 0;
                end 
                
                START: begin
                    if(key_valid_c1) begin
                        pt_addr_c1 = index;
                        pt_addr_c2 = 0;
                    end else begin
                        pt_addr_c2 = index;
                        pt_addr_c1 = 0;
                    end
                    rdy = 0;
                    pt_wren = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                end

                WRITE: begin
                    if(key_valid_c1) begin
                        pt_wrdata = pt_rddata_c1;
                    end else begin
                        pt_wrdata = pt_rddata_c2;
                    end

                    pt_addr = index;     
                    pt_wren = 1;
                    pt_addr_c1 = 0;
                    pt_addr_c2 = 0;

                    if(index == message_length_c1) begin
                        rdy = 1;
                    end else begin
                        rdy = 0;
                    end
                end
                default: begin
                    rdy = 0;
                    pt_wren = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_addr_c1 = 0;
                    pt_addr_c2 = 0;

                end
            endcase
            

    end
    // your code here

endmodule: doublecrack
module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here

    logic [7:0] addr;
    logic [7:0] data;
    logic en_init, en_ksa, rdy_init, rdy_prga, en_prga;
    logic [7:0] q;
    logic wren;
    logic rdy_ksa;
    logic init_done;
    logic rst;
                     
    logic wren_init, wren_ksa, wren_prga;
    logic [7:0] addr_init, addr_ksa, addr_prga;
    logic [7:0] data_init, data_ksa, data_prga;

    enum {IDLE, INIT, KSA, PRGA, DONE} state;

    //driving fsm
    always_ff@(posedge clk) begin
        if(!rst_n) begin
            en_ksa <= 0;
            en_prga <= 0;
            state <= IDLE;
        end
        else begin
        case(state)
            IDLE: begin
                if(en) begin
                    en_init <= 1;
                    state <= INIT;
                    rdy <= 0;
                end else begin
                    rdy <= 1;
                end
            end 
            
            INIT: begin
                if(rdy_init) begin
                    en_init <= 0;
                    en_ksa <= 1;
                    state <= KSA;
                end
            end

            KSA: begin
                if(rdy_ksa) begin
                    en_ksa <= 0;
                    en_prga <= 1;
                    state <= PRGA;
                end
            end

            PRGA: begin
                if(rdy_prga) begin
                    en_prga <= 0;
                    state <= DONE;
                end
            end

            DONE: begin
                rdy <= 1;
                state <= IDLE;
            end

        endcase
        end
    end

    //determining signals
    always_comb begin
        case(state) 
            IDLE, INIT: begin
                addr = addr_init;
                data = data_init;
                wren = wren_init;
            end

            KSA: begin
                addr = addr_ksa;
                data = data_ksa;
                wren = wren_ksa;                
            end

            PRGA: begin
                addr = addr_prga;
                data = data_prga;
                wren = wren_prga;    
            end

            default: begin
                addr = addr_prga;
                data = data_prga;
                wren = wren_prga;                        
            end
        endcase
    end

    s_mem s(.address(addr), .clock(clk), .data(data), .wren(wren), .q(q));
    init i(.clk(clk), .rst_n(rst_n), .en(en_init), .rdy(rdy_init), .addr(addr_init), .wrdata(data_init), .wren(wren_init));
    ksa k(.clk(clk), .rst_n(rst_n), .en(en_ksa), .rdy(rdy_ksa), .key(key), .addr(addr_ksa), .rddata(q), .wrdata(data_ksa), .wren(wren_ksa));
    prga p(.clk(clk), .rst_n(rst_n), .en(en_prga), .rdy(rdy_prga), .key(key), .s_addr(addr_prga), .s_rddata(q), .s_wrdata(data_prga), .s_wren(wren_prga), 
            .ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));


    // your code here

endmodule: arc4

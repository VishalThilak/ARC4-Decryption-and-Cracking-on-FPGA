module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic [7:0] addr;
    logic [7:0] data;
    logic en_init, en_ksa, rdy_init;
    logic [7:0] q;
    logic wren;
    logic rdy_ksa;
    logic init_done;
    logic rst;
    logic [23:0] key;

    assign key = 24'h00033C; //{14'd0, SW[9:0]};
                     
    logic wren_init, wren_ksa;
    logic [7:0] addr_init, addr_ksa;
    logic [7:0] data_init, data_ksa;

    enum {IDLE, WAIT, CALCI, WAIT2, KSA, DONE} state;

    // Sequential block to keep track of thr order of execution for the init and ksa modules,
    // ensuring init is fully executed before ksa starts.
    always_ff@(posedge CLOCK_50) begin   // Start ksa when init is done
        if(~KEY[3]) begin
            en_ksa <= 0;
            state <= IDLE;
        end
        else begin
            case(state)
            IDLE: begin
                if(rdy_init) begin
                    en_init <= 1;
                    state <= CALCI;
                end
            end

            WAIT: begin
                state <= CALCI;
            end

            CALCI: begin
                if(rdy_init) begin
                    en_init <= 0;
                    state <= WAIT2;
                end
            end

            WAIT2: begin
                state <= KSA;
            end

            KSA: begin
                if(rdy_ksa) begin
                    en_ksa <= 1;
                    state <= DONE;
                end
            end

            endcase
        end
    end
    
    // Combinational always block to to assign the appropriate addr, data, and wren values when writing and reading
    // from s_mem
    always_comb begin
       case(state)
            IDLE: begin
                addr = addr_init;
                data = data_init;
                wren = wren_init;
            end
            WAIT: begin
                addr = addr_init;
                data = data_init;
                wren = wren_init;
            end

            CALCI: begin
                addr = addr_init;
                data = data_init;
                wren = wren_init;
            end

            WAIT2: begin
                addr = addr_init;
                data = data_init;
                wren = wren_init;
            end

            default: begin              
                addr = addr_ksa;
                data = data_ksa;
                wren = wren_ksa; 
            end
       endcase   
    end

    // s_mem s( /* connect ports */ );
    s_mem s(.address(addr), .clock(CLOCK_50), .data(data), .wren(wren), .q(q));

    init in(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en_init), .rdy(rdy_init), .addr(addr_init), .wrdata(data_init), .wren(wren_init));

    ksa k(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en_ksa), .rdy(rdy_ksa), .key(key), .addr(addr_ksa), .rddata(q), .wrdata(data_ksa), .wren(wren_ksa));

    // your code here

endmodule: task2
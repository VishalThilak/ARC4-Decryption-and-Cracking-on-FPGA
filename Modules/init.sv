module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here


    // Internal signal to track the current state index (0 to 255)
    logic [7:0] count;

    // State Machine to control the ready/enable microprotocol
    typedef enum logic [1:0] {
        IDLE,        // Ready to accept requests
        WRITE     // Writing the current value to memory
    } state_t;

    state_t state, next_state;


    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 8'd0;
        end else begin
            state <= next_state;
            if (state == WRITE) begin
                count <= count + 1; 
            end
        end
    end

    always_comb begin
        
        next_state = state; 

        case (state)
            IDLE: begin
                wren = 1'b0;
                addr = 8'b0;
                wrdata = 8'b0;
                if (en) begin
                    next_state = WRITE;  
                    rdy = 1'b0;
                end else begin
                    rdy = 1'b1;
                end
            end

            WRITE: begin
                rdy = 1'b0;
                addr = count;       
                wrdata = count;     
                wren = 1'b1;       
                if (count == 8'd255) begin
                    next_state = IDLE; 
                    rdy = 1'b1;
                end 
            end

            default: begin
                rdy = 1'bx;
                wren = 1'b0;
                addr = 8'b0;
                wrdata = 8'b0;
            end
        endcase
    end

endmodule: init
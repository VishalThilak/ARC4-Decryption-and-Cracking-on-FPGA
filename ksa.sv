module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

    // your code here
    logic [7:0] i;
    logic [7:0] j;
    logic [7:0] temp_i, temp_j;


    // State Machine to control the ready/enable microprotocol
    typedef enum logic [2:0] {
        IDLE, 
        GETI,    
        CALCJ,      
        GETJ,
        WRITEI,
        WRITEJ
    } state_t;

    state_t state, next_state;

    //driving the fsm
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            i <= 8'd0;
            j <= 0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin 
                    temp_i <= 0;
                    temp_j <= 0;
                end
                
                CALCJ: begin
                    temp_i <= rddata;
                    if(i % 3 == 0) begin
                        j <= (j + rddata + key[23:16]) % 256;
                    end else if(i % 3 == 1) begin
                        j <= (j + rddata + key[15:8]) % 256;
                    end else begin
                        j <= (j + rddata + key[7:0]) % 256;
                    end
                end

                WRITEJ: begin
                    i <= i + 1; 
                end

            endcase

        end
    end

    //setting signals here
    always_comb begin
        
        next_state = state;

        case (state)
            IDLE: begin
                wrdata = 0;
                wren = 0;
                addr = 0;
                
                if (en) begin
                    next_state = GETI;  
                    rdy = 0;
                end else begin
                    rdy = 1;
                end
            end

            GETI: begin
                rdy = 0;
                addr = i;
                wrdata = 0;
                wren = 0;

                next_state = CALCJ;
            end

            CALCJ: begin
                rdy = 0;
                addr = 0;
                wren = 0;
                wrdata = 0;

                next_state = GETJ;
            end 

            GETJ: begin
                rdy = 0;
                addr = j;
                wren = 0;
                wrdata = 0;

                next_state = WRITEI;
            end

            WRITEI: begin
                rdy = 0;
                addr = i;
                wrdata = rddata;
                wren = 1;

                next_state = WRITEJ;
            end
            
            WRITEJ: begin
                addr = j;
                wrdata = temp_i;
                wren = 1;

                if (i == 8'd255) begin
                    next_state = IDLE; 
                    rdy = 1;
                end else begin
                    rdy = 0;
                    next_state = GETI;
                end

            end

            default: begin
                rdy = 0;
                wren = 0;  
                addr = 0;
                wrdata = 0;
            end
        endcase
    end

endmodule: ksa

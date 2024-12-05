module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
        logic [7:0] i, j, k, ciphertext, message_length, temp_i, temp_j;

        typedef enum logic [3:0] {
            IDLE,
            MESSLEN,
            CALCI,
            GETI,
            CALCJ,
            GETJ,
            WRITEI,
            WRITEJ,
            GETIJ,
            CALCPLAIN   
        } state_t;

        state_t state, next_state;

        //driving the fsm
        always_ff @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                state <= IDLE;
            end else begin
                state <= next_state;
                case(state)
                    IDLE: begin
                        i <= 0;
                        j <= 0;
                        k <= 1;
                    end

                    MESSLEN: begin
                         message_length <= ct_rddata;
                    end

                    CALCI: begin
                        i <= (i + 1) % 256;
                    end

                    CALCJ: begin
                        temp_i <= s_rddata;
                        j <= (j + s_rddata) % 256;
                    end

                    WRITEI: begin
                        temp_j <= s_rddata;
                    end
                    CALCPLAIN: begin
                        k <= k + 1;
                    end

                endcase
            end
        end

        //determine signals for each state
        always_comb begin
            next_state = state;

            case(state)
                IDLE: begin
                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                    
                    if(en) begin
                        next_state = MESSLEN;
                        rdy = 0;
                    end else begin
                        rdy = 1;
                    end
                end

                MESSLEN: begin
                    next_state = CALCI;
                    
                    rdy = 0;
                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = ct_rddata;
                    pt_wren = 1;
                end


                CALCI: begin
                    rdy = 0;
                    next_state = GETI;

                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                GETI: begin
                    rdy = 0;
                    s_addr = i;
                    next_state = CALCJ;

                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                CALCJ: begin
                    rdy = 0;
                    next_state = GETJ;

                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                GETJ: begin
                    rdy = 0;
                    s_addr = j;
                    s_wrdata = 0;
                    s_wren = 0;

                    next_state = WRITEI;

                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                WRITEI: begin
                    rdy = 0;
                    s_addr = i;
                    
                    s_wrdata = s_rddata;
                    s_wren = 1;
                    next_state = WRITEJ;

                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                WRITEJ: begin
                    rdy = 0;
                    s_addr = j;
                    s_wrdata = temp_i;
                    s_wren = 1;
                    next_state = GETIJ;

                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

                GETIJ: begin
                    rdy = 0;
                    s_addr = (temp_i + temp_j) % 256;
                    next_state = CALCPLAIN;

                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = k;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end


                CALCPLAIN: begin
                    pt_addr = k;
                    pt_wrdata = s_rddata ^ ct_rddata;
                    pt_wren = 1;

                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0; 
                    ct_addr = 0;

                    if (k == message_length) begin
                        next_state = IDLE; 
                        rdy = 1;
                    end else begin
                        rdy = 0;
                        next_state = CALCI;
                    end
                end


                default: begin
                    rdy = 0;
                    s_addr = 0;
                    s_wrdata = 0;
                    s_wren = 0;
                    ct_addr = 0;
                    pt_addr = 0;
                    pt_wrdata = 0;
                    pt_wren = 0;
                end

            endcase

        end


endmodule: prga

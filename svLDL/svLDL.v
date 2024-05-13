module main(
            input clk,
            input rst_off,
            input rst_on,
            output wire [3:0] digit,
            output wire [7:0] led,
            output wire [7:0] seg
           );

    reg [7:0] op;
    wire  clk_div;

    clk_div #(.MAX(23)) clk_n (.clk(clk), .clk_div(clk_div));

    digits d(.clk(clk), .data(led), .digit(digit), .seg(seg));

    assign op = led;

    initial begin 
        op <= 8'b00000001;
    end

    always @(posedge clk_div) begin
        if (!rst_off) begin 
            op[7:0] <= 8'b00000000;
        end else if(!rst_on) begin
            op[7:0] <= 8'b11111111;
        end else begin
            op[7:0] <= {((op[4]^op[3]^op[2]^op[0])^(~|op[7:1])), op[7:1]};
        end 
    end

endmodule

module clk_div #(
                 parameter MAX = 1
                )(
                 input  clk,
                 output clk_div
                );
    reg [MAX:0] ctr;

    assign clk_div = ctr[MAX];
    
    always @(posedge clk) begin
        if(ctr[MAX]) begin 
            ctr <= 0;
        end else begin
            ctr <= ctr + 'd1;
        end
    end
endmodule

module digits(
              input clk, 
              input  wire [7:0] data,
              output wire [0:3] digit,
              output wire [7:0] seg
             );

    reg [1:0] i = 0;
    reg [3:0] out;

    wire  clk_div;

    clk_div #(.MAX(11)) clk_n (.clk(clk), .clk_div(clk_div));

    assign digit = 4'b1 << i;

    always @(posedge clk_div) begin 
        i = i + 2'b1;
        case(digit)
            4'b0001:
                out = data[3:0];
            4'b0010:
                out = data[7:4];
            4'b0100:
                out = 4'b0;
            4'b1000:
                out = 4'b0;
            default:
                out = 4'b0;
        endcase
    end

    segment7 s(.clk(clk), .data(out), .seg(seg));
endmodule

module segment7(
                input clk,
                input wire[3:0] data,
                output wire [7:0] seg
               );
    
    reg [7:0] op;
    
    assign seg = op;

    always @(posedge clk) begin
        case (data)
            4'b0000:
                op = 8'b00111111;  //a,b,c,d,e,f,g,dot (zero)
            4'b0001:
                op = 8'b00000110;  //one
            4'b0010:
                op = 8'b01011011;  //two
            4'b0011:
                op = 8'b01001111;  //three
            4'b0100:
                op = 8'b01100110;  //four
            4'b0101:
                op = 8'b01101101;  //five
            4'b0110:
                op = 8'b01111101;  //six
            4'b0111:
                op = 8'b00000111;  //seven
            4'b1000:
                op = 8'b01111111;  //eight
            4'b1001:
                op = 8'b01100111;  //nine
            4'b1010:
                op = 8'b01110111;  //A
            4'b1011:
                op = 8'b01111100;  //b
            4'b1100:
                op = 8'b00111001;  //C
            4'b1101:
                op = 8'b01011110;  //d
            4'b1110:
                op = 8'b01111001;  //E
            4'b1111:
                op = 8'b01110001;  //F
            default:
                op = 8'b00000000;
        endcase
    end
endmodule
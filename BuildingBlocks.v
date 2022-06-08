module inverter(a,y);                                                            
    input a;                                                                     
    output y;                                                                    
                                                                                 
    assign #1 y = ~a;                                                            
endmodule                                                                        
                                                                                 
//Full adder Internal Component
module fa_gate_1(a,b,c,y);                                                       
    input a,b,c;                                                                 
    output y;                                                                    
                                                                                 
    assign #1 y = ~((a&b) | (c&(b|a)));                                          
endmodule                                                                        
  
//Full adder Internal Component  
module fa_gate_2(a,b,c,m,y);                                                     
    input a,b,c,m;                                                               
    output y;                                                                    
                                                                                 
    assign #1 y = ~((a&b&c) | ((a|b|c)&m));                                      
endmodule                                                                        

// Full adder
module fa(a,b,ci,co,s);
    input a,b,ci;
    output s,co;

    wire nco, ns;

    fa_gate_1   fa_gate_1_1(a,b,ci, nco);
    fa_gate_2   fa_gate_2_1(a,b,ci,nco, ns);
    inverter    inverter_1(nco, co);
    inverter    inverter_2(ns, s);
endmodule

// D-register (flipflop).  Width set via parameter.
module dreg(clk, d, q);
    parameter width = 1;
    input clk;
    input [width-1:0] d;
    output [width-1:0] q;
    reg [width-1:0] q;

    always @(posedge clk) begin
        q <= d;
    end
endmodule

// 2-1 Mux.  Width set via parameter.
module mux2(a, b, sel, y);
    parameter width = 1;
    input [width-1:0] a, b;
    input sel;
    output [width-1:0] y;

    assign y = sel ? b : a;
endmodule

// 4-1 Mux.  Width set via parameter.
module mux4(a, b, c, d, sel, y);
    parameter width = 1;
    input [width-1:0] a, b, c, d;
    input [1:0] sel;
    output [width-1:0] y;
    reg [width-1:0] y;

    always @(*) begin
        case (sel)
            2'b00:    y <= a;
            2'b01:    y <= b;
            2'b10:    y <= c;
            default:  y <= d;
        endcase
    end
endmodule

// Left-shifter
module shl(a, y);
    parameter width = 2;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {a[width-2:0], 1'b0};
endmodule

// Right-shifter
module shr(a, y);
    parameter width = 2;
    input [width-1:0] a;
    output [width-1:0] y;

    assign y = {1'b0, a[width-1:1]};
endmodule

// 16-bit adder (declarative Verilog)
module adder16(a, b, sum);
    input [15:0] a, b;
    output [15:0] sum;

    assign sum = a+b;
endmodule

//4-bit ripple carry adder
module four_ripple_adder(num1,num2,total);
	input [3:0] num1;
	input [3:0] num2;
	output [4:0] total;
	
	wire carryout1,carryout2,carryout3;

	fa adder1(num1[0], num2[0], 0, carryout1, total[0]);
	fa adder2(num1[1], num2[1], carryout1, carryout2, total[1]);
	fa adder3(num1[2], num2[2], carryout2, carryout3, total[2]);
	fa adder4(num1[3], num2[3], carryout3, total[4], total[3]);

endmodule

//Used to control 7-segment display to show the sum
module segment_display(number,HEX00,HEX01,HEX02,HEX03,HEX04,HEX05,HEX06,HEX10,HEX11,HEX12,HEX13,HEX14,HEX15,HEX16);
	input [4:0] number;
	output HEX00,HEX01,HEX02,HEX03,HEX04,HEX05,HEX06,HEX10,HEX11,HEX12,HEX13,HEX14,HEX15,HEX16;

	reg HEX00,HEX01,HEX02,HEX03,HEX04,HEX05,HEX06,HEX10,HEX11,HEX12,HEX13,HEX14,HEX15,HEX16;
	
	always @ (number) begin
	
		if(number == 5'b00000) begin	//0
			HEX00 <= 0;
			HEX01 <= 0;
			HEX02 <= 0;
			HEX03 <= 0;
			HEX04 <= 0;
			HEX05 <= 0;
			HEX06 <= 1;
			
			HEX10 <= 0;
			HEX11 <= 0;
			HEX12 <= 0;
			HEX13 <= 0;
			HEX14 <= 0;
			HEX15 <= 0;
			HEX16 <= 1;
		end
		if(number == 5'b00001) begin	//1
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00010) begin	//2
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 1;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00011) begin	//3
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00100) begin	//4
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00101) begin	//5
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00110) begin	//6
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b00111) begin	//7
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b01000) begin	//8
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b01001) begin	//9
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 0;
			 HEX16 <= 1;
		end
		if(number == 5'b01010) begin	//10
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 1;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b01011) begin	//11
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b01100) begin	//12
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 1;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b01101) begin	//13
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b01110) begin	//14
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b01111) begin	//15
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b10000) begin	//16
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b10001) begin	//17
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b10010) begin	//18
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b10011) begin	//19
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 1;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 1;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 1;
		end
		if(number == 5'b10100) begin	//20
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b10101) begin	//21
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b10110) begin	//22
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 1;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b10111) begin	//23
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11000) begin	//24
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11001) begin	//25
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11010) begin	//26
			 HEX00 <= 0;
			 HEX01 <= 1;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11011) begin	//27
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11100) begin	//28
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11101) begin	//29
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 0;
			 HEX06 <= 0;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 1;
			 HEX13 <= 0;
			 HEX14 <= 0;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11110) begin	//30
			 HEX00 <= 0;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 0;
			 HEX04 <= 0;
			 HEX05 <= 0;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		if(number == 5'b11111) begin	//31
			 HEX00 <= 1;
			 HEX01 <= 0;
			 HEX02 <= 0;
			 HEX03 <= 1;
			 HEX04 <= 1;
			 HEX05 <= 1;
			 HEX06 <= 1;
			
			 HEX10 <= 0;
			 HEX11 <= 0;
			 HEX12 <= 0;
			 HEX13 <= 0;
			 HEX14 <= 1;
			 HEX15 <= 1;
			 HEX16 <= 0;
		end
		
	end
	
endmodule

// This is a test bench for 5 stage pipeline:
module testbench();
reg  [31:0]  x_40,y_40;
wire [31:0] res_40;
reg clk_40, rst_40;
fpadd_40 ml (.clk_40(clk_40),.rst_40(rst_40),.x_40(x_40),.y_40(y_40),.res_40(res_40));
initial begin
clk_40 = 0;
rst_40 = 0;
#1;
rst_40 = 1;
#1;
rst_40 = 0;
end
initial forever #5 clk_40 = ~clk_40;


  initial begin  
	$monitor ("Clock pulse= %d,reset = %d,x input =%d,y input = %d,Summation Result =%d" ,clk_40,rst_40,x_40,y_40,res_40);
  end
  
  initial begin
  $dumpfile ("fpadd_wave_40.vcd");
  $dumpvars (0);
  end
initial begin
#10
x_40 = 32'b01000010110010000000000000000000;	
y_40 = 32'b01000011010010000000000000000000;
#10
x_40 = 32'b01000010110010000000000000000000;	
y_40 = 32'b11000010010010000000000000000000;
#10  
x_40 = 32'b11000010010101000000000000000000;	
y_40 = 32'b01000010000011000000000000000000;
#10 
x_40 = 32'b11000011100101100000000000000000;	
y_40 = 32'b11000010110001100000000000000000;
#10 
x_40 = 32'b00000000000000000000000000000000;	
y_40 = 32'b00000000000000000000000000000000;
#10
x_40 = 32'b00000000000000000000000000000000;	
y_40 = 32'b11000011001010110000000000000000;
#200
$finish;
end
endmodule

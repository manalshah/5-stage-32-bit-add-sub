module unfp_40(x_40,y_40,res_40,rst_40, clk_40);

input [31:0] x_40,y_40;                   //  x_40 and y_40 are two floating point numbers as inputs in IEEE 754 format
input clk_40,rst_40;
output [31:0] res_40;	                 //  res_40 will display summation of x_40 and y_40 in IEEE 754 format
parameter menw_40=46;               // Used to define width of register to store mantissa: 1 bit is carry bit(if sum is producing carry will be                                   // stored here)
                                                      // other 23 bit to store original mantis from 32 bit IEEE standard and last bits to store shift

//reg [7:0] x,y;                            			//takes data in decimal	
reg sing_x_40,sing_y_40;			    // the signs of the x_40 and y_40 inputs
reg [7:0] exp_x_40, exp_y_40,exp_res_40;		// the exponents of each of the given signal
reg [menw_40:0] mes_x_40, mes_y_40,mes_medi_40,mes_res_40; // stores the mantissa of the inputs and outputs signal  	
reg za_40,zb_40;			        // a zero_40 operand (special case for later)
reg sign_res_40;		                    // sign of the result
reg [31:0] res_out_40;	                    	       // the output value from the always block
integer int_exp_x,int_exp_y,int_exp_dif_40;	// exponent stuff for difference...
integer renorm_40;		                    // How to renormalize in the given ieee 754 is decided by this var. 
parameter [menw_40:0] zero_40=0;

assign res_40=res_out_40;
always @(*) begin

/*
// THIS BLOCK COVERTS DATA OF DECIMAL INPUT INTO IEEE 754
// x AND y STORES DATA AS DEMIAL IN HERE.

if (x>o)begin 
sign_x_40=0;
end
else
begin
sign_x_40=1;
end
if (y>o)begin 
sign_y_40=0;
end
else
begin
sign_y_40=1;
end
int i_40;
int flag_40;
for ( i_40 = 0; i_40 <= 10; i_40 = i_40 +1) begin
 //max possible decimal number of 3 digit in given test bench can //be 99 which can be represented by                                                 //binary10
        if(x_40/2^i  !=  1) begin
        begin
        flag=flag+1;
        end
        exp_x_40=flag;
        mes_x_40=x_40


for ( i_40 = 0; i_40 <= 10; i_40 = i_40 +1) begin
//max possible decimal number of 3 digit in given testbench can //be 99 which can be  represnsted binary10
        If (y_40/2^i  !=  1) begin
        flag=flag+1
        end
        exp_y_40=flag;
        mes_y_40=y_40
    	end
*/
// comparing two numbers if zero or not
  za_40 = (x_40[30:0]==0)?1:0;
  zb_40 = (y_40[30:0]==0)?1:0;
  renorm_40=0;
// putting the bigger number in to the x_40
  if( y_40[30:0] > x_40[30:0] ) begin
    exp_x_40 = y_40[30:23];
    exp_y_40 = x_40[30:23];
    sing_x_40 = y_40[31];
    sing_y_40 = x_40[31];
    mes_x_40 = (zb_40)?0:{ 2'b1, y_40[22:0],zero_40[menw_40:25]};  // creating a 46 bit log mantissa register first two bit 01
    mes_y_40 = (za_40)?0:{ 2'b1, x_40[22:0],zero_40[menw_40:25]};  // after that mantissa of real number and at last zero padding which will be
    sign_res_40=sing_x_40;                                      // used during shifting  
  end else begin
    sing_x_40 = x_40[31];
    sing_y_40 = y_40[31];
    exp_x_40 = x_40[30:23];
    exp_y_40 = y_40[30:23];
    mes_x_40 = (za_40)?0:{ 2'b1, x_40[22:0],zero_40[menw_40:25]};
    mes_y_40 = (zb_40)?0:{ 2'b1, y_40[22:0],zero_40[menw_40:25]};
    sign_res_40=sing_x_40;
  end
  int_exp_x=exp_x_40;
  int_exp_y=exp_y_40;
  int_exp_dif_40=exp_x_40-exp_y_40;                         // taking difference of exponent of x_40 and y_40
  if(int_exp_dif_40 > 24) begin                             // making margin of difference by trial and error for 46 bit it can be anything 
           			                                              // greater than 23 
    exp_res_40=exp_x_40;                                    // bigger number x_40 is so big we can ignore significance of other y_40
    mes_medi_40=mes_x_40;
  end else begin                                            //putting result exponent as exponent of x_40
    exp_res_40=exp_x_40;
                                                            // shifting the exponent according to the 
    mes_y_40=(int_exp_dif_40[5])?{32'b0,mes_y_40[menw_40:32]}: {mes_y_40};
    mes_y_40=(int_exp_dif_40[4])?{16'b0,mes_y_40[menw_40:16]}: {mes_y_40};
    mes_y_40=(int_exp_dif_40[3])?{ 8'b0,mes_y_40[menw_40:8 ]}: {mes_y_40};
    mes_y_40=(int_exp_dif_40[2])?{ 4'b0,mes_y_40[menw_40:4 ]}: {mes_y_40};
    mes_y_40=(int_exp_dif_40[1])?{ 2'b0,mes_y_40[menw_40:2 ]}: {mes_y_40};
mes_y_40=(int_exp_dif_40[0])?{ 1'b0,mes_y_40[menw_40:1 ]}: {mes_y_40};

    if(sing_x_40 == sing_y_40) 
mes_medi_40=mes_x_40+mes_y_40;                          // IF BOTH THE SIGN ARE SAME ADDITION IF
// DIFFERENT SUBTRACTION
    else mes_medi_40=mes_x_40-mes_y_40;
    mes_res_40=mes_medi_40;
    renorm_40=0;
if(mes_medi_40[menw_40]) begin                        // IF MENTISSA SUMMATION HAS CARRY OUT REMOVING IT 
//AND ICREASING EXPONENT BY 1
      mes_medi_40={1'b0,mes_medi_40[menw_40:1]};
      exp_res_40=exp_res_40+1;
    end
// BY SHIFTING MAKING ORIGINAL MENTISSA  
   if(mes_medi_40[menw_40-1:menw_40-16]==0) begin 
	renorm_40[4]=1; mes_medi_40={ 1'b0,mes_medi_40[menw_40-17:0],16'b0 }; 
    end
    if(mes_medi_40[menw_40-1:menw_40-8]==0) begin 
	renorm_40[3]=1; mes_medi_40={ 1'b0,mes_medi_40[menw_40-9:0], 8'b0 }; 
    end
    if(mes_medi_40[menw_40-1:menw_40-4]==0) begin 
	renorm_40[2]=1; mes_medi_40={ 1'b0,mes_medi_40[menw_40-5:0], 4'b0 }; 
    end
    if(mes_medi_40[menw_40-1:menw_40-2]==0) begin 
	renorm_40[1]=1; mes_medi_40={ 1'b0,mes_medi_40[menw_40-3:0], 2'b0 }; 
    end
    if(mes_medi_40[menw_40-1   ]==0) begin 
	renorm_40[0]=1; mes_medi_40={ 1'b0,mes_medi_40[menw_40-2:0], 1'b0 }; 
    end
  end
// STORING ALL THE VALUES BACK TO MAKE IEEE 754 FORMAT
  res_out_40={sign_res_40,exp_res_40,mes_medi_40[menw_40-2:menw_40-24]};
end
endmodule

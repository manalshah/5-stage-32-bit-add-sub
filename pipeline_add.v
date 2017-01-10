
module fpadd_40(x_40,y_40,res_40,clk_40,rst_40);
input [31:0] x_40,y_40;				     //  res_40 will display summation of x_40 and y_40 in IEEE    
//754 format
output [31:0] res_40;				//  res_40 will display summation of x_40 and y_40 in IEEE 754 format
input clk_40,rst_40;
parameter menw_40=45;            // Used to define width of register to store mantissa: 1 bit is carry bit(if sum is producing 
// carry will be stored here)
   				// other 23 bit to store original mantis from 32 bit IEEE standard and last bits to store shift
reg sing_x_40,sing_y_40;	// the signs of the x_40 and y_40 inputs		
reg [7:0] exp_x_40, exp_y_40,exp_res_40;		// the exponents of each of the given signal
reg [menw_40:0] mes_x_40, mes_y_40,mes_res_40,mes_medi_40;	// stores the mantissa of the inputs and outputs 
//signal  	
reg zero_40_x,zero_40_y;	

reg signres;		                    // sign of the result

reg [7:0] exp_res_40;	// Resultant exponent value
reg [31:0] resout_40;	// resultant final 
integer int_exp_x,int_exp_y,int_exp_dif_40;	// exponent of input signals and diff between them.
integer renorm_40,renorm_400,renorm_401,renorm_402,renorm_403,renorm_404,renorm_405;	// Different renorm for //different stages	
parameter [menw_40:0] zero_40=0;
//passing exponent values
integer int_exp_dif_402,int_exp_dif_401,int_exp_dif_404,int_exp_dif_403,int_exp_dif_405,int_exp_dif_406,int_exp_dif_4000,int_exp_dif_400;
// different mantissa for different stages:
reg [menw_40:0] mes_y_402,mes_y_401,mes_y_403,mes_y_404;
reg [menw_40:0] mes_x_402,mes_x_401,mes_x_403,mes_x_404;
reg [menw_40:0] mes_res_401,mes_res_402,mes_res_403,mes_res_404,mes_res_4000,mes_res_400;
reg [7:0] exp_x_402,exp_x_401;
reg [7:0] exp_res_402,exp_res_401,exp_res_403,exp_res_404,exp_res_4000,exp_res_400;
reg sing_x_402,sing_x_401,sing_x_403;
reg sing_y_402,sing_y_401,sing_y_403;
reg signres2,signres1,signres3,signres4,signres5,signres6,signres00,signres0;

assign res_40=resout_40;
// making the combinational logic 
always @(*) begin
// 1st stage: alignment-1
// comparing two numbers if zero or not
renorm_40=0;
  zero_40_x = (x_40[30:0]==0)?1:0;
  zero_40_y = (y_40[30:0]==0)?1:0;
  // putting the bigger number in to the x_40
  if( y_40[30:0] > x_40[30:0] ) begin
    exp_x_40 = y_40[30:23];
    exp_y_40 = x_40[30:23];
    sing_x_40 = y_40[31];
    sing_y_40 = x_40[31];
    mes_x_40 = (zero_40_y)?0:{ 2'b1, y_40[22:0],zero_40[menw_40:25]};
    mes_y_40 = (zero_40_x)?0:{ 2'b1, x_40[22:0],zero_40[menw_40:25]};
    signres=sing_x_40;
  end else begin
    sing_x_40 = x_40[31];
    sing_y_40 = y_40[31];
    exp_x_40 = x_40[30:23];
    exp_y_40 = y_40[30:23];
    mes_x_40 = (zero_40_x)?0:{ 2'b1, x_40[22:0],zero_40[menw_40:25]};
    mes_y_40 = (zero_40_y)?0:{ 2'b1, y_40[22:0],zero_40[menw_40:25]};
    signres=sing_x_40;
  end
  int_exp_x=exp_x_40;
  int_exp_y=exp_y_40;
  int_exp_dif_40=exp_x_40-exp_y_40;

// 2nd Stage: alignment-2

int_exp_dif_402=int_exp_dif_401;
mes_y_402=mes_y_401;
mes_x_402=mes_x_401;
exp_x_402=exp_x_401;
sing_x_402=sing_x_401;
sing_y_402=sing_y_401;
signres2=signres1;
  if(int_exp_dif_402 > 24) begin
    exp_res_40=exp_x_402;
    mes_res_40=mes_x_402;
  end else begin
    exp_res_40=exp_x_402;
    mes_res_40=0;
    mes_y_402=(int_exp_dif_402[4])?{16'b0,mes_y_402[menw_40:16]}: {mes_y_402};
    mes_y_402=(int_exp_dif_402[3])?{ 8'b0,mes_y_402[menw_40:8 ]}: {mes_y_402};
    mes_y_402=(int_exp_dif_402[2])?{ 4'b0,mes_y_402[menw_40:4 ]}: {mes_y_402};
    mes_y_402=(int_exp_dif_402[1])?{ 2'b0,mes_y_402[menw_40:2 ]}: {mes_y_402};
    mes_y_402=(int_exp_dif_402[0])?{ 1'b0,mes_y_402[menw_40:1 ]}: {mes_y_402};
  end

//3rd stage: addition and subtraction

mes_y_404=mes_y_403;
mes_x_404=mes_x_403;
mes_res_4000=mes_res_400;
exp_res_4000=exp_res_400;
signres00=signres0;
int_exp_dif_4000=int_exp_dif_400;

 if (int_exp_dif_4000 <=24) begin
    if(sing_x_403 == sing_y_403) 
       	mes_res_4000=mes_x_404+mes_y_404;
	 else mes_res_4000=mes_x_404-mes_y_404;
    mes_medi_40=mes_res_4000;
    if(mes_res_4000[menw_40]) begin
      mes_res_4000={1'b0,mes_res_4000[menw_40:1]};
      exp_res_4000=exp_res_4000+1;
    end
  end

// Fourth Stage: normalization-1

mes_res_402=mes_res_401;
int_exp_dif_404=int_exp_dif_403;
signres4=signres3;
exp_res_402=exp_res_401;
renorm_403=renorm_402;
    if(mes_res_402[menw_40-1:menw_40-32]==0) begin 
	renorm_403[5]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-33:0],32'b0 }; 
    end
    if(mes_res_402[menw_40-1:menw_40-16]==0) begin 
	renorm_403[4]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-17:0],16'b0 }; 
    end
    if(mes_res_402[menw_40-1:menw_40-8]==0) begin 
	renorm_403[3]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-9:0], 8'b0 }; 
    end
    if(mes_res_402[menw_40-1:menw_40-4]==0) begin 
	renorm_403[2]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-5:0], 4'b0 }; 
    end
    if(mes_res_402[menw_40-1:menw_40-2]==0) begin 
	renorm_403[1]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-3:0], 2'b0 }; 
    end
    if(mes_res_402[menw_40-1   ]==0) begin 
	renorm_403[0]=1; mes_res_402={ 1'b0,mes_res_402[menw_40-2:0], 1'b0 }; 
    end




//Fifth Stage: normalization-2
mes_res_404=mes_res_403;
signres6=signres5;
renorm_405=renorm_404;
exp_res_404=exp_res_403;
int_exp_dif_406=int_exp_dif_405;
  if (int_exp_dif_406 <=60)
  begin
    if(mes_res_404 != 0) begin
      if(mes_res_404[menw_40-24:0]==0 && mes_res_404[menw_40-24]==1) begin
	if(mes_res_404[menw_40-11]==1) mes_res_404=mes_res_404+{1'b1,zero_40[menw_40-11:0]};
      end else begin
        if(mes_res_404[menw_40-54]==1) mes_res_404=mes_res_404+{1'b1,zero_40[menw_40-24:0]};
      end
      exp_res_404=exp_res_404-renorm_405;
      if(mes_res_404[menw_40-1]==0) begin
       exp_res_404=exp_res_404+1;
       mes_res_404={1'b0,mes_res_404[menw_40-1:1]};
      end
    end else begin
      exp_res_404=0;
      signres6=0;
    end
  end
resout_40={signres6,exp_res_404,mes_res_404[menw_40-2:menw_40-24]};
end
// Things that are happening at clock edge will be done over here
always @(posedge clk_40 or posedge rst_40)
begin
	if (rst_40) 
begin
int_exp_dif_401<=0;
mes_x_401<=0;
mes_y_401<= 0;
exp_x_401 <= 0;
sing_x_401<=0;
sing_y_401<=0;
signres1<=0;
renorm_401<=0;
mes_y_403 <= 0;
mes_x_403 <= 0;
sing_x_403 <= 0;
sing_y_403 <= 0;
mes_res_400 <= 0;
renorm_400 <= 0;
signres0 <= 0;
int_exp_dif_400 <= 0;
exp_res_400 <= 0;
mes_res_401 <= 0;
int_exp_dif_403<= 0;
signres3 <= 0;
exp_res_401<= 0;
renorm_402 <= 0;
mes_res_403<=  0;
signres5<= 0;
renorm_404<= 0;
exp_res_403<= 0;
int_exp_dif_405 <= 0;
end
	else begin
	int_exp_dif_401<= #1 int_exp_dif_40;
	mes_x_401<=#1 mes_x_40;
	mes_y_401<= #1 mes_y_40;
	exp_x_401 <= #1 exp_x_40;
	sing_x_401<= #1 sing_x_40;
	sing_y_401<= #1 sing_y_40;
	signres1<= #1 signres;
	renorm_401<= renorm_40;
	mes_y_403 <= #1 mes_y_402;
	mes_x_403 <= #1 mes_x_402;
	sing_x_403 <= #1 sing_x_402;
	sing_y_403 <= #1 sing_y_402;
	mes_res_400 <= #1 mes_res_40;
	renorm_400 <= renorm_401;
	signres0 <= #1 signres2;
	int_exp_dif_400 <= #1 int_exp_dif_402;
	exp_res_400 <= #1 exp_res_40;
	mes_res_401 <= #1 mes_res_4000;
	int_exp_dif_403<= #1 int_exp_dif_402;
	signres3 <= #1 signres00;
	exp_res_401<= #1 exp_res_4000;
	renorm_402 <= #1 renorm_400;
	mes_res_403 <= #1 mes_res_402;
	signres5 <= #1 signres4;
	renorm_404 <= #1 renorm_403;
	exp_res_403 <= #1 exp_res_402;
	int_exp_dif_405 <= #1 int_exp_dif_404;
	end
end
endmodule

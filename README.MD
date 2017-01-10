# 5-stage-32-bit-add-sub
Single Precision(32-bit) five stage Floating Point Adder and Subtractor
-->
Unpipeline_add.v
32 - bit Unpipelined Floating point adder 
This design is unpipeline so whole design takes complete hardware to compute one whole instrcution.
It takes the data in IEEE 754 format and convert it to decimal first and afterwards it add or subtract the two number according to 
the sign of the number. 

This process happens in 5 stages which are as given below:

Stage 1: Compare the exponents and determine the amount of shifts required to align the
		 mantissa to make the exponents equal (alignment-1).

Stage 2: Right-shift the mantissa of the smaller exponent by the required amount (alignment-2).

Stage 3: Compare the two aligned mantissas and determine which is the smaller of the two. Take
		 2’s complement of the smaller mantissa if the signs of the two numbers are different (addition).

Stage 4: Add the two mantissas. Then, determine the amount of shifts required and the
	     corresponding direction to normalize the result (normalization-1).

Stage 5: Shift the mantissa to the required direction by the required amount. Adjust the exponent
  		 accordingly and check for any exceptional condition (normalization-2)

pipeline_add.v
32 - bit pipelined Floating point adder 
This design is pipeline so instead of whole design instrcutions are divided into parts and whole execution complete in five cycles.
It takes the data in IEEE 754 format and convert it to decimal first and afterwards it add or subtract the two number according to 
the sign of the number.

Each stage is executed in single cycle. So one complete instructon takes 5 cycles. But when this design completes one stage, 
it passes the resulant data to the next stage and afterwards new instuction is fetched in the old stage. 
This kind of strcuture is known as pipelined design. With increment in hardware, it also increase the processing speed. 

-->Conclusion:
Usage of pipeline will increase the speed of computation. 
For unpipelined it took 60 sec to give output. But for pipelined it only took 35 sec to produce output for same test bech.

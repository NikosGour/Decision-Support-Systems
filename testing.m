data = [ 30 30 9.5*2.7 6 0.4;
		 40 50 12.5*2 5 0.4;
		 125 50 20*2 3 0.6;
		 1000 100 24.5*7.7 3 1.4];
number_of_experts = 15;

# Each row is the following
# 1. The weight of the criteria
# 2. If to add randomness/expert opinion
# 3. If higher is better
rules = [ 70 1 1;
		  50 1 0;
		  40 1 0;
		  10 0 1;
		  100 0 0;];

s=0.2:0.1:0.6

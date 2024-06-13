data = [ 30 30 9.5*2.7 6 0.4;
		 40 50 12.5*2 5 0.4;
		 125 50 20*2 3 0.6;
		 1000 100 24.5*7.7 3 1.4];
number_of_experts = 15;

u = find_utilities(data,number_of_experts)
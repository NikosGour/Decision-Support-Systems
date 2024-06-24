iterations=1000;

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
utils = find_utilities(data,rules,number_of_experts)

Prrs = zeros(1,5);

col_of_interest = 5;

for s=0.2:0.1:0.6
	u_actual = find_utilities(data,rules,number_of_experts);
	actual_order = find_order(u_actual);
	Prr_s = 0;
	Prrs_i = 1;
	for i=1:iterations
		u = find_utilities_with_pertrubation(data,rules,number_of_experts,s,col_of_interest);

		% if rank reversals occur Prr_s = Prr_s + 1;
		order = find_order(u);
		for j=1:rows(order)
			if order(j) != actual_order(j)
				Prr_s = Prr_s + 1;
				break;
			end
		end
	end
	Prrs(Prrs_i) = Prr_s / iterations;
	Prrs_i = Prrs_i + 1;
end

Prrs
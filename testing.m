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
		  100 0 0;]

function experts = generate_experts_opinions(data,rules, number_of_experts, expert_opinion_max=10, expert_opinion_min=-10)
	data_columns_min_max = find_min_max(data);
	experts = zeros(rows(data), columns(data), number_of_experts);
	# Generate experts' opinions , s_ij
	for i = 1:number_of_experts
		for row = 1:rows(data)
			for col = 1:columns(data)
				# For columns that, the lower the value the better
				if rules(col,3) == 0
					# If the value is the minimum, the expert opinion is 100
					if data(row,col) == data_columns_min_max(1,col)
						experts(row,col,i) = 100;
					# If the value is the maximum, the expert opinion is 10
					elseif data(row,col) == data_columns_min_max(2,col)
						experts(row,col,i) = 10;
				
					# If the value is not the minimum or the maximum
					else
						# Otherwise, the expert opinion is calculated as follows
						# map the value from the range [min, max] to [10, 100]
						# using the formula for range [a, b] to [c, d] mapping
						# f(x) = (d-c) * (x-a) / (b-a) + c
						# where x is the value to be mapped
						experts(row,col,i) = (100-10) * (data(row,col) - data_columns_min_max(1,col)) / (data_columns_min_max(2,col) - data_columns_min_max(1,col)) + 10;
						# reversing as the lower the value the better
						experts(row,col,i) = 100 - experts(row,col,i);

						# Generating randomness in the expert opinion
						rand_num = randn();
						while rand_num < -1 || rand_num > 1
							rand_num = randn();
						end

						# map the random number from the range [-1, 1] to [expert_opinion_min, expert_opinion_max]
						expert_opinion = (expert_opinion_max - expert_opinion_min) * (rand_num - (-1)) / (1 - (-1)) + expert_opinion_min;
						expert_opinion = floor(expert_opinion);

						# if the previous mapping + the randomness is out of the range [10, 100]
						# then generate a new random number and map it again
						while(experts(row,col,i) + expert_opinion < 10 || experts(row,col,i) + expert_opinion > 100)
							rand_num = randn();
							while rand_num < -1 || rand_num > 1
								rand_num = randn();
							end

							expert_opinion = (expert_opinion_max - expert_opinion_min) * (rand_num - (-1)) / (1 - (-1)) + expert_opinion_min;
							expert_opinion = floor(expert_opinion);
						end
						# add the randomness to the expert opinion
						#experts(row,col,i) = experts(row,col,i) + expert_opinion;
					end
				# For columns that, the higher the value the better
				else
					# If the value is the minimum, the expert opinion is 10
					if data(row,col) == data_columns_min_max(1,col)
						experts(row,col,i) = 10;
					# If the value is the maximum, the expert opinion is 100
					elseif data(row,col) == data_columns_min_max(2,col)
						experts(row,col,i) = 100;

					# If the value is not the minimum or the maximum
					else
						# Otherwise, the expert opinion is calculated as follows
						# map the value from the range [min, max] to [10, 100]
						# using the formula for range [a, b] to [c, d] mapping
						# f(x) = (d-c) * (x-a) / (b-a) + c
						# where x is the value to be mapped
						experts(row,col,i) = (100-10) * (data(row,col) - data_columns_min_max(1,col)) / (data_columns_min_max(2,col) - data_columns_min_max(1,col)) + 10;

						# Generating randomness in the expert opinion
						rand_num = randn();
						while rand_num < -1 || rand_num > 1
							rand_num = randn();
						end

						# map the random number from the range [-1, 1] to [expert_opinion_min, expert_opinion_max]
						expert_opinion = (expert_opinion_max - expert_opinion_min) * (rand_num - (-1)) / (1 - (-1)) + expert_opinion_min;
						expert_opinion = floor(expert_opinion);

						# if the previous mapping + the randomness is out of the range [10, 100]
						# then generate a new random number and map it again
						while(experts(row,col,i) + expert_opinion < 10 || experts(row,col,i) + expert_opinion > 100)
							rand_num = randn();
							while rand_num < -1 || rand_num > 1
								rand_num = randn();
							end

							expert_opinion = (expert_opinion_max - expert_opinion_min) * (rand_num - (-1)) / (1 - (-1)) + expert_opinion_min;
							expert_opinion = floor(expert_opinion);
						end

						# add the randomness to the expert opinion
						#experts(row,col,i) = experts(row,col,i) + expert_opinion;
					end
				end
			end
		end
	end
end

function data_columns_min_max = find_min_max(data)
	for i = 1:columns(data)
		data_columns_min_max(1,i) = min(data(:,i)); # min = 1st row
		data_columns_min_max(2,i) = max(data(:,i)); # max = 2nd row
	end
end

experts = generate_experts_opinions(data,rules, number_of_experts)
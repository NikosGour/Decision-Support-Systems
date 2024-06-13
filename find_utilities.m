# Returns the utility for each alternative
# data: the data matrix
# number_of_experts: the number of experts
# expert_opinion_max: the maximum value for the expert opinion swing
# expert_opinion_min: the minimum value for the expert opinion swing
function u = find_utilities(data,rules,number_of_experts, expert_opinion_max=10, expert_opinion_min=-10)

	experts = zeros(rows(data), columns(data), number_of_experts);
	p = set_ps(rules,number_of_experts)
	
	weights = zeros(number_of_experts, columns(data));

	# Calculate the weights for each criteria, w_i
	for i = 1:number_of_experts
		for col = 1:columns(data)
			weights(i,col) = p(i,col) / sum(p(i,:));
		end
	end

	# Generate experts' opinions , s_ij
	experts = generate_experts_opinions(data,rules, number_of_experts, expert_opinion_max, expert_opinion_min);

	# Calculate the average weight for each criteria, w_i'
	weight_avgs = zeros(1, columns(data));
	for col = 1:columns(data)
		weight_avgs(col) = sum(weights(:,col)) / number_of_experts;
	end

	# Calculate the average expert opinion for each criteria, s_ij'
	experts_avgs = zeros(rows(data), columns(data));
	for row = 1:rows(data)
		for col = 1:columns(data)
			experts_avgs(row,col) = sum(experts(row,col,:)) / number_of_experts;
		end
	end

	# Calculate the utility for each alternative, u_j
	u = zeros(rows(data), 1);
	for row = 1:rows(data)
		u(row) = sum(experts_avgs(row,:) .* weight_avgs);
	end
end

function data_columns_min_max = find_min_max(data)
	for i = 1:columns(data)
		data_columns_min_max(1,i) = min(data(:,i)); # min = 1st row
		data_columns_min_max(2,i) = max(data(:,i)); # max = 2nd row
	end
end

function ps = set_ps(rules,number_of_experts)
	ps = zeros(number_of_experts, rows(rules));

	for i = 1:number_of_experts
		for col = 1:rows(rules)
			extra = 0;

			if rules(col,2) == 1
				extra = randn();
			end
			
			ps(i,col) = rules(col,1) + (2 * extra);
		end
	end
end
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
						experts(row,col,i) = experts(row,col,i) + expert_opinion;
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
						experts(row,col,i) = experts(row,col,i) + expert_opinion;
					end
				end
			end
		end
	end
end
# Returns the utility for each alternative
# data: the data matrix
# number_of_experts: the number of experts
# expert_opinion_max: the maximum value for the expert opinion swing
# expert_opinion_min: the minimum value for the expert opinion swing
function u = find_utilities(data,rules,number_of_experts, expert_opinion_max=10, expert_opinion_min=-10)

	experts = zeros(rows(data), columns(data), number_of_experts);
	p = set_ps(rules,number_of_experts);
	
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

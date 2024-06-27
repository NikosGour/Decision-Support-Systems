function u = find_utilities_with_pertrubation(data,rules,number_of_experts, s, col_of_interest, expert_opinion_max=10, expert_opinion_min=-10)
	experts = zeros(rows(data), columns(data), number_of_experts);
	p = set_ps(rules,number_of_experts);
	
	weights = zeros(number_of_experts, columns(data));

	# Calculate the weights for each criteria, w_i
	for i = 1:number_of_experts
		for col = 1:columns(data)
			weights(i,col) = p(i,col) / sum(p(i,:));
		end
	end

	for i = 1:number_of_experts
		petrubation = s * weights(i,col_of_interest);
		#printf("Petrubation %d: %f\n", i, petrubation);
		#printf("Pertrubation / (columns(data) - 1) [%d]: %f\n",(columns(data) - 1), petrubation / (columns(data) - 1));
		weights(i,col_of_interest) = weights(i,col_of_interest) + petrubation;
		for col = 1:columns(data)
			if col != col_of_interest
				weights(i,col) = weights(i,col) - petrubation / (columns(data) - 1);
			end
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
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
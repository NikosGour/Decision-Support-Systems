function order = find_order(u)
	for i=1:rows(u)
		max_val = max(u);
		max_idx = find(u == max_val);
		order(i) = max_idx;
		u(max_idx) = 0;
	end
end
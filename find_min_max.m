function data_columns_min_max = find_min_max(data)
	for i = 1:columns(data)
		data_columns_min_max(1,i) = min(data(:,i)); # min = 1st row
		data_columns_min_max(2,i) = max(data(:,i)); # max = 2nd row
	end
end
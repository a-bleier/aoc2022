function solve(input)
	res1 ::Int, res2 ::Int = 0, 0
	for i in 1:length(input[1])-3
		if length(Set{Char}(input[1][i:i+3])) == 4
			res1 = i + 3
			break
		end
	end

	for i in 1:length(input[1])-13
		if length(Set{Char}(input[1][i:i+13])) == 14
			res2 = i + 13
			break
		end
	end

	return res1, res2
end
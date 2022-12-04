function solve(input)
	res1 ::Int, res2 ::Int = 0, 0
	pairs = [[tryparse(Int, x) for x in match(r"(\d+)-(\d+),(\d+)-(\d+)", line).captures] for line in input]
	res1 = count(pair -> pair[1] >= pair[3] && pair[2] <= pair[4] ||  pair[3] >= pair[1] && pair[4] <= pair[2], pairs)
	res2 = count(pair -> pair[1] <= pair[3] <= pair[2]  || pair[1] <= pair[4] <= pair[2] ||  pair[3] <= pair[1] <= pair[4] || pair[3] <= pair[2] <= pair[4], pairs)
	return res1, res2
end
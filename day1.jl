function solve(input)
	res1 = 0
	res2 = 0
	packs = [[tryparse(Int,obj) for obj in pack] for pack in splitter(input)] 
	calories = sort(map( x -> sum(x), packs), rev=true)
	res1 = calories[1]
	res2 = sum(calories[1:3])
	return res1, res2
end

function splitter(x)
	out = Vector{Vector{eltype(x)}}()
	cur = eltype(x)[]
	for s in x
		if isempty(s)
			push!(out, cur)
			cur = eltype(x)[]
		else
			push!(cur, s)
		end
	end
	push!(out, cur)
	return out
end
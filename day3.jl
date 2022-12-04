function solve(input)
	res1 ::Int, res2 ::Int = 0, 0
	types = Dict(zip("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 1:52))
	duplicates = Vector{Char}()
	for line in input
		middle = Int(length(line) / 2)
		comp1, comp2 = line[1:middle], line[middle+1:end]
		for c in comp1
			if c in comp2
				push!(duplicates, c)
				break
			end
		end
	end
	res1 = sum(types[item] for item in duplicates)

	chunk(arr, n) = [arr[i:min(i + n - 1, end)] for i in 1:n:length(arr)]

	chunks = chunk(input, 3)
	duplicates = Vector{Char}()
	for chunk in chunks
			for c in chunk[1] 
				if c in chunk[2] && c in chunk[3]
					push!(duplicates, c)
					break
				end
			end
	end
	res2 = sum(types[item] for item in duplicates)
	return res1, res2 
end
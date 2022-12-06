function solve(input)
	res1 = find_offset(4, input[1])
	res2 = find_offset(14, input[1])
	return res1, res2
end

function find_offset(marker_length ::Int, input ::String) ::Int
	counter = Dict{Char, Int}(zip("abcdefghijklmnopqrstuvwxyz", zeros(26)))
	single_letters ::Int = 0
	res1 ::Int, res2 ::Int = 0, 0
	for (i,current) in enumerate(input)

		current ::Char = input[i]

		counter[current] += 1
		if counter[current] == 1
			single_letters += 1
		elseif counter[current] == 2
			single_letters -= 1
		end
		
		if i > marker_length
			counter[input[i-marker_length]] -= 1
			if counter[input[i-marker_length]] == 1
				single_letters += 1
			elseif counter[input[i-marker_length]] == 0 
				single_letters -= 1
			end
		end

		if single_letters == marker_length
			return i
			break
		end
	end
	return 0
end
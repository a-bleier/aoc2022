function solve(input ::Vector{String})
	cycle ::Int = 1
	v ::Int = 1
	stops = [20, 60, 100, 140, 180, 220]
	sum ::Int = 0

	for line in input
		toks = split(line, " ")
		if toks[1] == "noop"
			cycle += 1
		else
			cycle += 1
			if cycle in stops
				sum += cycle * v
			end
			v += tryparse(Int, toks[2])
			cycle += 1
		end
		if cycle in stops
			sum += cycle * v 
		end
	end

	row, col = 1,1
	sprite_offset = 1
	reg ::Int = 0
	crt = zeros(Int, 6,40)
	stops = [20, 40, 60, 80, 120, 160, 200]
	next = iterate(input)
	add ::Bool = false
	for i in 1:1:2*length(input)
		if next === nothing
			break
		end
		if sprite_offset <= col <= sprite_offset +2
			crt[row,col] = 1
		else
			crt[row,col] = 0
		end

		(line, state) = next
		toks = split(line, " ")
		if toks[1] == "noop"
			next = iterate(input, state)
		else # add
			if !add 
				add = true 
			else
				add = false
				sprite_offset += tryparse(Int, toks[2])
				next = iterate(input, state)
			end
		end

		if col % 40 == 0
			row += 1
			col = 0
		end
		col += 1
	end
	for y in axes(crt, 1)
		for x in axes(crt, 2)
			print(crt[y,x] == 1 ? '#' : '.')
		end
		println("")
	end
	return sum, "Read the capital letters from output"
end
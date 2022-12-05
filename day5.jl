function solve(input)
	stop = findall(x -> x == "", input)
	stacks_inp ::Vector{String} = input[1:stop[1]-2]
	instructions_inp ::Vector{String}= input[stop[1]+1:end]

	stacks ::Vector{Vector{Int}} = Vector()

	flag ::Bool = true 
	for line in stacks_inp
		counter = 2
		stack_counter = 1
		for c in line
			if c in ['[', ']', ' '] && counter <= 3
				counter += 1
			else
				if flag
					push!(stacks, Vector())
				end
				if c != ' '
					push!(stacks[stack_counter], c)
				end
				counter = 1
				stack_counter += 1
			end
		end
		flag = false
	end

	for stack in stacks
		reverse!(stack)
	end

	instr ::Vector{Vector{Int}} = [ tryparse.(Int, match(r"move (\d+) from (\d+) to (\d+)", ins).captures) for ins in instructions_inp]

	old_stacks = deepcopy(stacks)
	for ins in instr
		for _ in 1:ins[1]
			push!(stacks[ins[3]], pop!(stacks[ins[2]]))
		end
	end

	res1 = join([stack[end] for stack in stacks])
	for ins in instr
		append!(old_stacks[ins[3]], old_stacks[ins[2]][end-ins[1]+1:end])
		old_stacks[ins[2]] = old_stacks[ins[2]][1:end-ins[1]]
	end

	res2 = join([stack[end] for stack in old_stacks])

	return res1, res2

end
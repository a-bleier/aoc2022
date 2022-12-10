function solve(input ::Vector{String})
	trees ::Array{Int32} = zeros(Int32, length(input), length(input[1]))	 
	visibility ::Array{Int} = zeros(Int32, length(input), length(input[1]))	 
	scenic_score ::Array{Int} = ones(Int32, length(input), length(input[1]))	 


	for (i,line) in enumerate(input)
		trees[i, :] = tryparse.(Int32, split(line,""))
	end

	for y in axes(trees, 1)
		# left
		visibility[y,1] = 1
		biggest = trees[y,1]
		scenic_score[y,1] = 0
		for x in axes(trees, 2)[2:end]
			
			if trees[y,x] > biggest
				visibility[y,x] = 1
				biggest = trees[y,x]
			end

			c = 0
			for i in x-1:-1:1
				c += 1
				if trees[y,i] >= trees[y,x]
					break
				end
			end

			scenic_score[y,x] *= c 

		end
		# right
		visibility[y,end] = 1
		biggest = trees[y,end]
		scenic_score[y,end] = 0
		for x in reverse(axes(trees, 2))[2:end]
			if trees[y,x] > biggest
				visibility[y,x] = 1
				biggest = trees[y,x]
			end

			c = 0
			for i in x+1:size(trees, 2)
				c += 1
				if trees[y,i] >= trees[y,x]
					break
				end
			end

			scenic_score[y,x] *= c 
		end
	end

	for x in axes(trees, 2)
		#up
		visibility[1,x] = 1
		biggest = trees[1,x]
		scenic_score[1,x] = 0
		for y in axes(trees, 1)[2:end]
			if trees[y,x] > biggest
				visibility[y,x] = 1
				biggest = trees[y,x]
			end

			c = 0
			for i in y-1:-1:1
				c += 1
				if trees[i,x] >= trees[y,x]
					break
				end
			end

			scenic_score[y,x] *= c 
		end
		# down
		visibility[end,x] = 1
		biggest = trees[end,x]
		scenic_score[end,x] = 0
		for y in reverse(axes(trees, 1))[2:end]
			if trees[y,x] > biggest 
				visibility[y,x] = 1
				biggest = trees[y,x]
			end

			c = 0
			for i in y+1:size(trees, 1)
				c += 1
				if trees[i,x] >= trees[y,x]
					break
				end
			end

			scenic_score[y,x] *= c 
		end
	end

	res1 = sum(visibility)
	res2 = maximum(scenic_score)

	return res1,res2
end
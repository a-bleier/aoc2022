for day in ARGS
	name = "day" * day
	println("------ Solving day $(day) -----")
	include("day$(day).jl")
	for p in readdir("inputs/$(name)", join=true)
		if isfile(p)
			f = open(p)
			input = readlines(f)
			close(f)

			println("Solving with input from $(p)")
			@time begin
				sol1, sol2 = solve(input)
			end
			println("Part 1: $(sol1) | Part 2: $(sol2)")
		end
	end
	println("")
end

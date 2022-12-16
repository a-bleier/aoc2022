mutable struct Monkey
	items::Vector{UInt64}
	op ::Char
	operand ::Int
	test ::UInt64
	t ::Int
	f ::Int
	counter ::Int

	function Monkey()
		new(Vector{UInt64}(),'x',0, 0, 0, 0,0)
	end

	function do_monkey_stuff()
		return
	end
	
end


function solve(input ::Vector{String})

	monkey ::Monkey= Monkey()
	monkeys  = Vector{Monkey}()
	for line in input
		words = filter!(x -> x != "", split(line, " "))
		if length(words) == 0
			continue
		end
		if contains(words[1], "Monkey")
			monkey = Monkey()
		elseif contains(words[1], "Starting")
			nums = String.(filter(x -> length(x) != 0, [filter(isdigit, collect(s)) for s in words]))
			monkey.items = tryparse.(UInt64, nums)
		elseif contains(words[1], "Operation")
			if words[end] == "old"
				monkey.op = '^'
				monkey.operand = 2
			else
				monkey.op = words[end-1][1]
				monkey.operand = tryparse(Int, words[end])
			end
		elseif contains(words[1], "Test")
			monkey.test = tryparse(UInt, words[end])
		elseif contains(words[1], "If") && words[2] == "true:"
			monkey.t = tryparse(Int, words[end])
		elseif contains(words[1], "If") && words[2] == "false:"
			monkey.f = tryparse(Int, words[end])
			push!(monkeys, monkey)
		end
	end

	monkeys_old = deepcopy(monkeys)

	for _ in 1:20
		for m in monkeys
			m.counter += length(m.items)
			for item in m.items
				if m.op == '^'
					newlevel = item ^ m.operand
				elseif m.op == '+'
					newlevel = item + m.operand
				elseif m.op == '*'
					newlevel = item * m.operand
				end
				newlevel = trunc(UInt64, newlevel / 3)
				if newlevel % m.test == 0
					push!(monkeys[m.t+1].items, newlevel)
				else
					push!(monkeys[m.f+1].items, newlevel)
				end
			end
			m.items = Vector()
		end
	end
	sorted_monkeys = sort(monkeys, by = x -> x.counter, rev=true)
	res1 = sorted_monkeys[1].counter * sorted_monkeys[2].counter

	monkeys = monkeys_old

	p = prod([m.test for m in monkeys])
	for _ in 1:10000
		for m in monkeys
			m.counter += length(m.items)
			for item in m.items
				if m.op == '^'
					newlevel = item ^ m.operand
				elseif m.op == '+'
					newlevel = item + m.operand
				elseif m.op == '*'
					newlevel = item * m.operand
				end

				if newlevel % m.test == 0
					push!(monkeys[m.t+1].items, newlevel % p)
				else
					push!(monkeys[m.f+1].items, newlevel % p)
				end
			end
			m.items = Vector()
		end
	end
	sorted_monkeys = sort(monkeys, by = x -> x.counter, rev=true)
	res2 = sorted_monkeys[1].counter * sorted_monkeys[2].counter

	return res1, res2
end
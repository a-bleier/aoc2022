function solve(input)
	res1, res2 = 0, 0
	rounds = [(convert_to_hand(x[1]), convert_to_hand(x[3])) for x in input]
	points = map(pair -> get_points(pair) + pair[2]+1, rounds)
	res1 = sum(points)

	points = map(pair -> get_hand(pair), rounds)
	res2 = sum(points)
	return res1, res2 
end

function get_hand(game ::Tuple)
	if game[2] ==  0 # loose
		return mod(game[1] - 1, 3) + 1
	elseif game[2] == 1 # draw
		return game[1]+4
	else # win
		return mod(game[1] + 1, 3) + 7
	end
end

function get_points(game)
	if game[1] - game[2] == 0
		return 3
	end
	if  mod((game[2]-1),3) == game[1]
		return 6
	end
	return 0
end

function convert_to_hand(l)
	if l == 'A' || l == 'X'
		return 0
	elseif l == 'B' || l == 'Y'
		return 1
	else 
		return 2
	end
end
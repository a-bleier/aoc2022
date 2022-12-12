using StaticArrays

mutable struct Rope
	head ::MVector{2,Int}
	tail ::MVector{2,Int}

	function Rope()
		new(MVector(0,0), MVector(0,0))
	end
end

mutable struct LongRope

	knots ::MVector{10, MVector{2, Int}}

	function LongRope()
		new(@MVector[MVector(0,0) for i in 1:10])
	end
end

function apply_motion(rope ::LongRope, motion ::MVector{2, Int}, tail_positions ::Set{Tuple{Int, Int}})
	length ::Int = motion[1] + motion[2]
	d_n = StaticArrays.normalize(motion)

	for _ in 1:abs(length)
		rope.knots[1] .+= d_n
		for (i,knot) in enumerate(rope.knots)
			if i == 1
				continue
			end
			head = rope.knots[i-1]
			tail = knot
			if head[1] != tail[1] && head[2] == tail[2] || head[1] == tail[1] && head[2] != tail[2]
				if sum(abs.(head .- tail)) >= 2 
					tail = head .- StaticArrays.normalize(head .- tail)
				end
			elseif head[1] != tail[1] && head[2] != tail[2]
				if sum(abs.(head .- tail)) >= 3
					dif = (head .- tail)
					tail .+= (sign(dif[1]) * 1, sign(dif[2])* 1)
					
				end
			end
			rope.knots[i-1] .= head
			rope.knots[i] .= tail
		end
		union!(tail_positions, [(rope.knots[end][1], rope.knots[end][2])])
	end
end

function apply_motion(rope ::Rope, motion ::MVector{2, Int}, tail_positions ::Set{Tuple{Int, Int}})

	length ::Int = motion[1] + motion[2]
	d_n = StaticArrays.normalize(motion)

	for _ in 1:abs(length)
		rope.head .+= d_n
		if rope.head[1] != rope.tail[1] && rope.head[2] == rope.tail[2] || rope.head[1] == rope.tail[1] && rope.head[2] != rope.tail[2]
			if sum(abs.(rope.head .- rope.tail)) >= 2 && StaticArrays.normalize!(rope.head .- rope.tail) == d_n
				rope.tail = rope.head .- d_n
				union!(tail_positions, [(rope.tail[1], rope.tail[2])])
			end
		elseif rope.head[1] != rope.tail[1] && rope.head[2] != rope.tail[2]
			if sum(abs.(rope.head .- rope.tail)) >= 3
				rope.tail = rope.head .- d_n
				union!(tail_positions, [(rope.tail[1], rope.tail[2])])
			end
		end
	end
end

function solve(input ::Vector{String})
	tail_positions = Set{Tuple{Int, Int}}()
	tail_positions_long_rope = Set{Tuple{Int, Int}}()
	union!(tail_positions, [(0,0)])
	union!(tail_positions_long_rope, [(0,0)])

	rope = Rope()
	long_rope = LongRope()

	for line in input
		motion ::Vector{String} = [String(tok::SubString) for tok in split(line, " ")]
		dir, value = motion[1], tryparse(Int, motion[2])
		
		#x, y
		if dir == "U"
			d  = (0,value)
		elseif dir == "D"
			d  = (0,-value)
		elseif dir == "R"
			d  = (value, 0)
		elseif dir == "L"
			d  = (-value, 0)
		end

		apply_motion(rope, MVector(d), tail_positions)
		apply_motion(long_rope, MVector(d), tail_positions_long_rope)
	end

	return length(tail_positions), length(tail_positions_long_rope)
end
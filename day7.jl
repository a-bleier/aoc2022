mutable struct Node
	name ::String
	children ::Dict{String, Node}
	size ::Int

	function Node(name ::String, size ::Int)
		new(name, Dict{String, Node}(), size ::Int)	
	end

	function Node(name ::String)
		Node(name, 0)
	end

end

function build_fs(lines ::Vector{String}, curr ::Int, tree ::Node) ::Int
	# ls
	while curr <= length(lines)
		if lines[curr] == "\$ ls"
			curr += 1
			l = split(lines[curr])
			while l[1] != "\$"

				if l[1] == "dir"
					tree.children[l[2]] = Node(String(l[2]::SubString))
				else 
					tree.children[l[2]] = Node(String(l[2]::SubString), tryparse(Int64, l[1]))
				end
				if curr == length(lines)
					return curr
				end
				curr += 1
				l = split(lines[curr], " ")
			end
			continue

		elseif lines[curr] == "\$ cd .." 
			return curr
		else		
			l = split(lines[curr])
			curr = build_fs(lines, curr+1, tree.children[String(l[3]::SubString)])
		end
		curr += 1
	end
	return curr
end

function propagate_sizes(tree ::Node, dirs ::Dict{String, Int})
	if length(tree.children) == 0
		return
	end

	for (name,node) in tree.children
		propagate_sizes(node, dirs)
	end
	
	tree.size = sum(v.size for (k,v) in tree.children)
	if ! (tree.name in keys(dirs))
		dirs[tree.name] = 0
	end
	dirs[tree.name] += tree.size <= 100000 ? tree.size : 0
end

function find_delete(node ::Node, min_req ::Int) ::Int
	if length(node.children) == 0
		return 0
	end

	best_child ::Int = 30000000
	for (name, child) in node.children
		s ::Int = find_delete(child, min_req)
		if s >= min_req && s < best_child
			best_child = s
		end
	end

	return node.size >= min_req && node.size < best_child ? node.size : best_child
end

function solve(input)
	root = Node("/")

	last = build_fs(input[2:end], 1, root)

	root_old = deepcopy(root)
	dirs ::Dict{String, Int}= Dict{String, Int}()
	propagate_sizes(root, dirs)
	res1 = sum([s for (k,s) in dirs])

	req_size = 30000000 - (70000000 - root.size)

	res2 = find_delete(root, req_size)

	return res1,res2
end

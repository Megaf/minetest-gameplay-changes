print('...Loading [minetest-gameplay-changes]')

function default.can_grow(pos)
  local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 2 then -- CHANGED (from 13 to 2)!!!
		return false
	end
	return true
end

local function is_snow_nearby(pos)
	return minetest.find_node_near(pos, 1,
		{"default:snow", "default:snowblock", "default:dirt_with_snow"})
end

function default.grow_sapling(pos)
	if not default.can_grow(pos) then
		-- try a bit later again
		minetest.get_node_timer(pos):start(math.random(240, 600))
		return
	end

	local mg_name = minetest.get_mapgen_setting("mg_name")
	local node = minetest.get_node(pos)
	if node.name == "default:sapling" then
		minetest.log("action", "A sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		if mg_name == "v6" then
			default.grow_tree(pos, math.random(1, 4) == 1)
		else
			default.grow_new_apple_tree(pos)
		end
	elseif node.name == "default:junglesapling" then
		minetest.log("action", "A jungle sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		if mg_name == "v6" then
			default.grow_jungle_tree(pos)
		else
			default.grow_new_jungle_tree(pos)
		end
	elseif node.name == "default:pine_sapling" then
		minetest.log("action", "A pine sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		local snow = is_snow_nearby(pos)
		if mg_name == "v6" then
			default.grow_pine_tree(pos, snow)
		elseif snow then
			default.grow_new_snowy_pine_tree(pos)
		else
			default.grow_new_pine_tree(pos)
		end
	elseif node.name == "default:acacia_sapling" then
		minetest.log("action", "An acacia sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		default.grow_new_acacia_tree(pos)
	elseif node.name == "default:aspen_sapling" then
		minetest.log("action", "An aspen sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		default.grow_new_aspen_tree(pos)
	end
end


minetest.override_item("default:sapling", {on_place = nil, on_timer = default.grow_sapling})

minetest.override_item("default:junglesapling", {on_place = nil, on_timer = default.grow_sapling})

minetest.override_item("default:pine_sapling", {on_place = nil, on_timer = default.grow_sapling})

minetest.override_item("default:acacia_sapling", {on_place = nil, on_timer = default.grow_sapling})

print('[minetest-gameplay-changes] loaded.')

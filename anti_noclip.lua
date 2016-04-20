--
-- Mod Ant-Cracker
--
-- Ant-NoClip
--

local diretrizes = anti_cracker.diretrizes.anti_noclip

local reverificar_noclip = function(pos, name)
	if name then
		local player = minetest.get_player_by_name(name)
		if player then
			local node = minetest.get_node(pos)
			if node.name == "default:stone" 
				and table.maxn(minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+2, z=pos.z+1} , {"default:stone"})) > 34 
			then
				minetest.chat_send_player(name, "Morreste soterrado")
				anti_cracker.tomar_medida(name, 1, name.." aparentemente usou noclip em cavernas.")
				player:set_hp(0)
			end
		end
	end
end

-- Loop para verificar 
verificar_noclip = function(name)
	if name then
		local player = minetest.get_player_by_name(name)
		if player then
			local pos = player:getpos()
			local node = minetest.get_node(pos)
			if node.name == "default:stone" 
				and table.maxn(minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y+2, z=pos.z+1} , {"default:stone"})) > 34 
			then
				minetest.after(diretrizes.tempo_reverificar_noclip, reverificar_noclip, pos, name)
			end
			if pos.y < -100 then
				minetest.after(diretrizes.tempo_verificar_noclip, verificar_noclip, name)
			else
				minetest.after(60, verificar_noclip, name)
			end
		end
	end
end

-- Inicia o loop com jogadores que se conectam no servidor
minetest.register_on_joinplayer(function(player)
	if player then
		local name = player:get_player_name()
		if minetest.check_player_privs(name, {noclip=true}) ~= true or 1 == 1 then
			minetest.after(diretrizes.tempo_verificar_noclip, verificar_noclip, name)
		end
	end
end)

--
-- Mod Ant-Cracker
--
-- Ant-NoHup
--

-- Loop para verificar se o jogador esta usando nohup
verificar_nohup = function(name)
	if name then
		local player = minetest.get_player_by_name(name)
		if player then
			local pos = player:getpos()
			local node = minetest.get_node(pos)
			if 
				-- Esta no mesmo lugar que uma pedra
				node.name == "default:stone"  
				-- Certifica que nao existe escavacao nas proximidades
				and 	table.maxn(minetest.find_nodes_in_area(
						{x=pos.x-3, y=pos.y-3, z=pos.z-3}, 
						{x=pos.x+3, y=pos.y+3, z=pos.z+3}, 
						{"default:stone", "default:stone_with_iron", "default:stone_with_coal", "default:stone_with_copper"}
					)) == 343
				-- Nao tem tunel vertical em cima
				and 	table.maxn(minetest.find_nodes_in_area(
						{x=pos.x-2, y=pos.y+12, z=pos.z-2}, 
						{x=pos.x+2, y=pos.y+12, z=pos.z+2}, 
						{"default:stone", "default:stone_with_iron", "default:stone_with_coal", "default:stone_with_copper"}
					)) == 25
			then
				minetest.chat_send_player(name, "Morreste soterrado")
				tomar_medida(name, 1, name.." aparentemente usou nohup em cavernas.")
				player:set_hp(0)
				minetest.after(tempo_verificar_nohup, verificar_nohup, name)
			else
				if pos.y < -100 then
					minetest.after(tempo_verificar_nohup, verificar_nohup, name)
				else
					minetest.after(60, verificar_nohup, name)
				end
			end
		end
	end
end

-- Inicia o loop com jogadores que se conectam no servidor
minetest.register_on_joinplayer(function(player)
	if player then
		local name = player:get_player_name()
		if minetest.check_player_privs(name, {nohup=true}) ~= true then
			minetest.after(tempo_verificar_nohup, verificar_nohup, name)
		end
	end
end)

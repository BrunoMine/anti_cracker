--
-- Mod Ant-Cracker
--
-- Ant-Dug-Fast
--

local diretrizes = anti_cracker.diretrizes.anti_dug_fast

local penalizados = {}

local liberar = function(name)
	if name and penalizados[name] then
		penalizados[name] = false
	end
end

minetest.register_on_cheat(function(player, cheat)
	if cheat.type == "dug_too_fast"and player then
		local name = player:get_player_name()
		penalizados[name] = true
		minetest.after(diretrizes.tempo_liberar_cavar, liberar, name)
	end
end)

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	if digger then
		local name = digger:get_player_name()
		if penalizados[name] then
			return
		end
	end
	return old_node_dig(pos, node, digger)
end

-- Limpa as variaveis quando o jogador sair do servidor
minetest.register_on_leaveplayer(function(player)
	if player then
		local name = player:get_player_name()
		local Npenalizados = {}
		for pname, n in pairs(penalizados) do
			if name ~= pname then
				Npenalizados[pname] = penalizados[pname]
			end
		end
		penalizados = Npenalizados
	end
end)

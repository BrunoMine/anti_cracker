--
-- Mod Ant-Cracker
--
-- Ant-Fast
--

-- Um jogador anda um maximo de 40 blocos em 10 segundos

local ultima_pos = {}
local status_tp = {}

-- Atualiza a posicao do jogador a cada instante
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 15 then
		timer = 0
		for name, n in pairs(ultima_pos) do
			local player = minetest.get_player_by_name(name)
			if player then
				ultima_pos[name] = player:getpos()
			end
		end
	end
end)

local zerar_status_tp = function(name)
	if name then
		print(dump(status_tp[name]))
		status_tp[name] = false
	end
end

minetest.register_on_cheat(function(player, cheat)
	if player then
		local name = player:get_player_name()
		if cheat.type == "moved_too_fast" then
			if minetest.check_player_privs(name, {teleport=true}) then
				return
			end
			local pos = player:getpos()
			if ultima_pos[name].x+40 < pos.x
				or ultima_pos[name].x-40 > pos.x
				or ultima_pos[name].z+40 < pos.z
				or ultima_pos[name].z-40 > pos.z
			then
				if status_tp[name] == false then
					if not minetest.find_node_near(player:getpos(), 20, lista_blocos_tp) then
						if minetest.check_player_privs(name, {teleport=true}) ~= true then
							local msg = "[Ant-Cracker] Medida 2 | Aparentemente voce correu rapido demais."
							tomar_medida(name, 2, msg)
							player:setpos(ultima_pos[name])
						end
					else
						status_tp = true
						ultima_pos[name] = player:getpos()
					end
				end
			end
		end
	end
end)

-- Insere registro de jogadores que entram no servidor
minetest.register_on_joinplayer(function(player)
	if player then
		local name = player:get_player_name()
		ultima_pos[name] = (player:getpos())
		status_tp[name] = false
	end
end)

-- Limpa as variaveis quando o jogador sair do servidor
minetest.register_on_leaveplayer(function(player)
	if player then
		local name = player:get_player_by_name()
		local Nultima_pos = {}
		local Nstatus_tp = {}
		for pname, n in pairs(status_tp) do
			if name ~= pname then
				Nultima_pos[pname] = ultima_pos[pname]
				Nstatus_tp[pname] = status_tp[pname]
			end
		end
		ultima_pos = Nultima_pos
		status_tp = Nstatus_tp
	end
end)

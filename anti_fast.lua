--
-- Mod Ant-Cracker
--
-- Ant-Fast
--

local diretrizes = anti_cracker.diretrizes.anti_fast

-- Calculando variaveis
local dist_max_andando = (diretrizes.tempo_att*diretrizes.velocidade_max)
local dist_max_andando_suspeito = (diretrizes.tempo_att_suspeitos*diretrizes.velocidade_max)
local dist_verif_emissor = diretrizes.dist_verif + dist_max_andando
local dist_verif_receptor = diretrizes.dist_verif
local spawn = minetest.setting_get_pos("static_spawnpoint") or {x=0,y=0,z=0}
local blocos_receptor = diretrizes.blocos_tp_livre
local blocos_emissor = diretrizes.blocos_tp_emissor
for i, bloco in ipairs(diretrizes.blocos_tp_livre) do
	table.insert(blocos_emissor, bloco)
end

local ultima_pos = {}
local status_tp = {}
local acumulador = {}
local suspeitos = {}

local cancelar_suspeito = function(name)
	if name then
		local Nsuspeitos = {}
		for pname, n in pairs(suspeitos) do
			if name ~= pname then
				Nsuspeitos[pname] = suspeitos[pname]
			end
		end
		suspeitos = Nsuspeitos
	end
end

-- Atualiza a posicao do jogador
local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= diretrizes.tempo_att then
		timer = 0
		for name, n in pairs(ultima_pos) do
			local player = minetest.get_player_by_name(name)
			if player and not suspeitos[name] then
				ultima_pos[name] = player:getpos()
			end
		end
	end
end)

-- Atualiza a posicao do jogador suspeitos
local timer2 = 0
minetest.register_globalstep(function(dtime)
	timer2 = timer2 + dtime
	if timer2 >= diretrizes.tempo_att_suspeitos then
		timer2 = 0
		for name, n in pairs(suspeitos) do
			local player = minetest.get_player_by_name(name)
			if player and ultima_pos[name] then
				ultima_pos[name] = player:getpos()
			end
		end
	end
end)

local zerar_status_tp = function(name)
	if name then
		status_tp[name] = false
	end
end

local zerar_acumulador = function(name)
	if name then
		acumulador[name] = false
	end
end

minetest.register_on_cheat(function(player, cheat)
	if cheat.type == "moved_too_fast" then
		if player then
			local name = player:get_player_name()
			if acumulador[name] == false and status_tp[name] == false then
				acumulador[name] = true
				minetest.after(2, zerar_acumulador, name)
				if minetest.check_player_privs(name, {teleport=true}) then
					return
				end
				-- Verifica se o jogador esta muito longe de sua ultima posicao gravada
				local pos = player:getpos()
				local dist = dist_max_andando
				if suspeitos[name] then
					dist = dist_max_andando_suspeito
				end
				if ultima_pos[name].x+dist < pos.x
					or ultima_pos[name].x-dist > pos.x
					or ultima_pos[name].z+dist < pos.z
					or ultima_pos[name].z-dist > pos.z
					or ultima_pos[name].y+dist < pos.y
				then
					-- Verifica se tem blocos de legitimem a distancia tao longa como um tp
					if not minetest.find_node_near(ultima_pos[name], dist_verif_emissor, blocos_emissor) 
						or not minetest.find_node_near(player:getpos(), dist_verif_receptor, blocos_receptor) 
					then
						-- O teleport nao foi legitimo (ou o movimento pareceu muito rapido)
						anti_cracker.tomar_medida(name, 2, "Aparentemente "..name.." moveu-se rapido demais.")
						player:setpos(ultima_pos[name])
					else
						-- O teleport foi legitimo
						status_tp[name] = true
						minetest.after(2, zerar_status_tp, name)
						ultima_pos[name] = player:getpos()
					end
				else
					-- O movimento pareceu rapido
					if not suspeitos[name] then
						suspeitos[name] = true
						minetest.after(20, cancelar_suspeito, name)
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
		acumulador[name] = false
	end
end)

-- Limpa as variaveis quando o jogador sair do servidor
minetest.register_on_leaveplayer(function(player)
	if player then
		local name = player:get_player_name()
		local Nultima_pos = {}
		local Nstatus_tp = {}
		local Nacumulador = {}
		for pname, n in pairs(status_tp) do
			if name ~= pname then
				Nultima_pos[pname] = ultima_pos[pname]
				Nstatus_tp[pname] = status_tp[pname]
				Nacumulador[pname] = acumulador[pname]
			end
		end
		acumulador = Nacumulador
		ultima_pos = Nultima_pos
		status_tp = Nstatus_tp
	end
end)

-- Mantem o jogador no lugar do spawn
minetest.register_on_respawnplayer(function(player)
	if player then
		local pos = player:getpos()
		local name = player:get_player_name()
		if minetest.find_node_near(pos, dist_verif_receptor, diretrizes.blocos_respawn) then
			ultima_pos[name] = pos
			status_tp[name] = true	
			minetest.after(2, zerar_status_tp, name)
		else
			ultima_pos[name] = spawn
		end
	end
end)

-- As vezes o jogador nao vai para o spawn
minetest.register_on_dieplayer(function(player)
	if player then
		local name = player:get_player_name()
		ultima_pos[name] = spawn
		suspeitos[name] = true
		minetest.after(diretrizes.tempo_att, cancelar_suspeito, name)
	end
end)

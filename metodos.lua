--
-- Mod Ant-Cracker
--
-- Metodos
--

-- Pegar um bloco do mapa
function pegar_node(pos)
	local node = minetest.get_node(pos)
	if node.name == "ignore" then
		minetest.get_voxel_manip():read_from_map(pos, pos)
		node = minetest.get_node(pos)
	end
	return node
end

-- Controlar jogadores kickados
local kickados = {}
local retirar_kick = function(name)
	for _, pname in pairs(kickados) do
		local Nkickados = {}
		if name ~= pname then
			Nkickados[name] = true
		end
	end
	kickados = Nkickados
end
-- Kickar jogador
local kickar = function(name, numero, msg, tempo)
	if not name or not msg or not tonumber(tempo) or not tonumber(numero) then return end
	minetest.kick_player(name, "[Ant-Cracker] Medida "..numero.." | "..msg)
	kickados[name] = numero
	minetest.after(tempo, retirar_kick, name)
end
-- Impedir jogadores kickados de entrar
minetest.register_on_prejoinplayer(function(name)
	if tonumber(kickados[name]) then
		return "[Ant-Charker] O nome "..name.." foi kickado temporariamente pela medida "..kickados[name]
	end
end)

-- Tomar medidas
anti_cracker.tomar_medida = function(name, numero, msg, kick, tempo)
	if not name or not tonumber(numero) or not msg then return end
	local player = minetest.get_player_by_name(name)
	if not player then return end
	if kick and tonumber(tempo) then
		kickar(name, numero, msg, tempo)
	end
	minetest.log("action", "[Ant-Cracker] Medida "..numero.." | "..msg)
end



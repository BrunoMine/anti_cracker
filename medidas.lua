--
-- Mod Ant-Cracker
--
-- Medidas
--

-- Tomar medidas
tomar_medida = function(name, numero, msg, kick, tempo)
	if not name or not tonumber(numero) or not msg then return end
	local player = minetest.get_player_by_name(name)
	if not player then return end
	if kick and tonumber(tempo) then
		kickar(name, numero, msg, tempo)
	end
	minetest.log("action", "[Ant-Cracker] Medida "..numero.." | "..msg)
end

--
-- Mod Ant-Cracker
--
-- Inicializador de scripts Lua
--

-- Notificador de Inicializador
local notificar = function(msg)
	if minetest.setting_get("log_mods") then
		minetest.debug("[ANT-CRACKER]"..msg)
	end
end

local modpath = minetest.get_modpath("anti_cracker")

-- Carregar scripts
notificar("Carregando scripts...")
dofile(modpath.."/diretrizes.lua")
dofile(modpath.."/metodos.lua")
dofile(modpath.."/anti_nohup.lua")
notificar("OK")

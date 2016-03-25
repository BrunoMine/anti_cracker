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

-- Variavel global
anti_cracker = {}

local d_anticheat = minetest.setting_getbool("disable_anticheat")
if not d_anticheat then
    d_anticheat = false
end

-- Carregar scripts
notificar("Carregando scripts...")
dofile(modpath.."/diretrizes.lua")
dofile(modpath.."/metodos.lua")
if anti_cracker.diretrizes.anti_noclip then
	dofile(modpath.."/anti_noclip.lua")
end
if anti_cracker.diretrizes.anti_fast and d_anticheat == false then
	dofile(modpath.."/anti_fast.lua")
end
if anti_cracker.diretrizes.anti_dug_fast and d_anticheat == false then
	dofile(modpath.."/anti_dug_fast.lua")
end
notificar("OK")
if d_anticheat then
	minetest.log("error", "[ANTI_CRACKER]: Alguns recursos do anti_cracker foram desabilitados porque o anti_cheat padrao foi desabilitado")
end

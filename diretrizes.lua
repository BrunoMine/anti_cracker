--
-- Mod Ant-Cracker
--
-- Diretrizes
--


-- Ferramenta ANTI NOCLIP
local ANTI_NOCLIP = true
-- Tempo em segundos para verificar noclip em cavernas
local tempo_verificar_noclip = 8
-- Tempo para reverificar noclip (para caso de latencia alta do jogador)
local tempo_reverificar_noclip = 8


-- Ferramenta ANTI FAST
local ANTI_FAST = true
-- Tempo (em segundos) para o servidor atualizar a posicao de todos os jogadores
local tempo_att = 15
-- Tempo (em segundos) para o servidor atualizar a posicao de todos os jogadores suspeitos
local tempo_att_suspeitos = 3
-- Velocidade maxima de um jogador andando (em blocos por segundo)
local velocidade_max = 7.1
-- Distancia maxima de um bloco de tp
local dist_verif = 15
-- Lista de blocos presentes para livre tp (opicional)
local blocos_tp_livre = {}
-- Lista de blocos presentes apenas para emitir jogadores (opicional)
local blocos_tp_emissor = {}
-- Lista de blocos presentes para respawn privado (exemplo a cama) (opicional)
local blocos_respawn = {}

-- Ferramenta ANTI DUG FAST (cavar muito rapido)
local ANTI_DUG_FAST = true
-- Tempo para liberar escavacao apos ter colocado cavado muito rapido
local tempo_liberar_cavar = 1




--
-- Ajustando dados globais
-- (Desenvolvimento)
--

anti_cracker.diretrizes = {}
if ANTI_NOCLIP then
	anti_cracker.diretrizes.anti_noclip = {
		tempo_verificar_noclip = tempo_verificar_noclip,
		tempo_reverificar_noclip = tempo_reverificar_noclip
	}
end
if ANTI_FAST then
	anti_cracker.diretrizes.anti_fast = {
		tempo_att = tempo_att,
		tempo_att_suspeitos = tempo_att_suspeitos,
		velocidade_max = velocidade_max,
		dist_verif = dist_verif,
		blocos_tp_livre = blocos_tp_livre,
		blocos_tp_emissor = blocos_tp_emissor,
		blocos_respawn = blocos_respawn
	}
end
if ANTI_DUG_FAST then
	anti_cracker.diretrizes.anti_dug_fast = {
		tempo_liberar_cavar = tempo_liberar_cavar
	}
end

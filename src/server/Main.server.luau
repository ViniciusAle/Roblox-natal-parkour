--!strict
-- Ponto de entrada do servidor.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Valida todos os chunks já na inicialização (avisos aparecem no Output)
require(ReplicatedStorage.Shared.ChunkLibrary)

local LobbyBuilder = require(script.Parent.LobbyBuilder)
local pad = LobbyBuilder.build()

require(script.Parent.PlayerData).start()
require(script.Parent.RunSessions).start()
require(script.Parent.MatchService).start(pad)

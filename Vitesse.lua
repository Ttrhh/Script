-- Ce script double la vitesse uniquement pour le joueur local
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function augmenterVitesse()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 32 -- x2 de la vitesse normale
    print("Ta vitesse a été doublée !")
end

augmenterVitesse()

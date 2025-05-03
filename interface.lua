local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Fonction pour réinitialiser le personnage après un respawn
local function setupCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Variables pour le fly et le saut infini
    local flying = false
    local infiniteJump = false
    local flySpeed = 16  -- Vitesse de vol par défaut

    -- GUI setup
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "ControlPanel"

    -- Frame principale
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 220)
    frame.Position = UDim2.new(0, 20, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.BorderRadius = UDim.new(0, 10)

    -- Titre du panneau
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleLabel.Text = "Contrôles"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextAlign = Enum.TextXAlignment.Center
    titleLabel.BackgroundTransparency = 0.5
    titleLabel.BorderSizePixel = 0

    -- Bouton Fly
    local flyButton = Instance.new("TextButton", frame)
    flyButton.Size = UDim2.new(1, -20, 0, 40)
    flyButton.Position = UDim2.new(0, 10, 0, 50)
    flyButton.Text = "Activer Fly"
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    flyButton.Font = Enum.Font.Gotham
    flyButton.TextSize = 18
    flyButton.BorderRadius = UDim.new(0, 5)
    
    -- Contrôle de la vitesse de vol (ajustable)
    local speedLabel = Instance.new("TextLabel", frame)
    speedLabel.Size = UDim2.new(1, -20, 0, 40)
    speedLabel.Position = UDim2.new(0, 10, 0, 100)
    speedLabel.Text = "Vitesse de vol: " .. flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextSize = 16
    speedLabel.Font = Enum.Font.Gotham

    local increaseButton = Instance.new("TextButton", frame)
    increaseButton.Size = UDim2.new(0, 40, 0, 40)
    increaseButton.Position = UDim2.new(0, 10, 0, 150)
    increaseButton.Text = "▲"
    increaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    increaseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    increaseButton.Font = Enum.Font.Gotham
    increaseButton.TextSize = 20
    increaseButton.BorderRadius = UDim.new(0, 5)

    local decreaseButton = Instance.new("TextButton", frame)
    decreaseButton.Size = UDim2.new(0, 40, 0, 40)
    decreaseButton.Position = UDim2.new(0, 200, 0, 150)
    decreaseButton.Text = "▼"
    decreaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    decreaseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    decreaseButton.Font = Enum.Font.Gotham
    decreaseButton.TextSize = 20
    decreaseButton.BorderRadius = UDim.new(0, 5)

    -- Fly Activation
    local flyVelocity
    local flyDirection = Vector3.new(0, 0, 0)

    flyButton.MouseButton1Click:Connect(function()
        flying = not flying
        flyButton.Text = flying and "Désactiver Fly" or "Activer Fly"

        if flying then
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.Parent = root

            -- Détection des touches pour voler
            game:GetService("RunService").RenderStepped:Connect(function()
                if flying and root and humanoid then
                    local dir = Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
                    flyVelocity.Velocity = dir.Unit * flySpeed
                end
            end)
        else
            if flyVelocity then
                flyVelocity:Destroy()
                flyVelocity = nil
            end
        end
    end)

    -- Ajustement de la vitesse de vol
    increaseButton.MouseButton1Click:Connect(function()
        flySpeed = flySpeed + 2
        speedLabel.Text = "Vitesse de vol: " .. flySpeed
    end)

    decreaseButton.MouseButton1Click:Connect(function()
        if flySpeed > 2 then
            flySpeed = flySpeed - 2
            speedLabel.Text = "Vitesse de vol: " .. flySpeed
        end
    end)

end

-- Appeler la fonction au respawn
player.CharacterAdded:Connect(function()
    setupCharacter()
end)

-- Assurez-vous que l'interface est toujours rechargée même après la mort
if player.Character then
    setupCharacter()
end

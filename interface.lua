local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ControlPanel"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local flyButton = Instance.new("TextButton", frame)
flyButton.Size = UDim2.new(1, -20, 0, 30)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Activer Fly"

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 50)
speedBox.Text = "Vitesse: 16"
speedBox.ClearTextOnFocus = false

local jumpButton = Instance.new("TextButton", frame)
jumpButton.Size = UDim2.new(1, -20, 0, 30)
jumpButton.Position = UDim2.new(0, 10, 0, 90)
jumpButton.Text = "Saut Infini: OFF"

-- Infinite jump
local infiniteJump = false
jumpButton.MouseButton1Click:Connect(function()
	infiniteJump = not infiniteJump
	jumpButton.Text = "Saut Infini: " .. (infiniteJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if infiniteJump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Speed change
speedBox.FocusLost:Connect(function()
	local value = tonumber(speedBox.Text:match("%d+"))
	if value then
		humanoid.WalkSpeed = value
		speedBox.Text = "Vitesse: " .. value
	end
end)

-- Fly
local flying = false
local flyVelocity

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = flying and "Désactiver Fly" or "Activer Fly"

	if flying then
		flyVelocity = Instance.new("BodyVelocity")
		flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyVelocity.Parent = root

		game:GetService("RunService").RenderStepped:Connect(function()
			if flying and root and humanoid then
				local moveDir = Vector3.new()
				if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
				flyVelocity.Velocity = moveDir.Unit * humanoid.WalkSpeed
			end
		end)
	else
		if flyVelocity then
			flyVelocity:Destroy()
			flyVelocity = nil
		end
	end
end)

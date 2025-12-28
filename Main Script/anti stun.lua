--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--add us on roblox vincentplayz9356
local player = game:GetService("Players").LocalPlayer

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Sit = false
    
    local connections = {}
    
    local function handleBadState(newState)
        if newState == Enum.HumanoidStateType.Ragdoll or 
           newState == Enum.HumanoidStateType.FallingDown or 
           newState == Enum.HumanoidStateType.PlatformStanding or
           newState == Enum.HumanoidStateType.Seated then
            humanoid.Sit = false
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Anchored = false
            end
            return true
        end
        return false
    end
    
    handleBadState(humanoid:GetState())
    
    table.insert(connections, humanoid.StateChanged:Connect(function(_, newState)
        handleBadState(newState)
    end))
    
    for _, seat in pairs(workspace:GetDescendants()) do
        if seat:IsA("Seat") then
            table.insert(connections, seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                if seat.Occupant == humanoid then
                    task.wait(0.04)
                    humanoid.Sit = false
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end))
        end
    end
    
    table.insert(connections, humanoid.Died:Connect(function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
    end))
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

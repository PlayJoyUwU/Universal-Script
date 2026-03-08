--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
if not game:GetService("RunService"):IsClient() then return end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local UPDATE_INTERVAL = 1

local function getHealthColor(healthPercent)
    if healthPercent > 0.7 then
        return Color3.new(0, 1, 0)
    elseif healthPercent > 0.3 then
        return Color3.new(1, 1, 0)
    else
        return Color3.new(1, 0, 0)
    end
end

local function createOverheadGui(player, head)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HealthDisplay"
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
    
    return textLabel
end

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Name = "HealthHighlight"
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    return highlight
end

local function updatePlayerDisplay(player, textLabel, highlight)
    local character = player.Character
    if not character then
        if textLabel then
            textLabel.Text = "Dead"
            textLabel.TextColor3 = Color3.new(1, 1, 1)
        end
        if highlight then
            highlight:Destroy()
        end
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        if textLabel then
            textLabel.Text = "No Humanoid"
            textLabel.TextColor3 = Color3.new(1, 1, 1)
        end
        if highlight then
            highlight:Destroy()
        end
        return
    end
    
    local health = math.floor(humanoid.Health)
    local healthPercent = humanoid.Health / humanoid.MaxHealth
    local healthColor = getHealthColor(healthPercent)
    
    if textLabel then
        textLabel.Text = string.format("❤️ %d", health)
        textLabel.TextColor3 = healthColor
    end
    
    if highlight then
        highlight.FillColor = healthColor
        highlight.OutlineColor = healthColor
    end
end

local function trackPlayer(player)
    if player == Players.LocalPlayer then return end
    
    local textLabel
    local highlight
    local humanoidConnection
    local characterAddedConnection
    local humanoidDiedConnection
    local updateLoopActive = true

    local function cleanup()
        updateLoopActive = false
        if humanoidConnection then
            humanoidConnection:Disconnect()
            humanoidConnection = nil
        end
        if humanoidDiedConnection then
            humanoidDiedConnection:Disconnect()
            humanoidDiedConnection = nil
        end
        if textLabel and textLabel.Parent then
            textLabel.Parent:Destroy()
            textLabel = nil
        end
        if highlight then
            highlight:Destroy()
            highlight = nil
        end
    end

    task.spawn(function()
        while updateLoopActive and player.Parent do
            updatePlayerDisplay(player, textLabel, highlight)
            task.wait(UPDATE_INTERVAL)
        end
    end)

    local function setupCharacter(character)
        cleanup()
        updateLoopActive = true
        
        local head
        repeat
            task.wait(0.1)
            if not character or not character.Parent then return end
            head = character:FindFirstChild("Head")
        until head
        
        textLabel = createOverheadGui(player, head)
        highlight = createHighlight(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoidConnection = humanoid.HealthChanged:Connect(function()
            updatePlayerDisplay(player, textLabel, highlight)
        end)
        
        humanoidDiedConnection = humanoid.Died:Connect(function()
            updatePlayerDisplay(player, textLabel, highlight)
        end)
        
        updatePlayerDisplay(player, textLabel, highlight)
    end
    
    characterAddedConnection = player.CharacterAdded:Connect(setupCharacter)
    
    if player.Character then
        task.spawn(setupCharacter, player.Character)
    end
    
    player.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            cleanup()
            if characterAddedConnection then
                characterAddedConnection:Disconnect()
            end
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        task.spawn(trackPlayer, player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        task.spawn(trackPlayer, player)
    end
end)

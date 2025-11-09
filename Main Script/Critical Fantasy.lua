local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{Title="whatever",SubTitle="by tiam",TabWidth=160,Size=UDim2.fromOffset(470,380),Resize=true,MinSize=Vector2.new(470,380),Acrylic=false,Theme="Dark",MinimizeKey=Enum.KeyCode.RightControl}
local Tabs = {Main=Window:CreateTab{Title="Main",Icon="phosphor-users-bold"},Settings=Window:CreateTab{Title="Settings",Icon="settings"}}
local Options = Library.Options


Tabs.Main:CreateButton{
    Title = "Kill wtvr ur fighting",
    Description = "",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local chr = plr.Character
        local hrp = chr.HumanoidRootPart
        for i,v in pairs(workspace.Entities:GetChildren()) do
            if v.TargetingList:FindFirstChild(chr.Name) then
                v.Humanoid.Health = 0
            end
        end
    end
}
Tabs.Main:CreateButton{
    Title = "godmode",
    Description = "",
    Callback = function()
        for i,v in pairs(workspace:GetChildren())do
            if string.find(v.Name, "ProjectileContainer") then
                v:Destroy()
            end
        end
        workspace.ChildAdded:Connect(function(child)
            if child:IsA("Folder") and string.find(child.Name, "ProjectileContainer") then
                child:Destroy()
            end
        end)
    end
}
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Library:Notify{Title="Fluent",Content="The script has been loaded.",Duration=8}
SaveManager:LoadAutoloadConfig()

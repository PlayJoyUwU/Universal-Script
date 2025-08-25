local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:connect(function()
	if InfiniteJumpEnabled then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end
end)
	--Notifies readiness
	game.StarterGui:SetCore("SendNotification", {Title="Infinite Jump"; Text="The Infinite Jump exploit is ready! | Made by Play Joy UwU"; Duration=5;})

-- Put this whereever, but ServerScriptService is preferred.

-- Make a remote event called "ChatSystem" in Replicated Storage

local ChatService = {}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local event = RS:WaitForChild("ChatSystem")

local Styles = {
	Default = {
		prefix = "[ChatService]: ",
		color = Color3.fromRGB(52, 184, 255)
	},
	LOOT = {
		prefix = "[LOOT]: ",
		color = Color3.fromRGB(255, 215, 0)
	}
}

function ChatService:SendMessage(player, message, textColor, typeMessage)
	if event then
		if Styles[typeMessage] then
			event:FireClient(player, Styles[typeMessage].prefix, Styles[typeMessage].color, message, textColor)
		else
			event:FireClient(player, Styles["Default"].prefix, Styles["Default"].color, message, textColor)
		end
	end
end

function ChatService:SendAll(message, textColor, typeMessage)
	for _, player in ipairs(Players:GetPlayers()) do
		ChatService:SendMessage(player, message, textColor, typeMessage)
	end
end

function ChatService:Init()
	Players.PlayerAdded:Connect(function(player)
		wait(1)
		ChatService:SendMessage(player, "Chat service loaded.", Color3.fromRGB(255, 255, 255))
		ChatService:SendAll(player.Name .. " Has joined the server.", Color3.fromRGB(25, 197, 28))
	end)
	Players.PlayerRemoving:Connect(function(player)
		ChatService:SendAll(player.Name .. " Has left the server.", Color3.fromRGB(255, 48, 51))
	end)
end

return ChatService
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local hotkey = _G.desyncHotkey or Enum.KeyCode.F1

local uis = game:GetService("UserInputService")
local lp = game.Players.LocalPlayer
local desyncActive = false
local mainCharacter = nil
local deathConnections = {}


function deactivate()
	desyncActive = false
	
	for i, connection in pairs(deathConnections) do
		connection:Disconnect()
		table.remove(deathConnections, i)
	end
	
	mainCharacter.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame
	lp.Character:Destroy()
	local oldctype = game.Workspace.CurrentCamera.CameraType
	game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
	task.wait()
	lp.Character = mainCharacter
	game.Workspace.CurrentCamera.CameraSubject = mainCharacter.Humanoid
	game.Workspace.CurrentCamera.CameraType = oldctype
	mainCharacter.Animate.Enabled = false
	mainCharacter.Animate.Enabled = true
end


uis.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == hotkey then
		if desyncActive then
			deactivate()
		else
			desyncActive = true
			mainCharacter = lp.Character
			local oldArchivable = mainCharacter.Archivable
			mainCharacter.Archivable = true
			local clone = mainCharacter:Clone()
			mainCharacter.Archivable = oldArchivable
			clone.Parent = game.Workspace
			local oldctype = game.Workspace.CurrentCamera.CameraType
			game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			task.wait()
			lp.Character = clone
			game.Workspace.CurrentCamera.CameraSubject = clone.Humanoid
			game.Workspace.CurrentCamera.CameraType = oldctype
			clone.Animate.Enabled = false
			clone.Animate.Enabled = true
			
			-- handle death and stuff
			table.insert(deathConnections, mainCharacter.Humanoid.Died:Connect(function()
				deactivate()
			end))
			table.insert(deathConnections, clone.Humanoid.Died:Connect(function()
				deactivate()
			end))
		end
	end
end)
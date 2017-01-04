AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
resource.AddWorkshop("126657558")-- mor_chemical_labs_b3_re
resource.AddWorkshop("658249952")--mor_isolation_b4_re

include ("shared.lua")

util.PrecacheModel("models/player/gasmask.mdl")
util.PrecacheModel("models/player/zombie_fast.mdl")

util.AddNetworkString("RoundTimer")
util.AddNetworkString("SendTime")

time = 301

local maps = {
	"mor_chemical_labs_b3_re",
	"mor_isolation_b4_re"
}
function GM:Initialize()
	restartGame()
	updateTimer()
end

function GM:ShouldCollide( ply1, ply2 )
	if ply1:Team() == 3 or ply2:Team() == 3 then
		return false
	end
	return true
end

function GM:CanPlayerSuicide()
	return false
end

function GM:PlayerSetHandsModel( ply, ent )

	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerSpawn(ply)
	if ply:Team() == 3 then 
		ply:Spectate(OBS_MODE_ROAMING)
	else
		if ply:Team() == 2 then
			ply:SetNoCollideWithTeammates( true )
		else
			ply:SetNoCollideWithTeammates( false )
		end
		ply:SetHealth(50)
		ply:UnSpectate()
		ply:SetModel("models/player/gasmask.mdl")
		ply:AllowFlashlight(true)
		ply:Give("weapon_m4a1")
		ply:GiveAmmo(60,"smg1",true)
		ply:SetupHands()
	end
end

function GM:PlayerShouldTakeDamage(ply, atk)
	if atk:IsPlayer() then
		if  atk:Team() == ply:Team() then
			return false
		elseif ply:GetModel() == atk:GetModel() then
			return false
		elseif atk:IsPlayer() and ply:GetModel() ~= atk:GetModel() then
			return true
		end
	end
	return false
end


function GM:PlayerDeath( ply , wep , atk )
	local pos = ply:GetPos()
	if atk:IsPlayer() then
		if ply:Team() == 1 then
			ply:SetTeam(2)
			ply:SetNoCollideWithTeammates( true )
			ply:EmitSound("vo/npc/male01/ohno.wav", 50, 100, 1)
			timer.Simple(.05, function() ply:Spawn() end)
			timer.Simple(.06, function()ply:SetPos(pos)end)
		else
			ply:SetTeam(3)
			timer.Simple(.2, function() ply:Spawn() end)
		end
	end
	testWin()
end

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(3)
	util.AddNetworkString( "Derma" )
	net.Start( "Derma" )
	net.Send(ply)
end

function testWin(force)
	if force == true then
		doWin(1)
	elseif #team.GetPlayers(1) == 0 then
		doWin(2)
	elseif #team.GetPlayers(2) == 0 then
		doWin(1)
	end
	return false
end

function   GM:PlayerDeathSound()
	return false
end

	local curAmmo
	local curClipAmmo
function GM:KeyPress(ply, key)
	if ply:Team() == 2 then
		if key == IN_ATTACK2 then
			if ply:GetModel() == "models/player/zombie_fast.mdl" then
				timer.Simple(1, function() 
				ply:SetModel("models/player/gasmask.mdl")
				ply:RemoveAllItems()
				ply:AllowFlashlight(true)
				ply:SetRunSpeed(200)
				ply:SetWalkSpeed(200)
				ply:Give("weapon_m4a1") 
				if (curAmmo ~= nil and curClipAmmo ~= nil) then
					ply:GiveAmmo(curAmmo, "smg1", true)
					ply:GetActiveWeapon():SetClip1(curClipAmmo)
				end
				end)
			else
				curAmmo = ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())
				curClipAmmo = ply:GetActiveWeapon():Clip1()
				ply:SetModel("models/player/zombie_fast.mdl")
				ply:EmitSound("npc/fast_zombie/fz_scream1.wav", 150, 90, 1)
				ply:SetRunSpeed(350)
				ply:SetWalkSpeed(300)
				ply:RemoveAllItems()
				ply:Give("weapon_Crowbar")
				if ply:FlashlightIsOn() then
				ply:Flashlight(false)
				end
				ply:AllowFlashlight( false )
			end
		end
	end
end
local zombie
function restartGame()
	if #player.GetHumans() > 1  then
		for i, v in ipairs(player.GetHumans()) do
			v:RemoveAllItems()
			v:RemoveAllAmmo()
			v:SetTeam(1)
			v:SetMaxHealth(50)
			v:SetWalkSpeed(200)
			v:SetRunSpeed(200)
			v:SetHealth(50)
			timer.Simple(.1, function() v:Spawn() end)
		end
		zombie = table.Random(player.GetHumans())
		zombie:RemoveAllItems()
		zombie:Give("weapon_m4a1")
		zombie:SetTeam(2)
		zombie:SetMaxHealth(50)
		zombie:SetHealth(50)
		zombie:RemoveAllAmmo()
		timer.Simple(.1, function() zombie:Spawn() end)
	else
		PrintMessage( HUD_PRINTTALK, "Not enough players are present to start another game, retrying in 30 seconds." )
		timer.Simple(30,restartGame)
	end
end

function doWin(winner)
	util.AddNetworkString( "TestForWin" )
	net.Start( "TestForWin" )
	net.WriteInt(winner, 3)
	net.Broadcast()
	timer.Simple(5, restartGame)
	timer.Simple(4.9, function() time = 301 end)
end

function updateTimer()
	if time <= 0 then 
		testWin(true)
		timer.Simple(5, updateTimer)
	else
	time = time - 1
	SendTime()
	timer.Simple(1, updateTimer)
	end
end

function SendTime()
	 net.Start( "SendTime" )
	 net.WriteInt( time, 32 )
	 net.Broadcast()
	end

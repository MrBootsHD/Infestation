include("shared.lua")
local health
local roundMessage
local time = 0
function GM:HUDPaint()
	if LocalPlayer():Alive() then
		if LocalPlayer():Team() ~= 3 then
			health = LocalPlayer():Health()*2
			/* Time */
			draw.RoundedBox(5, -10, -5,ScrW()/15,ScrH()/22,Color(0,0,0,255))
			surface.SetDrawColor(255,255,255,255)
			surface.DrawCircle( ScrW()/2, ScrH()/2, ScrW()/150,Color(255,255,255,255))
			surface.DrawLine( ScrW()/2-ScrW()/80, ScrH()/2 , ScrW()/2+ScrW()/80, ScrH()/2 )
			surface.DrawLine( ScrW()/2, ScrH()/2-ScrW()/80 , ScrW()/2, ScrH()/2+ScrW()/80 )
			draw.DrawText( time, "Trebuchet24", ScrW()/60, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			/* Health */
			draw.RoundedBox(0, ScrW()/33, ScrH()-ScrH()/10.2,ScrW()/7.5,ScrH()/22,Color(100,100,100,175))
			draw.RoundedBox(0, ScrW()/30, ScrH()-ScrH()/10.7,ScrW()/800*health,ScrH()/25,Color(255-health*2.55,health*2.55,0,255))
			draw.DrawText( "Health: "..health, "DermaDefault", ScrW()/15, ScrH()-ScrH()/11.9, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "weapon_m4a1" then
				draw.RoundedBox(0, ScrW()/33, ScrH()-ScrH()/19,ScrW()/7.5,ScrH()/22,Color(175,175,175,175))
				draw.DrawText( "Ammo: "..LocalPlayer():GetActiveWeapon():Clip1().."/" ..LocalPlayer():GetAmmoCount( LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType() ), "DermaDefault", ScrW()/15, ScrH()-ScrH()/21, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			else
				draw.RoundedBox(0, ScrW()/33, ScrH()-ScrH()/19,ScrW()/7.5,ScrH()/22,Color(175,175,175,175))
				draw.DrawText( "Ammo: N/A", "DermaDefault", ScrW()/15, ScrH()-ScrH()/21, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
			end
		end
		if testWin() == false then 
			surface.SetDrawColor(255,255,255,255)
			surface.DrawCircle( ScrW()/2, ScrH()/2, ScrW()/150,Color(255,255,255,255))
			surface.DrawLine( ScrW()/2-ScrW()/80, ScrH()/2 , ScrW()/2+ScrW()/80, ScrH()/2 )
			surface.DrawLine( ScrW()/2, ScrH()/2-ScrW()/80 , ScrW()/2, ScrH()/2+ScrW()/80 )
			draw.DrawText( "Team: "..team.GetName(LocalPlayer():Team()), "DermaDefault", ScrW()/15, ScrH()-ScrH()/30, Color(0,0,0,255), TEXT_ALIGN_LEFT )
		end
		if stop == false then
		surface.SetDrawColor(Color(0,0,0,255))
		draw.RoundedBox(5,ScrW()-ScrW()/1.85,ScrH()/2.05,ScrW()/8,ScrH()/14,Color(0,0,0,255),TEXT_ALIGN_LEFT)
		draw.DrawText(team.GetName(winner).." WIN!","Trebuchet24", ScrW()/2.1,ScrH()/2,team.GetColor(winner))
		end
		if LocalPlayer():Team() == 2 then
			local tr = LocalPlayer():GetEyeTrace().Entity
			if IsValid(tr) and tr:GetClass() == "player" then
				if tr:Team() == 2 then 
				draw.DrawText( "Friendly", "DermaDefault", ScrW()/2.05, ScrH()-ScrH()/1.8, Color(0,255,0,255), TEXT_ALIGN_LEFT )
				end
			end
		end
	end
end
 
function GM:Think()
	RunConsoleCommand("cl_drawhud", 0)
end
function GM:RenderScreenspaceEffects()
	if LocalPlayer():GetModel() == "models/player/zombie_fast.mdl" then
	DrawMaterialOverlay( "models/shadertest/shader4", 0.05 )
	else
	DrawMaterialOverlay("effects/combine_binocoverlay", 0)
	end
end
net.Receive( "TestForWin", function(len, ply)
		winner = net.ReadInt(3)
		stop = false
		timer.Simple(5,function() stop = true end)
end )
function testWin()
	if #player.GetHumans() > 1 then
		if #team.GetPlayers(1) == 0 then
			return 2
		elseif #team.GetPlayers(2) == 0 then
			return 1
		end
		return false
	end
return false
end
net.Receive( "SendTime", function( len, pl )
	time = net.ReadInt(32)
	print("The time is: "..time)
end )
function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end
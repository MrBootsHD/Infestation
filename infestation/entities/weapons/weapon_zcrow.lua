SWEP.PrintName = "Crowbar"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"
SWEP.Weight = 5
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 52
SWEP.CrosshairRadius = 5
SWEP.ReloadingTime = .5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = ""
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .02
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = .1
SWEP.ShouldDropOnDie = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
local ShootSound = Sound("Weapon_Crowbar.single")
function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	if(not self:CanPrimaryAttack())then
		return 
	end
	local ply = self:GetOwner()
	ply:LagCompensation(true)
	ply:LagCompensation(false)
end
function SWEP:CanSecondaryAttack()
	return false
end
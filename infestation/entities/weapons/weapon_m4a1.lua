SWEP.PrintName = "M4A1"
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.HoldType = "ar2"
SWEP.Weight = 5
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 52
SWEP.CrosshairRadius = 5
SWEP.ReloadingTime = .5
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1
SWEP.Primary.Damage = 7.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = .02
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = .1
SWEP.ShouldDropOnDie = true
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
local ShootSound = Sound("Weapon_ar2.Single")
function SWEP:Initialize()
	self:SetHoldType("ar2")
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
	local Bullet = {}
		Bullet.num = self.Primary.NumShots
		Bullet.src = ply:GetShootPos()
		Bullet.Dir = ply:GetAimVector()
		Bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0)
		Bullet.Tracer = 0
		Bullet.Damage = self.Primary.Damage
		Bullet.AmmoType = self.Primary.AmmoType
		self:ShootBullet( self.Primary.Damage , self.Primary.NumShots , self.Primary.Spread )
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.yaw = eyeang.yaw + self.Primary.Recoil/4
		eyeang.pitch = eyeang.pitch - self.Primary.Recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end
	self.Owner:ViewPunch( Angle( -.3, .2, 0 ) )
	self:ShootEffects()
	self:EmitSound(ShootSound)
	self.BaseClass.ShootEffects(self)
	self:TakePrimaryAmmo(1)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	ply:LagCompensation(false)
end
function SWEP:CanSecondaryAttack()
	return false
end
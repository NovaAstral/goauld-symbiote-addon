SWEP.PrintName = "Goa'uld Takeover"
SWEP.Author = "Nova Astral"
SWEP.Purpose = "Take over a players body"

SWEP.DrawCrosshair = false
SWEP.SlotPos = 1
SWEP.Slot = 0
SWEP.Weight = 1
SWEP.HoldType = "normal"
SWEP.Primary.Ammo = "none" --This stops it from giving pistol ammo when you get the hands
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.Category = "Stargate"
SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.HostPly = nil

function SWEP:DrawWorldModel() end
function SWEP:DrawWorldModelTranslucent() end
function SWEP:CanPrimaryAttack() return false end
function SWEP:CanSecondaryAttack() return false end

function SWEP:ShouldDropOnDie() return false end
function SWEP:PreDrawViewModel() return true end -- This stops it from displaying as a pistol in your hands

function SWEP:Initialize()
    timer.Simple(0.1,function()
        self.OwnPly = self:GetOwner() --probably not needed, fixes a nil issue if you have to kill the player with the swep
    end)
end

if SERVER then
    function SWEP:TakeOverTar(ply)
        if(ply ~= nil and IsValid(ply) and ply:IsPlayer() and self.OwnPly ~= nil) then
            self.OwnPly:SetPos(ply:GetPos())
            self.OwnPly:SetEyeAngles(ply:EyeAngles())
            self.OwnPly:SetModel(ply:GetModel())
            self.OwnPly:SetPlayerColor(ply:GetPlayerColor())

            ply:Spectate(OBS_MODE_IN_EYE)
            ply:SpectateEntity(self.OwnPly)
            ply.IsGoauldControlled = true
            ply.GoauldPly = self.OwnPly
            self.HostPly = ply --the host

            local Weps = ply:GetWeapons()

            for k,v in ipairs(Weps) do
                self.OwnPly:Give(v:GetClass())
            end

            ply:StripWeapons()
            ply:PrintMessage(4,"You have been taken over by a Goa'uld Symbiote") --Center of the screen
            ply:PrintMessage(3,"You have been taken over by a Goa'uld Symbiote") --Chat/Console
        end
    end

    function SWEP:PrimaryAttack()
        if(self.HostPly ~= nil) then return end --prevent any bugs if you already have a host, you must release your host first
        
        local tr = self:GetOwner():GetEyeTraceNoCursor()

        if(self:GetOwner():GetShootPos():Distance(tr.HitPos) <= 100 and IsValid(tr.Entity) and tr.Entity:IsPlayer()) then
            self:TakeOverTar(tr.Entity)
        end
    end

    function SWEP:SecondaryAttack()
        if(self.HostPly == nil) then return end

        self.HostPly:UnSpectate()
        self.HostPly.IsGoauldControlled = false

        self.HostPly:Spawn()
        self.HostPly = nil

        local pos = self.OwnPly:GetPos()
        local ang = self.OwnPly:EyeAngles()

        --easiest way to reset the player methinks
        self.OwnPly:Spawn()
        self.OwnPly:SetPos(pos)
        self.OwnPly:SetEyeAngles(ang)
        self.OwnPly:Give("goauld_takeover_tool")
    end
    

    function SWEP:Holster()
        if(self.IsSpectating == true) then
            return false
        else
            return true
        end
    end
end
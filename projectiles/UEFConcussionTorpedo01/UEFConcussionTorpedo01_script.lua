local TTorpedoSubProjectile = import('/lua/terranprojectiles.lua').TTorpedoSubProjectile

-- Terran Torpedo Bomb
---@class UEFConcussionTorpedo01 : TTorpedoSubProjectile
UEFConcussionTorpedo01 = Class(TTorpedoSubProjectile) {

    ---@param self UEFConcussionTorpedo01
    OnCreate = function(self)
        TTorpedoSubProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1)
        local mytarget = self:GetTrackingTarget()
        if EntityCategoryContains(categories.HOVER, mytarget) then
            self:ForkThread(self.MyTargetRangeCheck)
        end
    end,

    ---@param self UEFConcussionTorpedo01
    MyTargetRangeCheck = function(self)
        local mytarget = self:GetTrackingTarget()
        local targetpos = mytarget:GetPosition()
        local mypos = self:GetPosition()
        local distance = VDist3(mypos, targetpos)
        if distance < 2 then
            nukeProjectile = self:CreateProjectile('/mods/BlackOpsFAF-EXUnits/effects/Entities/EXCTorpEffectController01/EXCTorpEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)
        else
            WaitTicks(1)
            self:ForkThread(self.MyTargetRangeCheck)
        end
    end,

    ---@param self UEFConcussionTorpedo01
    ---@param TargetType string
    ---@param TargetEntity Entity
    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            nukeProjectile = self:CreateProjectile('/mods/BlackOpsFAF-EXUnits/effects/Entities/EXCTorpEffectController01/EXCTorpEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassData(self.Data)

        end
        TTorpedoSubProjectile.OnImpact(self, TargetType, TargetEntity)
    end,

}
TypeClass = UEFConcussionTorpedo01

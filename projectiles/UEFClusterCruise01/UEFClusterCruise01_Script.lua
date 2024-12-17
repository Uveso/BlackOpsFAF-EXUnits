local UEFClusterCruise01Projectile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsprojectiles.lua').UEFClusterCruise01Projectile
local EffectTemplate = import('/lua/EffectTemplates.lua')

---@class UEFClusterCruise01 : UEFClusterCruise01Projectile
UEFClusterCruise01 = Class(UEFClusterCruise01Projectile) {

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 1,
    FxPropHitScale = 1,
    FxProjectileHitScale = 1,
    FxProjectileUnderWaterHitScale = 1,
    FxShieldHitScale = 01,
    FxUnderWaterHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxOnKilledScale = 1,

    ---@param self UEFClusterCruise01
    OnCreate = function(self)
        UEFClusterCruise01Projectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.2)
        self:ForkThread(self.CruiseMissileThread)
    end,

    ---@param self UEFClusterCruise01
    CruiseMissileThread = function(self)
        self:SetTurnRate(180)
        WaitSeconds(2)
        self:SetTurnRate(180)
        WaitSeconds(1)
        self:SetTurnRate(360)
    end,

    ---@param self UEFClusterCruise01
    OnExitWater = function(self)
        UEFClusterCruise01Projectile.OnExitWater(self)
        self:SetDestroyOnWater(true)
    end,

}
TypeClass = UEFClusterCruise01
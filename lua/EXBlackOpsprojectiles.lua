--****************************************************************************
--**
--**  File     : /cdimage/lua/modules/BlackOpsprojectiles.lua
--**  Author(s): Lt_Hawkeye
--**
--**  Summary  :
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
--------------------------------------------------------------------------
--  Lt_hawkeye's Custom Projectiles
--------------------------------------------------------------------------
local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SingleBeamProjectile = DefaultProjectileFile.SingleBeamProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EXEffectTemplate = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsEffectTemplates.lua')

-- Null Shell
---@class EXNullShell : Projectile
EXNullShell = Class(Projectile) {}

-- PROJECTILE WITH ATTACHED EFFECT EMITTERS
---@class EXEmitterProjectile : Projectile
EXEmitterProjectile = Class(Projectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailScale = 1,
    FxTrailOffset = 0,

    OnCreate = function(self)
        Projectile.OnCreate(self)
        local army = self.Army
        for i in self.FxTrails do
            CreateEmitterOnEntity(self, army, self.FxTrails[i]):ScaleEmitter(self.FxTrailScale):OffsetEmitter(0, 0, self.FxTrailOffset)
        end
    end,
}

-- BEAM PROJECTILES
---@class EXSingleBeamProjectile : EXEmitterProjectile
EXSingleBeamProjectile = Class(EXEmitterProjectile) {

    BeamName = '/effects/emitters/default_beam_01_emit.bp',
    FxTrails = {},

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.BeamName then
            CreateBeamEmitterOnEntity(self, -1, self.Army, self.BeamName)
        end
    end,
}

---@class EXMultiBeamProjectile : EXEmitterProjectile
EXMultiBeamProjectile = Class(EXEmitterProjectile) {

    Beams = {'/effects/emitters/default_beam_01_emit.bp',},
    FxTrails = {},

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        local army = self.Army
        for _, v in self.Beams do
            CreateBeamEmitterOnEntity(self, -1, army, v)
        end
    end,
}

-- POLY-TRAIL PROJECTILES
---@class EXSinglePolyTrailProjectile : EXEmitterProjectile
EXSinglePolyTrailProjectile = Class(EXEmitterProjectile) {

    PolyTrail = '/effects/emitters/test_missile_trail_emit.bp',
    PolyTrailOffset = 0,
    FxTrails = {},

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.PolyTrail != '' then
            CreateTrail(self, -1, self.Army, self.PolyTrail):OffsetEmitter(0, 0, self.PolyTrailOffset)
        end
    end,
}

---@class EXMultiPolyTrailProjectile : EXEmitterProjectile
EXMultiPolyTrailProjectile = Class(EXEmitterProjectile) {

    PolyTrailOffset = {0},
    FxTrails = {},
    RandomPolyTrails = 0,   -- Count of how many are selected randomly for PolyTrail table

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.PolyTrails then
            local NumPolyTrails = table.getn(self.PolyTrails)
            local army = self.Army

            if self.RandomPolyTrails != 0 then
                local index = nil
                for i = 1, self.RandomPolyTrails do
                    index = math.floor(Random(1, NumPolyTrails))
                    CreateTrail(self, -1, army, self.PolyTrails[index]):OffsetEmitter(0, 0, self.PolyTrailOffset[index])
                end
            else
                for i = 1, NumPolyTrails do
                    CreateTrail(self, -1, army, self.PolyTrails[i]):OffsetEmitter(0, 0, self.PolyTrailOffset[i])
                end
            end
        end
    end,
}


-----------------------------------------------------------------
-- COMPOSITE EMITTER PROJECTILES - MULTIPURPOSE PROJECTILES
-- - THAT COMBINES BEAMS, POLYTRAILS, AND NORMAL EMITTERS
-----------------------------------------------------------------

-- LIGHTWEIGHT VERSION THAT LIMITS USE TO 1 BEAM, 1 POLYTRAIL, AND STANDARD EMITTERS
---@class EXSingleCompositeEmitterProjectile : EXSinglePolyTrailProjectile
EXSingleCompositeEmitterProjectile = Class(EXSinglePolyTrailProjectile) {

    BeamName = '/effects/emitters/default_beam_01_emit.bp',
    FxTrails = {},

    OnCreate = function(self)
        SinglePolyTrailProjectile.OnCreate(self)
        if self.BeamName != '' then
            CreateBeamEmitterOnEntity(self, -1, self.Army, self.BeamName)
        end
    end,
}

-- HEAVYWEIGHT VERSION, ALLOWS FOR MULTIPLE BEAMS, POLYTRAILS, AND STANDARD EMITTERS
---@class EXMultiCompositeEmitterProjectile : EXMultiPolyTrailProjectile
EXMultiCompositeEmitterProjectile = Class(EXMultiPolyTrailProjectile) {

    Beams = {'/effects/emitters/default_beam_01_emit.bp',},
    PolyTrailOffset = {0},
    RandomPolyTrails = 0,   -- Count of how many are selected randomly for PolyTrail table
    FxTrails = {},

    OnCreate = function(self)
        MultiPolyTrailProjectile.OnCreate(self)
        local army = self.Army
        for _, v in self.Beams do
            CreateBeamEmitterOnEntity(self, -1, army, v)
        end
    end,
}

--  Custom Projectiles
---@class EXBlackOpsNukeProjectile : SingleBeamProjectile
UEFClusterCruise01Projectile = Class(SingleBeamProjectile) {
    DestroyOnImpact = false,
    FxTrails = EXEffectTemplate.UEFCruiseMissile01Trails,
    FxTrailOffset = -0.3,
    FxTrailScale = 1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},

    ---@param self EXBlackOpsNukeProjectile
    ---@param targetType string
    ---@param targetEntity Entity
    OnImpact = function(self, targetType, targetEntity)
        SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
    end,

    ---@param self EXBlackOpsNukeProjectile
    ---@param army Army
    ---@param EffectTable table
    ---@param EffectScale number
    CreateImpactEffects = function(self, army, EffectTable, EffectScale)
        local emit = nil
        for _, v in EffectTable do
            emit = CreateEmitterAtEntity(self,army,v)
            if emit and EffectScale != 1 then
                emit:ScaleEmitter(EffectScale or 1)
            end
        end
    end,
}

---@class EXBlackOpsNukeProjectile : SinglePolyTrailProjectile
UEFHeavyPlasmaGatlingCannon01 = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactProp = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactLand = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactShield = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.THeavyPlasmaGatlingCannonFxTrails,
    PolyTrail = EffectTemplate.THeavyPlasmaGatlingCannonPolyTrail,
}

---@class EXBlackOpsNukeProjectile : EmitterProjectile
UEFHVM01Projectile = Class(EmitterProjectile) {
    FxInitial = {},
    TrailDelay = 0.3,
    FxTrails = EXEffectTemplate.UEFHVM01Trails,
    FxTrailOffset = -0.3,
    FxTrailScale = 4,

    FxAirUnitHitScale = 0.4,
    FxLandHitScale = 0.4,
    FxUnitHitScale = 0.4,
    FxPropHitScale = 0.4,
    FxImpactUnit = EffectTemplate.TMissileHit02,
    FxImpactAirUnit = EffectTemplate.TMissileHit02,
    FxImpactProp = EffectTemplate.TMissileHit02,
    FxImpactLand = EffectTemplate.TMissileHit02,
    FxImpactUnderWater = {},
}

---@class UEFCruiseMissile01Projectile : SingleBeamProjectile
UEFCruiseMissile01Projectile = Class(SingleBeamProjectile) {
    DestroyOnImpact = false,
    FxTrails = EXEffectTemplate.UEFCruiseMissile01Trails,
    FxTrailOffset = -0.3,
    FxTrailScale = 1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},

    ---@param self UEFCruiseMissile01Projectile
    ---@param targetType string
    ---@param targetEntity Entity
    OnImpact = function(self, targetType, targetEntity)
        SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
    end,

    ---@param self UEFCruiseMissile01Projectile
    ---@param army Army
    ---@param EffectTable table
    ---@param EffectScale number
    CreateImpactEffects = function(self, army, EffectTable, EffectScale)
        local emit = nil
        for _, v in EffectTable do
            emit = CreateEmitterAtEntity(self,army,v)
            if emit and EffectScale != 1 then
                emit:ScaleEmitter(EffectScale or 1)
            end
        end
    end,
}

--  AEON RAIDER CANNON PROJECTILES
---@class RaiderCannonProjectile : SinglePolyTrailProjectile
RaiderCannonProjectile = Class(SinglePolyTrailProjectile) {
    FxTrails = {
        '/effects/emitters/reacton_cannon_fxtrail_01_emit.bp',
        '/effects/emitters/reacton_cannon_fxtrail_02_emit.bp',
        '/effects/emitters/reacton_cannon_fxtrail_03_emit.bp',
        '/mods/BlackOpsFAF-EXUnits/effects/emitters/raider_cannon_01_emit.bp',
        '/mods/BlackOpsFAF-EXUnits/effects/emitters/raider_cannon_02_emit.bp',
    },
    PolyTrail = '/effects/emitters/aeon_commander_overcharge_trail_01_emit.bp',

    FxImpactUnit = EffectTemplate.AReactonCannonHitUnit01,
    FxImpactProp = EffectTemplate.AReactonCannonHitUnit01,
    FxImpactLand = EffectTemplate.AReactonCannonHitLand01,
}

--  Cybran Hailfire Projectiles
---@class CybranHailfire01Projectile : SinglePolyTrailProjectile
CybranHailfire01ChildProjectile = Class(SinglePolyTrailProjectile) {
    PolyTrail = '/effects/emitters/default_polytrail_05_emit.bp',
    FxTrails = EXEffectTemplate.CybranHailfire02FXTrails,
    FxTrailOffset = -0.3,
    FxTrailScale = 0.005,

    -- Hit Effects
    FxImpactUnit = EXEffectTemplate.CybranHailfire01HitUnit01,
    FxImpactProp = EXEffectTemplate.CybranHailfire01HitUnit01,
    FxImpactLand = EXEffectTemplate.CybranHailfire01HitLand01,
    FxImpactWater = EXEffectTemplate.CybranHailfire01HitWater01,
    FxImpactShield = EXEffectTemplate.CybranHailfire01HitWater01,
    FxImpactUnderWater = {},
    FxLandHitScale = 4,
    FxUnitHitScale = 4,
    FxPropHitScale = 4,
    FxWaterHitScale = 4,
    FxShieldHitScale = 2,
}

---@class CybranHailfire01Projectile : SinglePolyTrailProjectile
CybranHailfire02Projectile = Class(SinglePolyTrailProjectile) {
    FxTrails = EXEffectTemplate.CybranHailfire01FXTrails,
    FxTrailOffset = -0.3,
    FxTrailScale = 0.05,
    FxImpactTrajectoryAligned = false,

    PolyTrail = EffectTemplate.CNanoDartPolyTrail01,

    -- Hit Effects
    FxImpactProp = EffectTemplate.CNanoDartUnitHit01,
    FxImpactUnit = EffectTemplate.CNanoDartUnitHit01,
    FxImpactLand = EffectTemplate.CNanoDartLandHit01,
    FxImpactShield = EffectTemplate.CNanoDartLandHit01,
    FxImpactWater = {},
    FxImpactUnderWater = {},
    FxLandHitScale = 2,
    FxUnitHitScale = 2,
    FxPropHitScale = 2,
    FxWaterHitScale = 2,
    FxShieldHitScale = 2,
}

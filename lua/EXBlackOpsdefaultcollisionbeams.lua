------------------------------------------------------------------------
-- File     :  /lua/defaultcollisionbeams.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Default definitions collision beams
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------
local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local EXEffectTemplate = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsEffectTemplates.lua')
local EXCollisionBeam = import('/mods/BlackOpsFAF-EXUnits/lua/EXCollisionBeam.lua').CollisionBeam

local TrashBagAdd = TrashBag.Add

--- Base class that defines supreme commander specific defaults
---@class SCCollisionBeam : CollisionBeam
SCCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},
    FxImpactNone = {},
}

--- UEF Sonic Disruptor Wave
---@class SonicDisruptorWaveCBeam : EXCollisionBeam
SonicDisruptorWaveCBeam = Class(EXCollisionBeam) {
    TerrainImpactType = 'LargeBeam02',

    FxBeamStartPoint = EXEffectTemplate.SonicDisruptorWaveMuzzle,
    FxBeam = EXEffectTemplate.SonicDisruptorWaveBeam01,
    FxBeamEndPoint = EXEffectTemplate.SonicDisruptorWaveHit,

    FxBeamStartPointScale = 0.5,
    FxBeamEndPointScale = 0.5,
    TerrainImpactScale = 0.2,

    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,
}

---@class CybranBeamWeapons : SCCollisionBeam
CybranBeamWeapons = Class(SCCollisionBeam) {
    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/effects/emitters/microwave_laser_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    ---@param self CybranBeamWeapons
    ---@param impactType string
    ---@param targetEntity Entity
    OnImpact = function(self, impactType, targetEntity)
        local trash = self.Trash
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = TrashBagAdd(trash, ForkThread(self.ScorchThread, self))
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    ---@param self CybranBeamWeapons
    OnDisable = function(self)
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil
    end,

    ---@param self CybranBeamWeapons
    ScorchThread = function(self)
        local army = self.Army
        local size = 0.5 + (Random() * 1.5)
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors(CurrentPosition, LastPosition) > 0.25 or skipCount > 100 then
                CreateSplat(CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army)
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end

            WaitSeconds(self.ScorchSplatDropTime)
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

---@class CybranSSBeam : CybranBeamWeapons
CybranSSBeam = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.25,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/BlackOpsFAF-EXUnits/effects/emitters/exss_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.5,
    FxBeamEndPointScale = 0.5,
}

---@class CybranAriesBeam01 : CybranBeamWeapons
CybranAriesBeam01 = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.5,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/BlackOpsFAF-EXUnits/effects/emitters/exaries_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.75,
    FxBeamEndPointScale = 0.75,
}
------------------------------------------------------------------------
-- File     :  /cdimage/lua/modules/BlackOpsweapons.lua
-- Author(s):  Lt_hawkeye
-- Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local DefaultProjectileWeapon = WeaponFile.DefaultProjectileWeapon
local DefaultBeamWeapon = WeaponFile.DefaultBeamWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EXCollisionBeamFile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsdefaultcollisionbeams.lua')
local EXEffectTemplate = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsEffectTemplates.lua')

--- UEF Sonic Disruptor Wave
---@class SonicDisruptorWave : DefaultBeamWeapon
SonicDisruptorWave = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.SonicDisruptorWaveCBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,

    ---@param self SonicDisruptorWave
    PlayFxWeaponUnpackSequence = function(self)
        if not self.ContBeamOn then
            local army = self.unit.Army
            local bp = self.Blueprint
            for _, v in self.FxUpackingChargeEffects do
                for _, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

--- UEF Sub Gatling Cannon
---@class UEFSubGatlingCannonWeapon : DefaultProjectileWeapon
UEFACUHeavyPlasmaGatlingCannonWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EXEffectTemplate.UEFACUHeavyPlasmaGatlingCannonMuzzleFlash,
    FxMuzzleFlashScale = 0.35,
}

--- Cybran ShadowSplitter Beam
---@class CybranShadowSplitterBeam : DefaultBeamWeapon
CybranShadowSplitterBeam = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.CybranSSBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    ---@param self CybranShadowSplitterBeam
    PlayFxWeaponUnpackSequence = function(self)
        if not self:EconomySupportsBeam() then return end
        local army = self.unit.Army
        local bp = self.Blueprint
        for _, v in self.FxUpackingChargeEffects do
            for _, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

---@class CybranAriesBeam : DefaultBeamWeapon
CybranAriesBeam = Class(DefaultBeamWeapon) {
    BeamType = EXCollisionBeamFile.CybranAriesBeam01,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    ---@param self CybranAriesBeam
    PlayFxWeaponUnpackSequence = function(self)
        if not self:EconomySupportsBeam() then return end
        local army = self.unit.Army
        local bp = self.Blueprint
        for _, v in self.FxUpackingChargeEffects do
            for _, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
            end
        end
        DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
    end,
}

--- Cybran Hailfire
---@class HailfireLauncherWeapon : DefaultProjectileWeapon
HailfireLauncherWeapon = Class(DefaultProjectileWeapon) {
    FxMuzzleFlash = EXEffectTemplate.HailfireLauncherExhaust,
}
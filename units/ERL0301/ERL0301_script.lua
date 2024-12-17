--****************************************************************************
--**
--**  File     :  /cdimage/units/DRL0204/DRL0204_script.lua
--**  Author(s):  Dru Staltman, Eric Williamson, Gordon Duclos
--**
--**  Summary  :  Cybran Rocket Bot Script
--**
--**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CybranWeaponsFile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsweapons.lua')
local CybranShadowSplitterBeam = CybranWeaponsFile.CybranShadowSplitterBeam
local EffectUtil = import('/lua/EffectUtilities.lua')

---@class ERl0301 : CWalkingLandUnit
ERL0301 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CybranShadowSplitterBeam) {
            OnWeaponFired = function(self)
                if self.unit:IsIntelEnabled('Cloak') then
                    self:ForkThread(self.DecloakForTimeout)
                end
            end,

            DecloakForTimeout = function(self)
                self.unit:DisableUnitIntel('weaponfire', 'Cloak')
                WaitSeconds(self.unit:GetBlueprint().Intel.RecloakAfterFiringDelay or 10)
                self.unit:EnableUnitIntel('weaponfire', 'Cloak')
            end,
        },
    },

    ---@param self ERl0301
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        -- bit hacky, but otherwise the shader doesn't apply properly
        self:DisableUnitIntel('start', 'Cloak')
        self:DisableUnitIntel('start', 'RadarStealth')
        self:EnableUnitIntel('start', 'Cloak')
        self:EnableUnitIntel('start', 'RadarStealth')
        self.IntelEffectsBag = {}
    end,

    ---@param self ERL0301
    ---@param bit number
    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('toggle', 'Cloak')
            self:DisableUnitIntel('toggle', 'RadarStealth')
        end
    end,

    ---@param self ERL0301
    ---@param bit number
    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('toggle', 'Cloak')
            self:EnableUnitIntel('toggle', 'RadarStealth')
        end
    end,

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'ERL302',
                },
                Scale = 2.0,
                Type = 'Cloak01',
            },
        },
        Field = {
            {
                Bones = {
                    'ERL302',
                },
                Scale = 1.6,
                Type = 'Cloak01',
            },
        },
    },

    ---@param self ERL0301
    ---@param intel string
    OnIntelEnabled = function(self, intel)
        CWalkingLandUnit.OnIntelEnabled(self, intel)
        if self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end
        end
    end,

    ---@param self ERL0301
    ---@param intel string
    OnIntelDisabled = function(self, intel)
        CWalkingLandUnit.OnIntelDisabled(self, intel)
        if self.IntelEffectsBag then
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelEffectsBag = nil
        end
        if not self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionInactive()
        end
    end,

}
TypeClass = ERL0301

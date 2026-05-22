local addonName, addon = ...
local module = addon:CreateModule("Unit Frames")

module.defaultSettings = {
    x = 350,
    y = 100,
    scale = 1,
    frameSpacing = 20,
    statusTextScale = 1,
    classColors = true,
    hideNames = false
}

module.optionsTable = {
    scale = {
        order = 1,
        type = "range",
        name = "Scale",
        min = 0.1,
        max = 5.0,
        step = 0.1,
        set = module.UpdateSettings
    },
    frameSpacing = {
        order = 2,
        type = "range",
        name = "Spacing",
        min = -100,
        max = 100,
        softMin = -100,
        softMax = 100,
        step = 1,
        set = module.UpdateSettings
    },
    hideNames = {
        order = 5,
        type = "toggle",
        name = "Hide names",
        set = module.UpdateSettings
    },
    classColors = {
        order = 6,
        type = "toggle",
        name = "Class-colored health bars",
        width = "full"
    }
}

local hiddenFrame = CreateFrame("Frame", nil, UIParent)
hiddenFrame:Hide()

local dummyFrame = CreateFrame("Frame", nil, UIParent)
local sArenaEnemyFrames = ArenaEnemyFrames

sArenaEnemyFrames:Hide()
sArenaEnemyFrames:SetMovable(true)
ArenaEnemyFrames = dummyFrame

sArenaEnemyFrames.GetParent = function() return UIParent end

sArenaEnemyFrames.isManagedFrame = false
sArenaEnemyFrames.isRightManagedFrame = false

sArenaEnemyFrames.layoutParent = {
    AddManagedFrame = function() end,
    RemoveManagedFrame = function() end
}

if UIParentRightManagedFrameContainer and UIParentRightManagedFrameContainer.RemoveManagedFrame then
    UIParentRightManagedFrameContainer:RemoveManagedFrame(sArenaEnemyFrames)
end

local firstPlayerEnteringWorld = false

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return
    end

    if event == "ADDON_LOADED" then
        for i = 1, MAX_ARENA_ENEMIES do
            local arenaFrame = _G["ArenaEnemyFrame" .. i]
            if arenaFrame then
                addon:SetupDrag(module, true, arenaFrame, sArenaEnemyFrames)
                addon:SetupDrag(module, true, arenaFrame.healthbar, sArenaEnemyFrames)
                addon:SetupDrag(module, true, arenaFrame.manabar, sArenaEnemyFrames)
            end
        end
        self:OnEvent("UPDATE_SETTINGS")

    elseif event == "PLAYER_ENTERING_WORLD" then
        if not firstPlayerEnteringWorld then
            sArenaEnemyFrames:Show()
            firstPlayerEnteringWorld = true
        end

    elseif event == "TEST_MODE" then
        for i = 1, 3 do
            local arenaFrame = _G["ArenaEnemyFrame" .. i]
            if arenaFrame then
                if addon.testMode then
                    arenaFrame.healthbar:SetMinMaxValues(0, 100)
                    arenaFrame.healthbar:SetValue(100)
                    arenaFrame.healthbar.forceHideText = false
                    arenaFrame.manabar:SetMinMaxValues(0, 100)
                    arenaFrame.manabar:SetValue(100)
                    arenaFrame.manabar:SetStatusBarColor(0, 0, 1)
                    arenaFrame.manabar.forceHideText = false
                    ArenaEnemyFrame_SetMysteryPlayer(arenaFrame)
                    arenaFrame.name:SetText("arena" .. i)
                    arenaFrame:Show()
                else
                    arenaFrame:Hide()
                end
            end
        end

    elseif event == "UPDATE_SETTINGS" then
        if not sArenaEnemyFrames then return end
        
        sArenaEnemyFrames:ClearAllPoints()
        sArenaEnemyFrames:SetPoint("CENTER", UIParent, "CENTER", self.db.x or 0, self.db.y or 0)
        sArenaEnemyFrames:SetScale(self.db.scale or 1)
        
        for i = 1, MAX_ARENA_ENEMIES do
            local arenaFrame = _G["ArenaEnemyFrame" .. i]
            if arenaFrame then
                arenaFrame.name:SetShown(not self.db.hideNames)
                arenaFrame:ClearAllPoints()
                if i == 1 then
                    arenaFrame:SetPoint("TOPLEFT", sArenaEnemyFrames, "TOPLEFT", 0, 0)
                else
                    arenaFrame:SetPoint("TOP", _G["ArenaEnemyFrame" .. i - 1], "BOTTOM", 0, (self.db.frameSpacing or 10) * -1)
                end
            end
        end
    end
end

-- Class colored health bars
local healthBars = {
    ArenaEnemyFrame1HealthBar = 1,
    ArenaEnemyFrame2HealthBar = 1,
    ArenaEnemyFrame3HealthBar = 1,
    ArenaEnemyFrame4HealthBar = 1,
    ArenaEnemyFrame5HealthBar = 1
}

local UnitClass = UnitClass
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local function colorStatusBar(statusbar)
    if module.db.classColors and healthBars[statusbar:GetName()] then
        local _, class = UnitClass(statusbar.unit)
        if class then
            local c = RAID_CLASS_COLORS[class]
            if not statusbar.lockColor then
                statusbar:SetStatusBarColor(c.r, c.g, c.b)
            end
        end
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colorStatusBar)
hooksecurefunc("HealthBar_OnValueChanged", colorStatusBar)

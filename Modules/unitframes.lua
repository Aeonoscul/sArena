local addonName, addon = ...
local module = addon:CreateModule("Unit Frames")

module.defaultSettings = {
    x = 350,
    y = 100,
    scale = 1.3,
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

-- ---------------------------------------------------------------------------
-- Frame takeover (runs at file load)
-- ---------------------------------------------------------------------------

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

-- ---------------------------------------------------------------------------
-- Event handlers
-- ---------------------------------------------------------------------------

local function HandleADDON_LOADED()
    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        if arenaFrame then
            addon:SetupDrag(module, true, arenaFrame, sArenaEnemyFrames)
            addon:SetupDrag(module, true, arenaFrame.healthbar, sArenaEnemyFrames)
            addon:SetupDrag(module, true, arenaFrame.manabar, sArenaEnemyFrames)
        end
    end
end

local function HandlePLAYER_ENTERING_WORLD()
    if not firstPlayerEnteringWorld then
        sArenaEnemyFrames:Show()
        firstPlayerEnteringWorld = true
    end
end

local function HandleTEST_MODE()
    local testClasses = {"WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "DRUID"}
    
    for i = 1, 3 do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        if arenaFrame then
            if addon.testMode then
                ArenaEnemyFrame_SetMysteryPlayer(arenaFrame)

                arenaFrame.healthbar.lockColor = true
                arenaFrame.manabar.lockColor = true

                local randomClass = testClasses[math.random(1, #testClasses)]
                local c = RAID_CLASS_COLORS[randomClass]
                
                local r, g, b = 0.5, 0.5, 0.5
                if c then
                    r, g, b = c.r, c.g, c.b
                end
                
                arenaFrame.healthbar:SetMinMaxValues(0, 100)
                arenaFrame.healthbar:SetValue(100)
                arenaFrame.healthbar:SetStatusBarColor(r, g, b)
                arenaFrame.healthbar.forceHideText = false
                
                if arenaFrame.classPortrait then
                    arenaFrame.classPortrait:SetTexture("Interface/TargetingFrame/UI-Classes-Circles")
                    local coords = CLASS_ICON_TCOORDS[randomClass]
                    if coords then
                        arenaFrame.classPortrait:SetTexCoord(unpack(coords))
                    else
                        arenaFrame.classPortrait:SetTexCoord(0, 1, 0, 1)
                    end
                    arenaFrame.classPortrait:SetVertexColor(1, 1, 1, 1)
                end

                arenaFrame.manabar:SetMinMaxValues(0, 100)
                arenaFrame.manabar:SetValue(100)
                arenaFrame.manabar:SetStatusBarColor(0, 0, 1)
                arenaFrame.manabar.forceHideText = false
                
                arenaFrame.name:SetText("arena" .. i)
                arenaFrame:Show()
            else
                arenaFrame.healthbar.lockColor = false
                arenaFrame.manabar.lockColor = false
                if arenaFrame.classPortrait then
                    arenaFrame.classPortrait:SetVertexColor(1, 1, 1, 1)
                end
                arenaFrame:Hide()
            end
        end
    end
end

local function HandleUPDATE_SETTINGS()
    if not sArenaEnemyFrames then return end
    
    sArenaEnemyFrames:ClearAllPoints()
    sArenaEnemyFrames:SetPoint("CENTER", UIParent, "CENTER", module.db.x or 0, module.db.y or 0)
    sArenaEnemyFrames:SetScale(module.db.scale or 1)
    
    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        if arenaFrame then
            arenaFrame.name:SetShown(not module.db.hideNames)
            arenaFrame:ClearAllPoints()
            if i == 1 then
                arenaFrame:SetPoint("TOPLEFT", sArenaEnemyFrames, "TOPLEFT", 0, 0)
            else
                arenaFrame:SetPoint("TOP", _G["ArenaEnemyFrame" .. i - 1], "BOTTOM", 0, (module.db.frameSpacing or 10) * -1)
            end
        end
    end
end

-- ---------------------------------------------------------------------------
-- Module event dispatcher
-- ---------------------------------------------------------------------------

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return
    end

    if event == "ADDON_LOADED" then
        HandleADDON_LOADED()
        self:OnEvent("UPDATE_SETTINGS")

    elseif event == "PLAYER_ENTERING_WORLD" then
        HandlePLAYER_ENTERING_WORLD()

    elseif event == "TEST_MODE" then
        HandleTEST_MODE()

    elseif event == "UPDATE_SETTINGS" then
        HandleUPDATE_SETTINGS()
    end
end

-- ---------------------------------------------------------------------------
-- Class-colored health bars (hooks)
-- ---------------------------------------------------------------------------

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
    if statusbar.lockColor then return end
    
    if module.db.classColors and healthBars[statusbar:GetName()] then
        local _, class = UnitClass(statusbar.unit)
        if class then
            local c = RAID_CLASS_COLORS[class]
            statusbar:SetStatusBarColor(c.r, c.g, c.b)
        end
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colorStatusBar)
hooksecurefunc("HealthBar_OnValueChanged", colorStatusBar)
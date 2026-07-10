local addonName, addon = ...
local module = addon:CreateModule("Pet Frames")
local Media = LibStub("LibSharedMedia-3.0")

module.defaultSettings = {
    x = -23,
    y = -25,
    scale = 1,
    healthBarWidth = 50,
    healthBarHeight = 14,
    powerBarHeight = 8,
    barTexture = "Interface\\AddOns\\sArena\\Media\\statusbar",
    frameSpacing = 21
}

module.optionsTable = {
    enable = {
        order = 1,
        type = "toggle",
        name = addon.exclamation .. "Enable",
        desc = "|cffff5555NOTICE:|r Changing this setting will cause a UI reload.",
        get = function()
            return GetCVar("showArenaEnemyPets") == "1" and true or false
        end,
        set = function(info, val)
            SHOW_ARENA_ENEMY_PETS = val and 1 or 0
            SetCVar("showArenaEnemyPets", val and 1 or 0)
        end
    },
    barTexture = {
        order = 2,
        type = "select",
        name = "Bar Textures",
        values = function()
            local list = {}
            local mediaList = Media:List("statusbar")
            for _, name in ipairs(mediaList) do
                list[Media:Fetch("statusbar", name)] = name
            end
            return list
        end,
        set = module.UpdateSettings
    },
    break1 = {
        order = 3,
        type = "header",
        name = ""
    },
    scale = {
        order = 4,
        type = "range",
        name = "Scale",
        min = 0.1,
        max = 5.0,
        step = 0.1,
        set = module.UpdateSettings
    },
    healthBarWidth = {
        order = 5,
        name = "Width",
        type = "range",
        min = 40,
        max = 200,
        step = 1,
        set = module.UpdateSettings
    },
    healthBarHeight = {
        order = 6,
        name = "Health Bar Height",
        type = "range",
        min = 1,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    powerBarHeight = {
        order = 7,
        name = "Power Bar Height",
        type = "range",
        min = 1,
        max = 50,
        step = 1,
        set = module.UpdateSettings
    },
    frameSpacing = {
        order = 8,
        type = "range",
        name = "Spacing",
        min = -100,
        max = 100,
        softMin = -100,
        softMax = 100,
        step = 1,
        set = module.UpdateSettings
    }
}

local dummyFrame = CreateFrame("Frame", nil, UIParent)

local sArenaEnemyFrames = ArenaEnemyFrames
sArenaEnemyFrames:Hide()
sArenaEnemyFrames:SetMovable(true)

ArenaEnemyFrames = dummyFrame

for i = 1, MAX_ARENA_ENEMIES do
    local arenaFrame = _G["ArenaEnemyFrame" .. i]
    local petFrame = arenaFrame.petFrame

    petFrame:SetParent(arenaFrame)
    petFrame:SetMovable(true)

    addon:SetupDrag(module, true, petFrame)
    addon:SetupDrag(module, true, petFrame.healthbar, petFrame)
    addon:SetupDrag(module, true, petFrame.manabar, petFrame)
end

local function ProtectBar(bar, barTexture)
    if not bar then
        return
    end
    bar:SetStatusBarTexture(barTexture)
    local tex = bar:GetStatusBarTexture()
    if tex then
        if not tex.Hooked then
            tex:SetTexCoord(0, 1, 0, 1)
            tex.SetTexCoord = function()
            end
            tex.Hooked = true
        else
            tex:SetTexCoord(0, 1, 0, 1)
        end
    end
end

local function PositionFrames()
    if InCombatLockdown() then
        return
    end

    local visiblePets = {}
    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        if arenaFrame then
            local petFrame = arenaFrame.petFrame
            if petFrame and petFrame:IsShown() then
                table.insert(visiblePets, {
                    frame = petFrame,
                    index = i,
                    arena = arenaFrame
                })
            end
        end
    end

    if #visiblePets == 0 then
        return
    end

    table.sort(visiblePets, function(a, b)
        return a.index < b.index
    end)

    local first = visiblePets[1]
    first.frame:ClearAllPoints()
    first.frame:SetPoint("CENTER", first.arena, "CENTER", module.db.x, module.db.y)

    for idx = 2, #visiblePets do
        local curr = visiblePets[idx].frame
        local prev = visiblePets[idx - 1].frame

        curr:ClearAllPoints()
        curr:SetPoint("LEFT", first.frame, "LEFT", 0, 0)
        curr:SetPoint("TOP", prev, "BOTTOM", 0, -module.db.frameSpacing)
    end
end

-- ---------------------------------------------------------------------------
-- Event handlers
-- ---------------------------------------------------------------------------

local function HandleTEST_MODE(petFrame)
    if addon.testMode and GetCVar("showArenaEnemyPets") == "1" then
        petFrame.healthbar.lockColor = true
        petFrame.healthbar:SetMinMaxValues(0, 100)
        petFrame.healthbar:SetValue(100)
        petFrame.healthbar:SetStatusBarColor(0, 1, 0)
        petFrame.healthbar.forceHideText = false
        petFrame:Show()
        PositionFrames()
    else
        petFrame.healthbar.lockColor = false
    end
end

local function HandleUPDATE_SETTINGS(petFrame, arenaFrame)
    if InCombatLockdown() then
        return
    end

    petFrame:SetScale(module.db.scale)
    ProtectBar(petFrame.healthbar, module.db.barTexture)

    if not petFrame.isMoving then
        petFrame:ClearAllPoints()
        PositionFrames()
    end

    if arenaFrame.texture then
        local frameStylesModule = addon.modules["Frame Styles"] or addon.modules["Unit Frames"]
        if frameStylesModule and frameStylesModule.db then
            local currentLayout = addon.layouts[frameStylesModule.db.frameStyle]
            if currentLayout and currentLayout.SetFrameStyle then
                currentLayout:SetFrameStyle(arenaFrame, frameStylesModule.db)
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

    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        local petFrame = arenaFrame and arenaFrame.petFrame

        if petFrame then
            if event == "TEST_MODE" then
                HandleTEST_MODE(petFrame)
            elseif event == "UPDATE_SETTINGS" or event == "PLAYER_ENTERING_WORLD" then
                HandleUPDATE_SETTINGS(petFrame, arenaFrame)
            end

        end
    end
end

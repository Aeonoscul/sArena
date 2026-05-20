local addonName, addon = ...
local module = addon:CreateModule("Pet Frames")
local Media = LibStub("LibSharedMedia-3.0")

module.defaultSettings = {
    x = -6,
    y = -24,
    scale = 1,
    healthBarWidth = 50,
    healthBarHeight = 14,
    powerBarHeight = 8,
    barTexture = "Blizzard",
    frameSpacing = 20
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
    --petFrame:SetFrameLevel(1)

    addon:SetupDrag(module, true, petFrame)
    addon:SetupDrag(module, true, petFrame.healthbar, petFrame)
    addon:SetupDrag(module, true, petFrame.manabar, petFrame)
end

function module:OnEvent(event, ...)
    local maxWidth = (self.db.healthBarWidth)
    local maxHeight = (self.db.healthBarHeight + self.db.powerBarHeight)

    if event == "UNIT_AURA" then
        return;
    end

    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        local petFrame = arenaFrame.petFrame

        if event == "TEST_MODE" then
            if addon.testMode and GetCVar("showArenaEnemyPets") == "1" then
                petFrame:Show()
            else
                petFrame:Hide()
            end

        elseif event == "UPDATE_SETTINGS" then
            petFrame:ClearAllPoints()
            petFrame:SetPoint("CENTER", self.db.x, self.db.y)
            petFrame:SetScale(self.db.scale)

            petFrame.healthbar:SetStatusBarTexture(self.db.barTexture)
            petFrame.manabar:SetStatusBarTexture(self.db.barTexture)

            for j = 1, MAX_ARENA_ENEMIES do
                local currentPetFrame = _G["ArenaEnemyFrame" .. j].petFrame
                if j > 1 then
                    local prevPetFrame = _G["ArenaEnemyFrame" .. (j - 1)].petFrame
                    currentPetFrame:ClearAllPoints()
                    currentPetFrame:SetPoint("TOP", prevPetFrame, "BOTTOM", 0, self.db.frameSpacing * -1)
                end
            end
        end
    end

    if event == "ADDON_LOADED" then
        self:OnEvent("UPDATE_SETTINGS")
    end
end

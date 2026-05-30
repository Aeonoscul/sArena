local addonName, addon = ...
local module = addon:CreateModule("Pet Frames")
local Media = LibStub("LibSharedMedia-3.0")

module.defaultSettings = {
    x = -22,
    y = -42,
    scale = 0.7,
    healthBarWidth = 50,
    healthBarHeight = 14,
    powerBarHeight = 8,
    barTexture = "Interface\\AddOns\\sArena\\Media\\statusbar",
    frameSpacing = 0,
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
    if not bar then return end
    bar:SetStatusBarTexture(barTexture)
    local tex = bar:GetStatusBarTexture()
    if tex then
        if not tex.Hooked then
            tex:SetTexCoord(0, 1, 0, 1)
            tex.SetTexCoord = function() end
            tex.Hooked = true
        else
            tex:SetTexCoord(0, 1, 0, 1)
        end
    end
end

function module:OnEvent(event, ...)
    if event == "UNIT_AURA" then
        return
    end

    for i = 1, MAX_ARENA_ENEMIES do
        local arenaFrame = _G["ArenaEnemyFrame" .. i]
        local petFrame = arenaFrame and arenaFrame.petFrame

        if petFrame then
            if event == "TEST_MODE" then
                if addon.testMode and GetCVar("showArenaEnemyPets") == "1" then
                    petFrame.healthbar.lockColor = true
                    petFrame.healthbar:SetMinMaxValues(0, 100)
                    petFrame.healthbar:SetValue(100)
                    petFrame.healthbar:SetStatusBarColor(0, 1, 0)
                    petFrame.healthbar.forceHideText = false
                    petFrame:Show()
                else
                    petFrame.healthbar.lockColor = false
                    petFrame:Hide()
                end

            elseif event == "UPDATE_SETTINGS" or event == "PLAYER_ENTERING_WORLD" then
                petFrame:SetScale(self.db.scale)
                ProtectBar(petFrame.healthbar, self.db.barTexture)

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

             if event == "UPDATE_SETTINGS" or event == "PLAYER_ENTERING_WORLD" or event == "TEST_MODE" then
                if not petFrame.isMoving then
                    petFrame:ClearAllPoints()
                    
                    local offsetY = self.db.y - ((i - 1) * self.db.frameSpacing)
                    
                     petFrame:SetPoint("CENTER", arenaFrame, "CENTER", self.db.x, offsetY)
                end
            end
        end
    end
end
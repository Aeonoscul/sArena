local addonName, addon = ...
local layout = addon:AddLayout("Aeonoscul", "Aeonoscul")

function layout:SetFrameStyle(frame, db)
    local hb_r, hb_g, hb_b, hb_a = frame.healthbar:GetStatusBarColor()
    local mb_r, mb_g, mb_b, mb_a = frame.manabar:GetStatusBarColor()

    frame.name:ClearAllPoints()
    frame.classPortrait:ClearAllPoints()
    frame.healthbar:ClearAllPoints()
    frame.manabar:ClearAllPoints()
    frame.texture:ClearAllPoints()
    if frame.portraitFrame then
        frame.portraitFrame:ClearAllPoints()
    end
    if frame.auraFrame then
        frame.auraFrame:ClearAllPoints()
    end

    local _maxHeight = (db.healthBarHeight + db.powerBarHeight)

    frame:SetSize(db.width + 2, _maxHeight + 3) 
    frame.texture:Hide()

    addon.squareClassPortrait = false

    frame.healthbar:SetWidth(db.width)
    frame.healthbar:SetHeight(db.healthBarHeight)
    frame.manabar:SetWidth(db.width)
    frame.manabar:SetHeight(db.powerBarHeight)

    if not frame.portraitFrame then
        frame.portraitFrame = CreateFrame("Frame", nil, frame)
    end
    frame.portraitFrame:Show()
    frame.portraitFrame:SetParent(frame)
    frame.portraitFrame:SetFrameLevel(frame.healthbar:GetFrameLevel() + 5)

    local portraitSize = (_maxHeight - 2) / 2
    frame.portraitFrame:SetSize(portraitSize, portraitSize)

    frame.classPortrait:SetParent(frame.portraitFrame)
    frame.classPortrait:SetSize(portraitSize, portraitSize)
    frame.classPortrait:ClearAllPoints()
    frame.classPortrait:SetPoint("CENTER", frame.portraitFrame, "CENTER")
    frame.classPortrait:SetDrawLayer("OVERLAY", 7)
    frame.classPortrait:SetAlpha(1)
    frame.classPortrait:Show()

    frame.backgroundFrame:Show()
    frame.backgroundFrame:SetSize(db.width + 2, _maxHeight + 3)

    if db.mirroredFrames then
        frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
        frame.name:SetPoint("TOPRIGHT", frame.healthbar, -2, -1)
        frame.name:SetJustifyH("RIGHT")
        frame.backgroundFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        frame.portraitFrame:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", 1, -1)
        frame.manabar:SetPoint("TOPLEFT", frame.healthbar, "BOTTOMLEFT", 0, -1)
    else
        frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
        frame.name:SetPoint("TOPLEFT", frame.healthbar, 2, -1)
        frame.name:SetJustifyH("LEFT")
        frame.backgroundFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        frame.portraitFrame:SetPoint("TOPRIGHT", frame.healthbar, "TOPRIGHT", -1, -1)
        frame.manabar:SetPoint("TOPLEFT", frame.healthbar, "BOTTOMLEFT", 0, -1)
    end

    frame.healthbar:SetStatusBarColor(hb_r, hb_g, hb_b, hb_a)
    frame.manabar:SetStatusBarColor(mb_r, mb_g, mb_b, mb_a)

    local petdb = addon.modules["Pet Frames"].db
    local maxWidth = (petdb.healthBarWidth)
    local maxHeight = (petdb.healthBarHeight + petdb.powerBarHeight)

    frame.petFrame:SetSize(maxWidth + 2, maxHeight + 3)

    local petPortrait = frame.petFrame.portrait or frame.petFrame.classPortrait
    if petPortrait then
        petPortrait:ClearAllPoints()
        petPortrait:SetAlpha(0)
    end

    frame.petFrame.healthbar:ClearAllPoints()
    frame.petFrame.healthbar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 1, -1)
    frame.petFrame.healthbar:SetWidth(petdb.healthBarWidth)
    frame.petFrame.healthbar:SetHeight(petdb.healthBarHeight)

    frame.petFrame.manabar:ClearAllPoints()
    frame.petFrame.manabar:SetPoint("TOPLEFT", frame.petFrame.healthbar, "BOTTOMLEFT", 0, -1)
    frame.petFrame.manabar:SetWidth(petdb.healthBarWidth)
    frame.petFrame.manabar:SetHeight(petdb.powerBarHeight)

    frame.petTexture:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
    frame.petTexture:SetVertexColor(0, 0, 0, 0.7)
    frame.petTexture:SetSize(maxWidth + 2, maxHeight + 3)
    frame.petTexture:ClearAllPoints()
    frame.petTexture:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT")
    frame.petTexture:SetParent(frame.petFrame)
    frame.petTexture:SetDrawLayer("BACKGROUND", 0)
    frame.petTexture:Show()
end
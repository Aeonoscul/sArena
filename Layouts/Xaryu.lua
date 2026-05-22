local addonName, addon = ...
local layout = addon:AddLayout("Xaryu", "Xaryu")

function layout:SetFrameStyle(frame, db)
    local _healthBarTexture = frame.healthbar:GetStatusBarTexture()
    local hb_r, hb_g, hb_b, hb_a = frame.healthbar:GetStatusBarColor()
    local _manaBarTexture = frame.manabar:GetStatusBarTexture()
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

    frame:SetSize(db.width + 4, db.height + 4)
    frame.texture:Hide()

    addon.squareClassPortrait = false

    frame.healthbar:SetWidth(db.width)
    frame.healthbar:SetHeight(db.healthBarHeight)
    frame.manabar:SetWidth(db.width)
    frame.manabar:SetHeight(db.powerBarHeight)

    if not frame.portraitFrame then
        frame.portraitFrame = CreateFrame("Frame", nil, frame)
    end
    frame.portraitFrame:SetFrameLevel(frame.healthbar:GetFrameLevel() + 2)
    
    local portraitSize = (_maxHeight - 2) / 2
    frame.portraitFrame:SetSize(portraitSize, portraitSize)
    
    frame.classPortrait:SetParent(frame.portraitFrame)
    frame.classPortrait:SetSize(portraitSize, portraitSize)
    frame.classPortrait:ClearAllPoints()
    frame.classPortrait:SetPoint("CENTER", frame.portraitFrame, "CENTER")
    frame.classPortrait:SetDrawLayer("OVERLAY", 7)
    frame.classPortrait:Show()

    frame.backgroundFrame:Show()
    frame.backgroundFrame:SetSize(db.width + 4, _maxHeight + 6)

    if db.mirroredFrames then
        frame.healthbar:SetPoint("TOPLEFT")
        frame.name:SetPoint("TOPRIGHT", frame.healthbar, -1, -1)
        frame.name:SetJustifyH("RIGHT")
        frame.backgroundFrame:SetPoint("TOPLEFT", frame, -2, 2)
        frame.portraitFrame:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", 1, -1)
        frame.manabar:SetPoint("TOPLEFT", frame.healthbar, "BOTTOMLEFT", 0, -2)
    else
        frame.healthbar:SetPoint("TOPLEFT")
        frame.name:SetPoint("TOPLEFT", frame.healthbar, 1, -1)
        frame.name:SetJustifyH("LEFT")
        frame.backgroundFrame:SetPoint("TOPLEFT", frame, -2, 2)
        frame.portraitFrame:SetPoint("TOPRIGHT", frame.healthbar, "TOPRIGHT", -1, -1)
        frame.manabar:SetPoint("TOPLEFT", frame.healthbar, "BOTTOMLEFT", 0, -2)
    end

    frame.healthbar:SetStatusBarTexture(_healthBarTexture)
    frame.healthbar:SetStatusBarColor(hb_r, hb_g, hb_b, hb_a)

    frame.manabar:SetStatusBarTexture(_manaBarTexture)
    frame.manabar:SetStatusBarColor(mb_r, mb_g, mb_b, mb_a)

    -- Pet Frame
    local petdb = addon.modules["Pet Frames"].db
    local maxWidth = (petdb.healthBarWidth)
    local maxHeight = (petdb.healthBarHeight + petdb.powerBarHeight)

    frame.petFrame:SetSize(maxWidth + 4, maxHeight + 6)

    frame.petFrame.portrait:ClearAllPoints()
    frame.petFrame.portrait:SetAlpha(0)

    frame.petFrame.healthbar:ClearAllPoints()
    frame.petFrame.healthbar:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT", 2, -2)
    frame.petFrame.healthbar:SetWidth(petdb.healthBarWidth)
    frame.petFrame.healthbar:SetHeight(petdb.healthBarHeight)

    frame.petFrame.manabar:ClearAllPoints()
    frame.petFrame.manabar:SetPoint("TOPLEFT", frame.petFrame.healthbar, "BOTTOMLEFT", 0, -2)
    frame.petFrame.manabar:SetWidth(petdb.healthBarWidth)
    frame.petFrame.manabar:SetHeight(petdb.powerBarHeight)

    frame.petTexture:SetTexture("Interface/Tooltips/UI-Tooltip-Background")
    frame.petTexture:SetVertexColor(0, 0, 0, 0.7)
    frame.petTexture:SetSize(maxWidth + 4, maxHeight + 6)
    frame.petTexture:ClearAllPoints()
    frame.petTexture:SetPoint("TOPLEFT", frame.petFrame, "TOPLEFT")
    frame.petTexture:SetParent(frame.petFrame)
end
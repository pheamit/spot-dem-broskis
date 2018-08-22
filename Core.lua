local events = {
    ["npu_added"] = "NAME_PLATE_UNIT_ADDED",
    ["npu_removed"] = "NAME_PLATE_UNIT_REMOVED",
    -- ["bg"] = "PLAYER_ENTERING_BATTLEGROUND",
    -- ["gru"] = "GROUP_ROSTER_UPDATE",
    -- ["ptc"] = "PLAYER_TARGET_CHANGED",
    ["load"] = "ADDON_LOADED"
}
local icons = {
    ["DEMONHUNTER"] = 236415,
    ["DRUID"] = 625999,
    ["HUNTER"] = 626000,
    ["MAGE"] = 626001,
    ["MONK"] = 626002,
    ["PALADIN"] = 626003,
    ["PRIEST"] = 626004,
    ["ROGUE"] = 626005,
    ["SHAMAN"] = 626006,
    ["WARLOCK"] = 626007,
    ["WARRIOR"] = 626008,
    ["DEATHKNIGHT"] = 135771
}

--[[ Potentially useful checks
    UnitIsFriend(unit, otherUnit) comparing relationships between units
    UnitIsPlayer(unit)
    UnitInPArty(unit)
]]

local guidSet = {}
local idSet = {}

local sdb = CreateFrame("Frame")
local _G = _G
local GetNamePlateForUnit = _G.C_NamePlate.GetNamePlateForUnit --get nameplate from global UI variable _G

local function addIcon(parentFrame, icon)
    local iconFrame, iconTexture
    iconFrame = CreateFrame("Frame", nil, parentFrame)
    iconFrame:SetFrameStrata("BACKGROUND")
    iconFrame:SetWidth(32)
    iconFrame:SetHeight(32)

    iconTexture = iconFrame:CreateTexture(nil, "BACKGROUND")
    iconTexture:SetTexture(icons[icon])
    iconTexture:SetAllPoints(iconFrame)

    iconFrame.texture = iconTexture
    iconFrame:SetPoint("TOPLEFT", 10, 10)
    iconFrame:Show()
end

local function removeIcon(parentFrame)
    parentFrame:Hide()
end

local function nameplateUnitAdded(self, event, unit)
    local namePlate = GetNamePlateForUnit(unit)
    local unit_frame = namePlate.UnitFrame
    local unitGUID = UnitGUID(unit)
    local separator = ", "
    local className, classId, raceName, raceId, gender, name, realm = GetPlayerInfoByGUID(unitGUID)
    if event == events["npu_added"] then
        if classId == "WARRIOR" and not idSet:contains(unit) then
            print(name .. separator .. classId .. separator .. unit .. " added!")
            idSet[unit] = name
            addIcon(namePlate, classId)
        end
    elseif event == events["npu_removed"] and idSet:contains(unit) then
        print("Was saved as " .. idSet[id])
        print("Was removed as " .. name)
        idSet:remove(unit)
        removeIcon(namePlate)
    end
end

local function showFriendlyNameplates(self, event)
    if event == events["load"] then
        SetCVar("nameplateShowAll", 1)
        SetCVar("nameplateShowFriends", 1)
    end
end

-- Utility functions

function guidSet:contains(key)
    return self[key] ~= nil
end

function idSet:contains(key)
    return self[key] ~= nil
end

function idSet:remove(key)
    idSet[key] = nil
end

-- Registering for a table of events

for k, v in pairs(events) do
    sdb:RegisterEvent(v)
end
sdb:SetScript("OnEvent", nameplateUnitAdded)
-- sdb:SetScript("OnEvent", showFriendlyNameplates)

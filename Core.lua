local events = {
    ["npu_added"] = "NAME_PLATE_UNIT_ADDED",
    ["npu_removed"] = "NAME_PLATE_UNIT_REMOVED",
    ["bg"] = "PLAYER_ENTERING_BATTLEGROUND",
    ["gru"] = "GROUP_ROSTER_UPDATE",
    ["ptc"] = "PLAYER_TARGET_CHANGED",
}
local icons = {
    ["friend"] = 645193,
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
    ["DEATHKNIGHT"] = 135771,
}
local guidSet = {}

local sdb = CreateFrame("Frame")

local _G = _G
local GetNamePlateForUnit = _G.C_NamePlate.GetNamePlateForUnit --get nameplate from global UI variable _G
local iconFrame, iconTexture

local function addIcon(parentFrame, icon)
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
    iconFrame:Hide()
end


local function nameplateUnitAdded(self, event, id)
    if event == events["npu_added"] then
        local namePlate = GetNamePlateForUnit(id)
        local unit_frame = namePlate.UnitFrame
        local unitGUID = UnitGUID(id)
        local separator = ", "
        local className, classId, raceName, raceId, gender, name, realm = GetPlayerInfoByGUID(unitGUID)
        if classId == "WARRIOR" and not guidSet:contains(unitGUID) then
            guidSet[unitGUID] = classId
            print(name .. separator .. classId .. separator .. realm .. separator .. id)
        -- else
        --     namePlate.UnitFrame:Hide()
        end
    -- elseif event == events["npu_removed"] then
    --     if id == "nameplate1" then
    --         print(unitName .. " with " .. id .. " removed!")
    --         removeIcon(namePlate)
    --     end
    end
    for k,v in pairs(guidSet) do
        addIcon()
    end
    
end

local function party(self, event, ...)
    if event == events["gru"] then
        print(event)
        print(...)
    end
    
end

-- Utility functions

function guidSet:contains(key)
    return self[key] ~= nil
end

for k,v in pairs(events) do
    sdb:RegisterEvent(v)
end
sdb:SetScript("OnEvent", nameplateUnitAdded)

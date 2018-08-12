local events = {
    -- ["npu_added"] = "NAME_PLATE_UNIT_ADDED",
    -- ["npu_removed"] = "NAME_PLATE_UNIT_REMOVED",
    -- ["bg"] = "PLAYER_ENTERING_BATTLEGROUND",
    -- ["gru"] = "GROUP_ROSTER_UPDATE",
    ["ptc"] = "PLAYER_TARGET_CHANGED"
}
local sdb = CreateFrame("Frame")
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
    ["DEATHKNIGHT"] = 135771
}
local classes = {
    ["WARRIOR"] = 1,
    ["PALADIN"] = 2,
    ["HUNTER"] = 3,
    ["ROGUE"] = 4,
    ["PRIEST"] = 5,
    ["DEATHKNIGHT"] = 6,
    ["SHAMAN"] = 7,
    ["MAGE"] = 8,
    ["WARLOCK"] = 9,
    ["MONK"] = 10,
    ["DRUID"] = 11,
    ["DEMONHUNTER"] = 12
}
local partyMembers = {}
local GUIDSet = {}
local GetNamePlateForUnit = _G.C_NamePlate.GetNamePlateForUnit --get nameplate from global UI variable _G
local iconFrame, iconTexture

local function addIcon(parentFrame, icon)
    iconFrame = CreateFrame("Frame")
    iconTexture = iconFrame:CreateTexture(nil, "BACKGROUND")
    iconFrame:SetFrameStrata("BACKGROUND")
    iconFrame:SetWidth(32)
    iconFrame:SetHeight(32)
    iconFrame:SetPoint("TOPLEFT", 10, 10)
    iconFrame:SetParent(parentFrame)
    iconFrame.texture = iconTexture
    iconTexture:SetAllPoints(iconFrame)
    iconTexture:SetTexture(icons[icon])
    iconFrame:Show()
end

local function removeIcon(parentFrame)
    iconFrame:Hide()
end

local function nameplateUnit(self, event, id)
    if event == events["npu_added"] and not GUIDSet:contains(unitGUID) then
        local unitGUID = UnitGUID(id)
        local _, classId, _, _, _, unitName = GetPlayerInfoByGUID(unitGUID)
        GUIDSet[unitGUID] = unitName
        print(unitName .. " - " .. id .. " - " .. classId .. " added!")
        addIcon(GetNamePlateForUnit(id), classId)
    elseif event == events["npu_removed"] and GUIDSet:contains(unitGUID) then
        GUIDSet[unitGUID] = nil
        removeIcon(GetNamePlateForUnit(id))
    end
end

local function party(self, event)
    if event == events["gru"] then
        for i = 1, 4 do
            local member = "PartyMemberFrame" .. i
            local name = _G[member].name:GetText()
            if name then
                partyMembers[i] = name
            end
            addIcon(member, UnitClass(name))
        end
    end
end

local function onTarget(self, event)
    local unitGUID = UnitGUID("target")
    local _, classId, _, _, _, unitName = GetPlayerInfoByGUID(unitGUID)
    local nameplate = GetNamePlateForUnit("target")
    print(unitGUID .. ", " .. classId .. ", " .. unitName)
    addIcon(nameplate, classId)
end

function GUIDSet:contains(GUID)
    return self[GUID] ~= nil
end

for k, v in pairs(events) do
    sdb:RegisterEvent(v)
end

sdb:SetScript("OnEvent", onTarget)
-- sdb:SetScript("OnEvent", party)
-- sdb:SetScript("OnEvent", nameplateUnit)

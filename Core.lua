local GetNamePlateForUnit = _G.C_NamePlate.GetNamePlateForUnit

local sdb = CreateFrame("Frame")
local icons = {
    ["friend"] = 645193
}
local icon_frame, icon_texture

local function addIcon(parentFrame)
    icon_frame = CreateFrame("Frame", nil, parentFrame)
    icon_frame:SetFrameStrata("BACKGROUND")
    icon_frame:SetWidth(32)
    icon_frame:SetHeight(32)

    icon_texture = icon_frame:CreateTexture(nil, "BACKGROUND")
    icon_texture:SetTexture(icons["friend"])
    icon_texture:SetAllPoints(icon_frame)
    icon_frame.texture = icon_texture

    icon_frame:SetPoint("TOP", 0, 20)
    icon_frame:Show()
end

local function removeIcon(parentFrame)
    icon_frame:Hide()
end


local function eventHandler(self, event, id)
    local name_plate = GetNamePlateForUnit(id)
    local unit_name = GetUnitName(id, false)
    if event == "NAME_PLATE_UNIT_ADDED" then
        if id == "nameplate1" then
            print(unit_name .. " with " .. id .. " added!")
            addIcon(name_plate)
        else
            name_plate.UnitFrame:Hide()
        end
    else
        if id == "nameplate1" then
            print(GetUnitName(id, false) .. " with " .. id .. " removed!")
            removeIcon(name_plate)
        end
    end
end

sdb:RegisterEvent("NAME_PLATE_UNIT_ADDED")
sdb:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
sdb:SetScript("OnEvent", eventHandler)

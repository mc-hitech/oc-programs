local sides = require("sides")
local component = require("component")
local ic2 = {}

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

ic2.Reactor = {
    list = function()
        local t = {}
        for adr in component.list("inventory_controller") do
            local inv = component.proxy(adr)
            for side = 0, 5 do
                local size = inv.getInventorySize(side)
                if size then
                    t[side] = ic2.Reactor:new(side, inv)
                end
            end
        end
        return t
    end
}

function ic2.Reactor:new(side, inventory)
    local this = {side = side, inventory = inventory}
    setmetatable(this, self)
    self.__index = self
    return this
end

function ic2.Reactor:getStacks()
    return self.inventory.getAllStacks(self.side);
end

function ic2.Reactor:getSize(chambers)
    local size = math.floor(self.inventory.getInventorySize(self.side) - 4);
    if (chambers or false) ~= true then
        return size
    end
    return math.floor((size - 18) / 6)

end

function ic2.Reactor:getSlots()
    local stacks = self:getStacks()
    local slots = {}
    local cols = self:getSize(true) + 3
    local pos, i = nil, nil

    for row = 0, 5 do
        for col = 1, 9 do
            pos = (row * 9) + col
            i = col > cols and 0 or (row * cols) + col;
            slots[i] = ic2.ReactorSlot:new({
                pos = pos,
                i = i,
                row = row + 1,
                col = col,
                inv = self,
                stack = stacks and stacks[i] or {}
            })
        end
    end
    return slots;
end

function ic2.Reactor:__tostring()
    return self:tostring()
end

function ic2.Reactor:tostring(verbose)
    verbose = verbose or false
    local str =  "<reactor side="  .. sides[self.side]
            .. " slots=" .. self:getSize()
            .. " chambers=" .. self:getSize(true)
    if (verbose or false) ~= true then
        return str .. " />"
    end
    str = str .. ">"
    for _, slot in ipairs(self:getSlots()) do
        str = str .. "\n  " .. tostring(slot)
    end
    return str .. "\n</reactor>"
end

--- ReactorSlot

ic2.ReactorSlot = {}

function ic2.ReactorSlot:new(obj)
    local this = obj or {}
    setmetatable(this, self)
    self.__index = self
    return this
end

function ic2.ReactorSlot:__tostring()
    return "<slot pos="  .. self.pos ..
            " i=" .. self.i ..
            " row=" .. self.row ..
            " col=" .. self.col ..
            " name=" .. (self.stack and self.stack.name or '') ..
            " damage=" .. (self.stack and self.stack.damage or '') ..
            " maxDamage=" .. (self.stack and self.stack.maxDamage or '') ..
            " />"
end

-- rm t.lua -f && edit t.lua
-- t | less

--for _, reactor in pairs(ic2.Reactor.list()) do
--    print(reactor:tostring(true))
--end

return ic2
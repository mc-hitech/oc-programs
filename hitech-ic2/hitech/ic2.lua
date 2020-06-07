local ic2 = {}

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

function ic2.Reactor:__tostring()
    return "<reactor side="  .. sides[self.side] .. " inventory=" .. tostring(self.inventory) .. " />"
end

return ic2
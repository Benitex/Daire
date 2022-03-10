----------------
-- Coin Class --
----------------

local Mouse = require 'Mouse'
local Window = require 'Window'

local Coin = {
    x = 0, y = 0, size = 8,
    sprite = love.graphics.newImage('graphics/icons/Coin_Icon.png'), scale = 3
}
Coin.__index = Coin

function Coin:new(scale)
    self = setmetatable({}, self)

    self.scale = scale
    self.size = self.size * scale
    self.x = love.math.random(Window.width - self.size*2 * self.scale)
    self.y = love.math.random(Window.height - self.size*2 * self.scale)

    return self
end

function Coin:clicked()
    if areCirclesTouching(self.x, self.y, self.size, love.mouse.getX(), love.mouse.getY(), Mouse.size) then
        Shop.money = Shop.money + Shop.coinsValue
        Shop.totalMoney = Shop.totalMoney + Shop.coinsValue
        return true
    else
        return false
    end
end

return Coin
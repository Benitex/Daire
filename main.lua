-----------
-- Daire --
-----------

-- Classes
local Sounds = require 'src/Sounds'
local Mouse = require 'src/Mouse'
File = require 'src/File'
UI = require 'src/ui/UI'
Shop = require 'src/shop/Shop'

function love.load()
    gameState = 'menu'
    countdown = 3

    -- Get the OS
    playingOnMobile = false
    if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
        playingOnMobile = true
    end

    -- Set font
    local font = love.graphics.newFont('font/pixelart.ttf')
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    File.load()
    Shop.setTemperature()
    UI.load()
end

function love.draw()
    UI.drawBackgrounds()
    if gameState == 'play' then
        if countdown < 0 then
            for tempo, coin in ipairs(Shop.coinsList) do
                love.graphics.draw(coin.sprite, coin.x, coin.y, 0, coin.scale, coin.scale)
            end
            for tempo, circle in ipairs(Shop.circleList) do
                love.graphics.circle('fill', circle.x, circle.y, circle.size)
            end
        end
    end
    UI.drawButtons()
    UI.drawTexts()
    Mouse.draw()
end

function love.update(dt)
    Mouse.update()
    Sounds.play()
    if gameState == 'play' then
        countdown = countdown - dt
        if countdown < 0 then
            Shop.receiveMoney(dt)
            Shop.spawnCoins(dt)
            for tempo, circle in ipairs(Shop.circleList) do
                circle:move(dt)
                if circle:touchedByMouse() then
                    Shop.circleList = {}
                    Shop.coinsList = {}
                    Sounds.defeatSE:play()
                    gameState = 'game over'
                    Shop.money = 0
                    countdown = 3
                    File.save()
                end
            end
        end
    end
end

function areCirclesTouching(x1, y1, size1, x2, y2, size2)
    local distance = math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
    return distance < size1 + size2
end

-- Desktop controls

function love.mousepressed(x, y)
    -- Buttons
    for tempo, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end

    -- Coins
    if not Shop.coinsPickedOnHover then
        for coinNumber, coin in ipairs(Shop.coinsList) do
            if coin:clicked() then
                table.remove(Shop.coinsList, coinNumber)
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' or key == 'space' then
        if gameState == 'play' then
            gameState = 'pause'
        elseif gameState == 'pause' then
            gameState = 'play'
        else
            File.save()
            love.event.quit()
        end
    end
end

-- Touchscreen controls

function love.touchpressed(id, x, y)
    -- Buttons
    for tempo, button in ipairs(UI.getList()) do
        button:clicked(x, y)
    end
end

function love.touchmoved(id, x, y)
    if playingOnMobile then
        Mouse.x = x
        Mouse.y = y
    end
end

function love.touchreleased()
    if playingOnMobile then
        if countdown < 0 then
            if gameState == 'play' then
                gameState = 'pause'
            elseif gameState == 'pause' then
                gameState = 'play'
            end
        end
    end
end
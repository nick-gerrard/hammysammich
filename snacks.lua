local Utils = require("utils")
local Snacks = {}

local snackImage = nil
local playerScore = 0
local vacScore = 0
local snacks = {
    { x = 300, y = 200, width = 20, height = 20, eaten = false },
    { x = 500, y = 400, width = 20, height = 20, eaten = false },
    { x = 300, y = 400, width = 20, height = 20, eaten = false },
    { x = 500, y = 200, width = 20, height = 20, eaten = false },
}

function Snacks.load()
    snackImage = love.graphics.newImage("assets/sammy.png")
end

function Snacks.update(playerRect, enemyRect)
    for i, snack in ipairs(snacks) do
        if not snack.eaten then
            if Utils.checkCollision(playerRect, snack) then
                snack.eaten = true
                playerScore = playerScore + 1
            elseif Utils.checkCollision(enemyRect, snack) then
                snack.eaten = true
                vacScore = vacScore + 1
            end
        end
    end
end

function Snacks.draw()
    for i, snack in ipairs(snacks) do
        if not snack.eaten then
            love.graphics.draw(snackImage, snack.x, snack.y)
        end
    end
end

function Snacks.allEaten()
    return playerScore + vacScore >= #snacks
end

function Snacks.getPlayerScore()
    return playerScore
end

function Snacks.reset()
    for i, snack in ipairs(snacks) do
        snack.eaten = false
    end
    playerScore = 0
    vacScore = 0
end

return Snacks

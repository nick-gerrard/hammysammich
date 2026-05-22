local Menu = {}

local titleFont
local subtitleFont
local smallFont
local hammyImage
local vacuumImage

function Menu.load()
	titleFont = love.graphics.newFont(52)
	subtitleFont = love.graphics.newFont(18)
	smallFont = love.graphics.newFont(13)
	hammyImage = love.graphics.newImage("assets/hammy.png")
	vacuumImage = love.graphics.newImage("assets/vacuum.png")
end

function Menu.draw()
	-- background
	love.graphics.setColor(0.07, 0.07, 0.13)
	love.graphics.rectangle("fill", 0, 0, 800, 600)

	-- title
	love.graphics.setFont(titleFont)
	love.graphics.setColor(1, 0.82, 0.15)
	love.graphics.printf("HAMILTON'S HOUSE", 0, 90, 800, "center")

	-- hammy on the left, facing right
	love.graphics.setColor(1, 1, 1)
	local hs = 8
	local hamW = hammyImage:getWidth() * hs
	local hamH = hammyImage:getHeight() * hs
	love.graphics.draw(hammyImage, 20, 230 - hamH / 2, 0, hs, hs)

	-- vacuum on the right, flipped to face left
	-- with negative scaleX and no origin offset, the image extends LEFT from x
	local vs = 6
	local vacH = vacuumImage:getHeight() * vs
	love.graphics.draw(vacuumImage, 780, 230 - vacH / 2, 0, -vs, vs)

	-- VS
	love.graphics.setFont(titleFont)
	love.graphics.setColor(0.9, 0.25, 0.25)
	love.graphics.printf("VS", 0, 270, 800, "center")

	-- tagline
	love.graphics.setFont(subtitleFont)
	love.graphics.setColor(0.85, 0.85, 0.85)
	love.graphics.printf("Eat all the sandwiches. Survive the vacuum.", 0, 420, 800, "center")

	-- controls
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.printf("WASD — move     F — fullscreen     R — restart", 0, 455, 800, "center")

	-- pulsing prompt
	local alpha = (math.sin(love.timer.getTime() * 3) + 1) / 2
	love.graphics.setFont(subtitleFont)
	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.printf("PRESS ENTER TO START", 0, 520, 800, "center")

	love.graphics.setColor(1, 1, 1, 1)
end

return Menu

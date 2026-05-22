local Audio = {}
local bg = love.audio.newSource("assets/background.mp3", "stream")
local munch = love.audio.newSource("assets/munch.mp3", "static")
local suck = love.audio.newSource("assets/vac.mp3", "stream")

function Audio.load()
	bg:setLooping(true)
	suck:setLooping(true)
end

function Audio.startMusic()
	if not bg:isPlaying() then
		bg:play()
	end
end

function Audio.stopMusic()
	bg:stop()
end

function Audio.playMunch()
	munch:stop()
	munch:play()
end

function Audio.startVac()
	if not suck:isPlaying() then
		suck:play()
	end
end

function Audio.stopVac()
	if suck:isPlaying() then
		suck:stop()
	end
end

return Audio

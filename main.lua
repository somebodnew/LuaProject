
love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 15
VerCell = 10

local Board = {width = tile*HorCell,height = tile*VerCell}

-- Размер экрана
success = love.window.setMode(Board.width,Board.height)

GO = love.audio.newSource('HareGarden/assets/GameOver.mp3', 'static')
love.audio.setVolume(1)
s = true

function A(sound)
	
	
end

function love.update(dt)
	if s == true then
		sound:play()
		s = false
	end
	m = love.audio.getSourceCount( )
	if m == 0 then
		s = true
	end
	
end

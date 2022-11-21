local tiles = love.graphics.newImage('space.png')

local quad = love.graphics.newQuad(
			0, 0, 16,16,
			tiles:getWidth(), tiles:getHeight()
			)
			
function love.draw()
	love.graphics.draw(
		tiles, quad, 
		0, 0, 
		0, 
		2,2
		)
		end
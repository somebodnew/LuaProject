function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
end

function love.draw()
	local baseX   = love.graphics.getWidth()/2
	local baseY   = 400
	local radius  = 100
	local offsetY = radius/2 * math.sqrt(3)

	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.setColor(1, .6, .6)
	love.graphics.circle("fill", baseX-radius/2, baseY, radius)
	love.graphics.setColor(.6, 1, .6)
	love.graphics.circle("fill", baseX, baseY-offsetY, radius)
	love.graphics.setColor(.6, .6, 1)
	love.graphics.circle("fill", baseX+radius/2, baseY, radius)
end
local viewport = {
	x = 0, y = 0,
	width = 800, height = 600,
}

local player = {
	x = 0, y = 0,
	width = 30, height = 40,
	speed = 10
}

local circles = {
	{x = 10, y = 20, radius = 30},
	{x = 500, y = 400, radius = 30},
	{x = 1000, y = 300, radius = 30},
	{x = 300, y = 800, radius = 30},
}

function love.load()
	viewport.x = player.x - love.graphics.getWidth()/2
	viewport.y = player.y - love.graphics.getHeight()/2
end

function love.update(dt)
	if love.keyboard.isDown('w')then 
		player.y = player.y - player.speed
		viewport.y = viewport.y - player.speed
		
	elseif love.keyboard.isDown('a')then
		player.x = player.x - player.speed
		viewport.x = viewport.x - player.speed
		
	elseif love.keyboard.isDown('s')then
		player.y = player.y + player.speed
		viewport.y = viewport.y + player.speed
		
	elseif love.keyboard.isDown('d')then
		player.x = player.x + player.speed
		viewport.x = viewport.x + player.speed
	end
end

function love.draw()
		love.graphics.rectangle('fill',
			player.x - viewport.x,
			player.y - viewport.y,
			player.width,
			player.height)
	
	for i, circle in ipairs(circles) do
		love.graphics.circle('fill',
			circle.x - viewport.x,
			circle.y - viewport.y,
			circle.radius,3)
	end
end
local anim = require('anim')

local scaleY = 4
local scaleX = 4

love.graphics.setDefaultFilter("nearest","nearest")
local tiles = love.graphics.newImage('tileset.png')

local playerAnimation = {costyle = 108}
local lihzardAnimation = {costyle = 204}
local wizardAnimation = {costyle = 172}
Entities = {playerAnimation,lihzardAnimation,wizardAnimation}

--local trollAnimation = {}

function NewEntityIdleAnimation(xx,yy)

	local animation={
		timer = 0,
		speed = 0.3,
		frameIdx = 1,
		frames = {},
		x = 16, y = 21,
		
		}
		
	for i = 0, 3 do
		local quad = love.graphics.newQuad(
			xx + i * animation.x, yy, animation.x, animation.y,
			tiles:getWidth(), tiles:getHeight()
			)
			
		table.insert(animation.frames, quad)
	end
	
	return animation
	
end	

function NewEntityRunAnimation(xx,yy)

	local animation={
		timer = 0,
		speed = 0.2,
		frameIdx = 1,
		frames = {},
		x = 16, y = 21,
		}
		
	for i = 4, 7 do
		local quad = love.graphics.newQuad(
			xx + i * animation.x, yy, animation.x, animation.y,
			tiles:getWidth(), tiles:getHeight()
			)
			
		table.insert(animation.frames, quad)
	end
	
	return animation
	
end	

function love.load()
	for i, a in ipairs(Entities) do 
			
		a.idle = NewEntityIdleAnimation(128,a.costyle)
		a.run = NewEntityRunAnimation(128,a.costyle)
		a.current = a.idle
	end
	--trollAnimation.idle = NewEntityIdleAnimation(16,368, 32, 32)
end

function love.update(dt)
	--
	--anim.update(wizardAnimation.idle, dt)
	--anim.update(trollAnimation.idle, dt)
	for i, a in ipairs(Entities) do 
		anim.update(a.idle, dt)
		if love.keyboard.isDown('w')then
			a.current = a.run
		else
			a.current = a.idle
		end
	anim.update(a.current, dt)
	end
end

function EntityDraw(animation,x)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		tiles, frame, 
		x-28/2*scaleX, 300, 
		0, 
		scaleX,scaleY
		)
end

function love.draw()
	--EntityDraw(trollAnimation.idle,4*25*scaleY) 
	--EntityDraw(playerAnimation.idle,3*25*scaleY)
	--EntityDraw(wizardAnimation.idle,2*25*scaleY)	
	
	for i, a in ipairs(Entities) do 
		EntityDraw(a.current,i*25*scaleY)
		
	end

	
end
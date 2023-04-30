local function update(self,dt)
	local n = #self.frames
	self.timer = self.timer + dt
	if self.timer > self.speed then
		self.timer = self.timer - self.speed
		self.frameIdx = self.frameIdx % n + 1
	end
end

local function getFrame(self)
	return self.frames[self.frameIdx]
end

local function IdleAnimation(first, last, xx, yy, Pic)

	local animation={
		timer = 0,
		speed = 0.3,
		frameIdx = 1,
		frames = {},
		x = xx, y = yy,
		
		}
		
	for i = first, last do
		local quad = love.graphics.newQuad(i * animation.x, 0, animation.x, animation.y,
			Pic:getWidth(), Pic:getHeight())
			
		table.insert(animation.frames, quad)
	end	
	
	return animation
	
end	

function EntityDraw(animation,pic,x,y)
	love.graphics.setColor(1, 1, 1)
	frame = getFrame(animation) 
	love.graphics.draw(
		pic, frame, 
		x, y, 0,
		2,2
		)
end

return {
	update = update,
	getFrame = getFrame,
	idle = IdleAnimation,
	draw = EntityDraw
}
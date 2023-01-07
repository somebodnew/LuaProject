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

local function IdleAnimation(first, last)

	local animation={
		timer = 0,
		speed = 0.3,
		frameIdx = 1,
		frames = {},
		x = 55, y = 47,
		
		}
		
	for i = first, last do
		local quad = love.graphics.newQuad(i * animation.x, 0, animation.x, animation.y,
			Hare:getWidth(), Hare:getHeight())
			
		table.insert(animation.frames, quad)
	end	
	
	return animation
	
end	

return {
	update = update,
	getFrame = getFrame,
	idle = IdleAnimation
}
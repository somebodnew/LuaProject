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

return {
	update = update,
	getFrame = getFrame
}
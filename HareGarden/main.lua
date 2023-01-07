love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 50

local Board = {width = tile*15,height = tile*10}

success = love.window.setMode(Board.width,Board.height)

local anim = require('anim')

-- Загрузка спрайтшита
Hare = love.graphics.newImage('assets/HareSheet.png')



-- Начальное положение игрока и костыль
local player = {
	x = tile/2,
	y = tile/2,
	Pressed = false,
}
local playerAnimation = {
	
}

-- Движение персонажа
-- Проверяет костыль, затем перемещает персонажа в зависимости от нажатой кнопки
-- Костыль: после передвижения переменная Pressed становится истинной, тогда при следующей итерации движение не осуществится, откроется ветвь else
-- else: Если кнопка не нажата, то Pressed становится ложной 
function Move(self)
	if self.Pressed == false then
		if love.keyboard.isDown('s') and self.y + tile*2 < Board.height then
			self.y = self.y + tile
			self.Pressed = true
		end
		if love.keyboard.isDown('w') and self.y - tile > 0 then
			self.y = self.y - tile
			self.Pressed = true
		end
		if love.keyboard.isDown('d') and self.x + tile*2 < Board.width then
			self.x = self.x + tile
			self.Pressed = true
		end
		if love.keyboard.isDown('a') and self.x - tile > 0 then
			self.x = self.x - tile
			self.Pressed = true
		end
	else
		if love.keyboard.isDown('w','a','s','d') == false then
			self.Pressed = false
		end
	end
end

            -- Анимации зайца
			
function IdleAnimation(first, last)

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
	


function EntityDraw(animation)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		Hare, frame, 
		player.x, player.y
		)
end



function love.load()
	playerAnimation.idle = IdleAnimation(0,7)
	playerAnimation.current = playerAnimation.idle
end



function love.update(dt)
	Move(player)
	anim.update(playerAnimation.current, dt)
	
end


function love.draw()
	
	EntityDraw(playerAnimation.current)
	
end
love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 15
VerCell = 10

local Board = {width = tile*HorCell,height = tile*VerCell}

-- Размер экрана
success = love.window.setMode(Board.width,Board.height)

-- Библиотеки
local anim = require('anim')
local field = require('field')

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
			
			
function EntityDraw(animation)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		Hare, frame, 
		player.x, player.y
		)
end


function love.load()
	
	playerAnimation.idle = anim.idle(0,7)
	playerAnimation.current = playerAnimation.idle
	
	cells = field.GenCells(HorCell-2,VerCell-2,tile)
end



function love.update(dt)
	Move(player)
	anim.update(playerAnimation.current, dt)
	
end


function love.draw()
	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.rectangle('fill',0,0,Board.width,Board.height)
	field.DrawCells(tile,cells,HorCell-1,VerCell-1)
	love.graphics.setColor(1,1,1)
	EntityDraw(playerAnimation.current)
	
end
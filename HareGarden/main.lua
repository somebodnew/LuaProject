love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 15
VerCell = 10

local Board = {width = tile*HorCell,height = tile*VerCell,Pressed = false,}

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
	y = tile/2
}
local playerAnimation = {
	
}
local VegActive = {
	
}

-- Движение персонажа
-- Проверяет костыль, затем перемещает персонажа в зависимости от нажатой кнопки

function Move(self,board)
	if board.Pressed == false then
		if love.keyboard.isDown('s') and self.y + tile*2 < Board.height then
			self.y = self.y + tile
			board.Pressed = true
		end
		if love.keyboard.isDown('w') and self.y - tile > 0 then
			self.y = self.y - tile
			board.Pressed = true
		end
		if love.keyboard.isDown('d') and self.x + tile*2 < Board.width then
			self.x = self.x + tile
			board.Pressed = true
		end
		if love.keyboard.isDown('a') and self.x - tile > 0 then
			self.x = self.x - tile
			board.Pressed = true
		end
	end
end

-- Засадка семян
function Plant(self,board)
	if board.Pressed == false then
		if love.keyboard.isDown('space') then
			PlantCell(cells,player)
			board.Pressed = true
		end
	end
end

-- Костыль: после хода переменная Pressed становится истинной, тогда при следующей итерации ход не осуществится, пока не сработает следующая функция
-- Если кнопка не нажата, то Pressed становится ложной 
function EndTurn(board)
	
	if  board.Pressed == true and love.keyboard.isDown('w','a','s','d','space') == false then
		board.Pressed = false
		field.CellUpdate(cells,VegActive)
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

	Move(player,Board)
	Plant(player,Board)
	EndTurn(Board)
	anim.update(playerAnimation.current, dt)
	
end


function love.draw()
	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.rectangle('fill',0,0,Board.width,Board.height)
	field.DrawCells(tile,cells,HorCell-1,VerCell-1)
	love.graphics.setColor(1,1,1)
	EntityDraw(playerAnimation.current)
	
end
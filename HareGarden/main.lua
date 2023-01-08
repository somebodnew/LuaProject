love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 14 -- -1
VerCell = 10 -- -2

-- Параметры поля и мира
local Board = {
	width = tile*HorCell,
	height = tile*VerCell,
	Pressed = false,
	tile = tile,
	tx = tile/2,
	ty = tile/2,
	Grown = false,
	score = 10,
	GameOn = true
	}

-- Размер экрана
success = love.window.setMode(Board.width,Board.height)

-- Библиотеки
local anim = require('anim')
local field = require('field')

-- Загрузка звука
Hop = love.audio.newSource('assets/Hop.mp3', 'static')
Hop:setPitch(3)
GO = love.audio.newSource('assets/GameOver.mp3', 'static')
s1 = love.audio.newSource('assets/Carrot.mp3', 'static')
s2 = love.audio.newSource('assets/BadCarrot.mp3', 'static')
s3 = love.audio.newSource('assets/WorstCarrot.mp3', 'static')

-- Загрузка спрайтшита
Hare = love.graphics.newImage('assets/HareSheet.png')
GoldenCarrot = love.graphics.newImage('assets/GoldenCarrotSheet.png')
Carrot = love.graphics.newImage('assets/CarrotSheet.png')
BadCarrot = love.graphics.newImage('assets/BadCarrotSheet.png')
WorstCarrot = love.graphics.newImage('assets/WorstCarrotSheet.png')


local player = {
	up = 'w',
	left = 'a',
	down = 's',
	right = 'd',
	x = tile/2,
	y = tile/2*3
}
local playerAnimation = {
	
}
local VegActive = {
	
}


-- Движение сущности на клавиши
-- Проверяет костыль, затем перемещает персонажа в зависимости от нажатой кнопки
function Move(self,board)
	if board.Pressed == false then
			-- первая часть условия на выяснение нажатой клавиши, а вторая часть условия для проверки границ
		if love.keyboard.isDown(self.up) and self.y - tile*2 > 0 then
			self.y = self.y - tile
			board.Pressed = true
			Hop:play()
			
		end
		if love.keyboard.isDown(self.left) and self.x - tile > 0 then
			self.x = self.x - tile
			board.Pressed = true
			Hop:play()
		end
		if love.keyboard.isDown(self.down) and self.y + tile*2 < Board.height then
			self.y = self.y + tile
			board.Pressed = true
			Hop:play()
		end
		if love.keyboard.isDown(self.right) and self.x + tile*2 < Board.width then
			self.x = self.x + tile
			board.Pressed = true
			Hop:play()
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

function GrowVeg(self,board)
	pam = math.random(2)*math.pow((-1),math.random(2))
	if pam == 2 then
		pc = GoldenCarrot
		sond = s1
	end
	if pam == 1 then
		pc = Carrot
		sond = s1
	end
	if pam == -2 then
		pc = WorstCarrot
		sond = s3
	end
	if pam == -1 then
		pc = BadCarrot
		sond = s2
	end
	Veg = {
	x = board.tx,
	y = board.ty,
	ShouldDestroy = false,
	grade = pam,
	pic = pc,
	sound = sond
	}
	
	table.insert(self,Veg)
end

-- Костыль: после хода переменная Pressed становится истинной, тогда при следующей итерации ход не осуществится, пока не сработает следующая функция
-- Если кнопка не нажата, то Pressed становится ложной 
function EndTurn(board)
		-- Проверяет, отпустил ли кнопку игрок после своего действия
	if  board.Pressed == true and love.keyboard.isDown('w','a','s','d','space') == false then
		board.Pressed = false
		-- После окончания действия игрока, начинается окончание хода, где происходят действия остальных вещей
		
		-- Функция обновляет состояние всех клеток с семенами - они сокращают свой таймер, приближая вырастание морковок
		field.CellUpdate(cells,board)
		
		
		
		-- Если флаг Grown отмечен, убирает отметку и создает овощ
		if board.Grown == true then
			board.Grown = false
			GrowVeg(VegActive,board)
		end
		board.tx = tile * math.random(0,HorCell-2)+tile/2
		board.ty = tile * math.random(1,VerCell-2)+tile/2
		GrowVeg(VegActive,board)
		for i,a in ipairs(VegActive)do 
			Harvest(a,player)
			if a.ShouldDestroy == true then
				board.score = board.score + a.grade*5
				a.sound:play()
				table.remove(VegActive,i)
			end
		end
		love.audio.stop(Hop)
	end
	
end

	
-- Отрисовка предмета или персонажа
-- - - - - - - -
-- animation - анимация предмета или сущности
-- Для предмета вводится его анимация висения в воздухе
-- Для персонажа вводится его текущая(current) анимация
-- - - - - - - -
-- pic - Картинка сущности или спрайтшит, с которого берутся кадры анимации
-- - - - - - - -
-- x и y - координаты отрисовки 
-- берутся из параметров отрисовываемой сущности
function EntityDraw(animation,pic,x,y)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		pic, frame, 
		x, y
		)
end


function BackgroundColor(Board)
	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.rectangle('fill',0,0,Board.width,Board.height)
end

function ShowScore(Board)
	love.graphics.setColor(1,0,1)
	love.graphics.print('Your Score: '.. Board.score,Board.tile/2,Board.tile/2,0,3,3)
	love.graphics.setColor(1,1,1)
	love.graphics.print('Hare',Board.tile*6,Board.tile/2,0,3,3) 
	love.graphics.setColor(0,1,0)
	love.graphics.print(' Garden',Board.tile*7+20,Board.tile/2,0,3,3) 
end

function GameOver(Board)
	if Board.score <= 0 then 
	Board.GameOn = false 
	GO:play()
	end
end

function love.load()
	
	-- Список овощей
	
	
	-- Анимация всех морковок
	carrotAnimation = anim.idle(0,11,54,54,GoldenCarrot)

	
	
	-- Задание анимации ничегонеделания для зайца-игрока и подготовка для смены анимаций при смене состояний
	playerAnimation.idle = anim.idle(0,7,55,47,Hare)
	playerAnimation.current = playerAnimation.idle
	
	-- Генерация поля
	cells = field.GenCells(HorCell-2,VerCell-2,tile)
end

s = true

function love.update(dt)
	if Board.GameOn == true then
		-- Действие Игрока
		Move(player,Board) -- Передвижение игрока
		Plant(player,Board)-- Посадка семян
		
		-- Остальные события происходят при срабатывании этой функции, а она зависит от хода игрока
		EndTurn(Board)
		
		
		-- Апдейт анимаций
		anim.update(playerAnimation.current, dt)
		
		anim.update(carrotAnimation, dt)
		
		-- Конец игры если очков мало
		GameOver(Board)
		
	end
end


function love.draw()
	-- Фон серый, видно только по краям
	BackgroundColor(Board)
	if Board.GameOn == true then
		-- Вывод Счета
		ShowScore(Board)
		-- Отрисовка клеток
		field.DrawCells(tile,cells,HorCell-1,VerCell-1)
		
		-- Отрисовка зайца
		love.graphics.setColor(1,1,1)
		EntityDraw(playerAnimation.current,Hare,player.x,player.y)
		
		-- Отрисовка всех морковок
		for i, a in ipairs(VegActive)do
			EntityDraw(carrotAnimation,a.pic,a.x,a.y)
		end
	else
		if s == true then
			GO:play()
			s = false
		end
		
		if love.audio.getActiveSourceCount( ) == 0 then
			s = true
		end
		love.graphics.setColor(1,1,1)
		love.graphics.print('Game Over!',Board.width/2-25,Board.height/2,0,3,3)
	end
end
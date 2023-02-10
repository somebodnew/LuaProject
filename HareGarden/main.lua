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
GS = love.audio.newSource('assets/GameSong.mp3', 'static')
s1 = love.audio.newSource('assets/Carrot.mp3', 'static')
s2 = love.audio.newSource('assets/BadCarrot.mp3', 'static')
s3 = love.audio.newSource('assets/WorstCarrot.mp3', 'static')

-- Загрузка спрайтшита
Hare = love.graphics.newImage('assets/HareSheet.png')
GoldenCarrot = love.graphics.newImage('assets/GoldenCarrotSheet.png')
Carrot = love.graphics.newImage('assets/CarrotSheet.png')
BadCarrot = love.graphics.newImage('assets/BadCarrotSheet.png')
WorstCarrot = love.graphics.newImage('assets/WorstCarrotSheet.png')
CTile = love.graphics.newImage('assets/Tile.png')
PTile = love.graphics.newImage('assets/PlantedTile.png')


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
	
	t = love.math.random(10,13)
	
	Veg = {
	x = board.tx,
	y = board.ty,
	ShouldDestroy = false,
	grade = 5,
	pic = Carrot,
	sound = s1,
	timer = t,
	Fresh = 2
	}
	
	table.insert(self,Veg)
end

function VegUpdate(a,VegActive)

	 
	a.timer = a.timer - 1 
	
	if a.timer == 0 then
		if a.Fresh == 2 then
			
			a.Fresh = 1
			a.timer = 7
			a.pic = BadCarrot
			a.grade = 2
		end	
		if a.Fresh == 1 then
			
			a.Fresh = 0
			a.timer = 20
			a.pic = WorstCarrot
			a.grade = -10
		end
		if a.Fresh == 0 then
		
			table.remove(VegActive,a.Veg)
		
		end
		
	end

end


-- Костыль: после хода переменная Pressed становится истинной, тогда при следующей итерации ход не осуществится, пока не сработает следующая функция
-- Если кнопка не нажата, то Pressed становится ложной 
function EndTurn(board)
		-- Проверяет, отпустил ли кнопку игрок после своего действия
	if  board.Pressed == true and love.keyboard.isDown('w','a','s','d','space') == false then
		board.Pressed = false
		-- После окончания действия игрока, начинается окончание хода, где происходят действия остальных вещей
		
		-- Функция обновляет состояние всех клеток с семенами - они сокращают свой таймер, приближая вырастание морковок
		for l,a in ipairs(cells) do
			if a.Growing == true then
				a.pic = PTile
			field.CellUpdate(a,board)
			end
		end
		
		for i, a in ipairs(VegActive)do
			
			VegUpdate(a,VegActive)
		
		end
		
		-- Если флаг Grown отмечен, убирает отметку и создает овощ
		if board.Grown == true then
			board.Grown = false
			GrowVeg(VegActive,board)
		end
		board.tx = tile * math.random(0,HorCell-2)+tile/2
		board.ty = tile * math.random(1,VerCell-2)+tile/2
		--GrowVeg(VegActive,board)
		for i,a in ipairs(VegActive)do 
			Harvest(a,player)
			if a.ShouldDestroy == true then
				board.Carrot = board.Carrot + a.grade*10
				
				
				a.sound:play()
				table.remove(VegActive,i)
			end
		end
		board.Carrot = board.Carrot - 1
		board.score = board.score + 1
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

function ShowCarrot(Board)
	love.graphics.setColor(1,0,1)
	love.graphics.print('Your Carrot: '.. Board.Carrot,Board.tile/2,Board.tile/2,0,3,3)
	love.graphics.setColor(1,1,1)
	love.graphics.print('Hare',Board.tile*6,Board.tile/2,0,3,3) 
	love.graphics.setColor(0,1,0)
	love.graphics.print(' Garden',Board.tile*7+20,Board.tile/2,0,3,3) 
end

function GameOver(Board)
	if Board.Carrot <= 0 then 
		Board.GameOn = 2 
		love.audio.stop( )
		GO:setLooping(true)
		GO:play()
	end
end

function love.load()
	love.audio.stop( )
	Board.score = 0
	Board.GameOn = 0
	Board.Carrot = 25
	
	GS:setLooping(true)
	GS:play()
		
	-- Список овощей
	
	
	-- Анимация всех морковок
	carrotAnimation = anim.idle(0,11,54,54,GoldenCarrot)

	
	
	-- Задание анимации ничегонеделания для зайца-игрока и подготовка для смены анимаций при смене состояний
	playerAnimation.idle = anim.idle(0,7,55,47,Hare)
	playerAnimation.current = playerAnimation.idle
	
	-- Генерация поля
	cells = field.GenCells(HorCell-2,VerCell-2,tile,CTile)
end

function love.update(dt)
	if Board.GameOn == 0 then
		if love.keyboard.isDown('space') then
			Board.GameOn = 1
		end
	end
	if Board.GameOn == 1 then
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
		
		if Board.Carrot >= 1000 then
			
			Board.GameOn = 3
		
		end
		
	end	
	if Board.GameOn == 2 then
		if love.keyboard.isDown('space') then
			love.load()
		end
	end
end


function love.draw()
	-- Фон серый, видно только по краям
	
	
	BackgroundColor(Board)
	if Board.GameOn == 0 then
		love.graphics.setColor(1,1,1)
		love.graphics.print('Reach ',Board.width/2-140,Board.height/2-50,0,3,3)
		love.graphics.setColor(251/255,242/255,52/255)
		love.graphics.print('1000',Board.width/2,Board.height/2-50,0,3,3)
		love.graphics.setColor(1,1,1)
		love.graphics.print('in least amount of moves!',Board.width/4,Board.height/2,0,2,2)
	end
	if Board.GameOn == 1 then
		-- Вывод Счета
		ShowCarrot(Board)
		-- Отрисовка клеток
		field.DrawCells(tile,cells,HorCell-1,VerCell-1)
		
		-- Отрисовка зайца
		love.graphics.setColor(1,1,1)
		EntityDraw(playerAnimation.current,Hare,player.x,player.y)
		
		-- Отрисовка всех морковок
		for i, a in ipairs(VegActive)do
			EntityDraw(carrotAnimation,a.pic,a.x,a.y)
		end
	end
	if Board.GameOn == 2 then
		
		
		
		love.graphics.setColor(1,1,1)
		love.graphics.print('Game Over!',Board.width/2-100,Board.height/2-25,0,3,3)
		love.graphics.print('You Collected: ',Board.width/2-150,Board.height/2+20,0,3,3)
		love.graphics.print(Board.Carrot,Board.width/2+120,Board.height/2+20,0,3,3)
	end
	if Board.GameOn == 3 then
		if s == true then
			--Win:play()
			s = false
		end
		
		if love.audio.getActiveSourceCount( ) == 0 then
			s = true
		end
		love.graphics.setColor(1,1,1)
		love.graphics.print('You Won!',Board.width/2-100,Board.height/2-25,0,3,3)
		love.graphics.print('You Scored: ',Board.width/2-120,Board.height/2+20,0,3,3)
		love.graphics.print(Board.score,Board.width/2+100,Board.height/2+20,0,3,3)
	end
end
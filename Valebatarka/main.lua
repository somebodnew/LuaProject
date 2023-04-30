
-- ГРАФИКА И КАРТИНКИ
love.graphics.setDefaultFilter("nearest","nearest")
ValebatPic = love.graphics.newImage('ValebatSheet.png')
El = love.graphics.newImage('ElGuttaest.png')
Ma = love.graphics.newImage('Maus.png')
PI = love.graphics.newImage('Pit.png')

E0 = love.graphics.newImage('El0.png')
M0 = love.graphics.newImage('mais0.png')
P0 = love.graphics.newImage('pit0.png')

Ed = love.graphics.newImage('Eldead.png')
Md = love.graphics.newImage('mausdead.png')
Pd = love.graphics.newImage('pitdead.png')

Act1 = love.graphics.newImage('Idle.png')
Act2 = love.graphics.newImage('Attack.png')
Act3 = love.graphics.newImage('Defence.png')

-- ДРУГИЕ ФАЙЛЫ С КОДОМ
local anim = require('anim')


-- ТАБЛИЦЫ АНИМАЦИЙ
local playerAnimation = {
	
}

local ELGUTTAESTAnim = {

}
local MAUSAnim = {

}
local PITAnim = {

}

local Attack1 = {
	typ = love.math.random(2)
}

local Attack2 = {
	typ = love.math.random(2)
}

local Attack3 = {
	typ = love.math.random(2)
}


local action1Animation = {
	
}
local action2Animation = {
	
}
local action3Animation = {
	
}
local actionsAnimation = {
	
}


-- ШТУКА ДЛЯ ВЫБОРА ДЕЙСТВИЯ
local choice = {
	turn = 0,
	cho = 0,
	Game = 0
}

-- ТАБЛИЦА ДЛЯ ПОДВОДОК ВЫБРАННЫХ ДЕЙСТВИЙ
local act = {
	t1 = 0,
	t2 = 0,
	t3 = 0,
	dmg = 0,
	def = 0
}

-- КООРДИНАТЫ ИГРОКА
local player = {
	 
	x = 40, y = 152,
	
}
local enemies = {
	x = 650, y = 250,
	x1 = 550, y1 = 152,
	x2 = 650, y2 = 52
}

-- КООРДИНАТЫ КАРТИНОК ДЕЙСТВИЙ, У ДЛЯ ВСЕХ ОБЩАЯ
local action = {
	x = 140, y = 152,
	x1 = 220, x2 = 300
	
}

local HBarPit = {
	r = 195, g = 164, b = 199,
	x = 650, y = 350,
	w = 100, h = 20,
	scale = 1,hp = 1000, dhp = 750
}
HBarPit.name = tostring(HBarPit.hp)..'/1000'

local HBarMaus = {
	r = 120, g = 90, b = 26,
	x = 650, y = 152,
	w = 75, h = 20,
	scale = 1,hp = 750, dhp = 750
}

local HBarEl = {
	r = 151, g = 208, b = 169,
	x = 550, y = 252,
	w = 50, h = 20,
	scale = 1,hp = 500,dhp = 500
}

local HBarPlayer = {
	r = 241, g = 191, b = 62,
	x = 40, y = 252,
	w = 50, h = 20,
	scale = 1,hp = 1000,dhp = 1000
}

HBarPlayer.name = tostring(HBarPlayer.hp)..'/'..tostring(HBarPlayer.dhp)
HBarPit.name = tostring(HBarPit.hp)..'/'..tostring(HBarPit.dhp)
HBarMaus.name = tostring(HBarMaus.hp)..'/'..tostring(HBarMaus.dhp)
HBarEl.name = tostring(HBarEl.hp)..'/'..tostring(HBarEl.dhp)
-- ТАБЛИЦА БЛОКОВ И КНОПОК МЕНЮ
local GUI = {

}

function love.load()
	-- НАСТРОЙКИ ОКНА
	WIW = 768
	WIH = 600
	love.graphics.setBackgroundColor(1, 1, 1)
	success = love.window.setMode(WIW,WIH)
	
	PITAnim.faint = anim.idle(0,1,48,48,P0)
	MAUSAnim.faint = anim.idle(0,1,48,48,M0)
	ELGUTTAESTAnim.faint = anim.idle(0,1,48,48,E0)
	
	
	ELGUTTAESTAnim.idle = anim.idle(0,3,48,48,El)
	ELGUTTAESTAnim.current = ELGUTTAESTAnim.idle
	ELGUTTAESTAnim.pic = El
	
	PITAnim.idle = anim.idle(0,3,48,48,PI)
	PITAnim.current = PITAnim.idle
	PITAnim.pic = PI
	
	MAUSAnim.idle = anim.idle(0,3,48,48,Ma)
	MAUSAnim.current = MAUSAnim.idle
	MAUSAnim.pic = Ma
	
	
--  АНИМАЦИИ ВАЛЕБАТА
	playerAnimation.idle = anim.idle(0,3,48,48,ValebatPic)
	playerAnimation.current = playerAnimation.idle
	
--  АНИМАЦИИ ДЕЙСТВИЙ
	actionsAnimation.idle = anim.idle(0,3,32,48,Act1)
	actionsAnimation.attack = anim.idle(0,3,32,48,Act2)
	actionsAnimation.defend = anim.idle(0,3,32,48,Act3)
	
	action1Animation.current = actionsAnimation.idle
	action1Animation.pic = Act1
	
	action2Animation.current = actionsAnimation.idle
	action2Animation.pic = Act1
	
	action3Animation.current = actionsAnimation.idle
	action3Animation.pic = Act1
	
	--	БЛОКИ ПОД ДЕЙСТВИЯ
	Menu = {  
			r = 241, g = 191, b = 62,
			x = 0, y = 400,
			w = love.graphics.getWidth( ), h =  love.graphics.getHeight( )-400,
			name = 'MENU',scale = 1
			}
	table.insert(GUI,Menu)
	for i = 0,2 do
		for j = 0,2 do
			if j == 0 then 
				na = 'Nothing'
				r = 155
				g = 173
				b = 183
			elseif j == 1 then
				na = 'Attack'
				r = 198
				g = 16
				b = 16
			else 
				na = 'Defend'
				r = 99
				g = 155
				b = 255
			end
			btn = {
				r = r, g = g, b = b,
				x = 20+200*i, y = 425+50*j,
				w = 200, h =  50,
				name = na,scale = 2
				}
			table.insert(GUI,btn)
		end
	end

end




			

-- 	ВЫДЕЛЕНИЕ КУРСОРА ВЫБОРА

LINE = {
	r = 255,
	g = 255,
	b = 255,
	p = -1,
	timer = 5
}
--  ВЫДЕЛЕНИЕ ВЫБРАННЫХ ДЕЙСТВИЙ
FINLINE = {
	
}

-- СМЕНА ЦВЕТА ДЛЯ ОБВОДКИ СДЕЛАННОГО ВЫБОРА И КУРСОРА ВЫБОРА
function UpdCol(self,dt)
	self.timer = self.timer - dt*10
	if self.timer <= 0 then
		self.timer = 5
		self.r = self.r+self.p*255
		self.g = self.g+self.p*255
		self.b = self.b+self.p*255
		self.p = self.p*(-1)
	end
end

-- ОТРИСОВКА КУРСОРА
function colDraw(self,choice)
	love.graphics.setColor(self.r/255,self.g/255,self.b/255)
	love.graphics.rectangle('line', 20+200*choice.turn, 425+50*choice.cho, 200, 50)
	--
end

-- ОТРИСОВКА ВЫБРАННЫХ ДЕЙСТВИЙ
function choDraw(self)
	love.graphics.setColor(self.r/255,self.g/255,self.b/255)
	love.graphics.rectangle('line', self.x,self.y, 190, 40)
end

function DealDmg(someone)
		someone.hp  = someone.hp  -  love.math.random(50,200)
		if someone.hp < 0 then someone.hp = 0 end
		someone.w = someone.hp / 10
		someone.name = tostring(someone.hp)..'/'..tostring(someone.dhp)
	
	
	
	
end

function Defend(self)
	self.hp  = self.hp  +  love.math.random(0,500)
	if self.hp >= 2000 then
		self.hp = 2000
		
	end
	self.w = self.hp / 10
	self.name = tostring(self.hp)..'/1000'
end

function DeathCheck(self)
	if self.hp<=0 then
		return true
	end
end

function Exe(act,E,M,P,self)
	if act.t1 == 1 then
		act.dmg = act.dmg + 1
	elseif act.t1 == 2 then
		act.def = act.def + 1
	end
	if act.t2 == 1 then
		act.dmg = act.dmg + 1
	elseif act.t2 == 2 then
		act.def = act.def + 1
	end
	if act.t3 == 1 then
		act.dmg = act.dmg + 1
	elseif act.t3 == 2 then
		act.def = act.def + 1
	end
	for i = 1,act.dmg do 
		c = love.math.random(3)
		if c == 3 then
			DealDmg(E)
		end
		if c == 2 then
			DealDmg(M)
		end
		if c == 1 then
			DealDmg(P)
		end
	end
	for i = 1, act.def do
		Defend(self)
	end
	act.dmg = 0
	act.def = 0
	
	
	

end




-- ЭТО ОТВЕЧАЕТ ЗА ВЫБОР ДЕЙСТВИЙ
function love.keypressed(key) 
if choice.Game == 0 then	
	if key == 'return' then 
		-- ЕСЛИ ВЫБРАНА ПЕРВАЯ КОЛОНКА
		if choice.turn == 0 then
			-- 0 - НИЧЕГО, 1 - АТАКА, 2 - ЗАЩИТА
			if choice.cho == 0 then 
				action1Animation.current = actionsAnimation.idle
				action1Animation.pic = Act1
			elseif choice.cho == 1 then 
				action1Animation.current = actionsAnimation.attack
				action1Animation.pic = Act2
			else 
				action1Animation.current = actionsAnimation.defend
				action1Animation.pic = Act3		
			end
			act.t1 = choice.cho
		-- ЕСЛИ ВЫБРАНА ВТОРАЯ КОЛОНКА
		elseif choice.turn == 1 then
			-- 0 - НИЧЕГО, 1 - АТАКА, 2 - ЗАЩИТА
			if choice.cho == 0 then 
				action2Animation.current = actionsAnimation.idle
				action2Animation.pic = Act1
			elseif choice.cho == 1 then 
				action2Animation.current = actionsAnimation.attack
				action2Animation.pic = Act2
			else 
				action2Animation.current = actionsAnimation.defend
				action2Animation.pic = Act3			
			end
			act.t2 = choice.cho
			
		-- ЕСЛИ ВЫБРАНА ТРЕТЬЯ КОЛОНКА	
		else 
			-- 0 - НИЧЕГО, 1 - АТАКА, 2 - ЗАЩИТА
			if choice.cho == 0 then 
				action3Animation.current = actionsAnimation.idle
				action3Animation.pic = Act1
			elseif choice.cho == 1 then 
				action3Animation.current = actionsAnimation.attack
				action3Animation.pic = Act2
			else 
				action3Animation.current = actionsAnimation.defend
				action3Animation.pic = Act3			
			end
			
			act.t3 = choice.cho
		end
		
		local fl = {
		r = 255,
		g = 255,
		b = 255,
		p = -1,
		timer = 5,
		x = 25+200*choice.turn, y = 430+50*choice.cho
		}
		for i, a in ipairs(FINLINE) do
			if fl.x == a.x then
				table.remove(FINLINE,i)
			end
	
		end
		table.insert(FINLINE,fl)
	end
	if key == 'up' and choice.cho > 0 then 
		choice.cho = choice.cho - 1
	end
	if key == 'down' and choice.cho < 2 then 
		choice.cho = choice.cho + 1
	end
	if key == 'right' and choice.turn < 2 then
		choice.turn = choice.turn + 1
	end
	if key == 'left' and choice.turn > 0 then
		choice.turn = choice.turn - 1
	end
	if key == 'space' then
		Exe(act,HBarEl,HBarMaus,HBarPit,HBarPlayer)
		for i, a in ipairs(FINLINE)do
		table.remove(FINLINE,i)
		end
		
		if DeathCheck(HBarPit) == true and DeathCheck(HBarEl) == true and DeathCheck(HBarMaus) == true then
			choice.Game = 2
		end
		
		if DeathCheck(HBarMaus) == false then 
			if Attack1.typ == 1 then 
				DealDmg(HBarPlayer)
				DealDmg(HBarPlayer)
				Attack1.typ = love.math.random(2) 
			else 
				DealDmg(HBarPlayer)
			end
		end
		if DeathCheck(HBarPit) == false then 
			if Attack2.typ == 1 then 
				DealDmg(HBarPlayer)
				DealDmg(HBarPlayer)
				Attack2.typ = love.math.random(2) 
			else 
				DealDmg(HBarPlayer)
			end
		end
		if DeathCheck(HBarMaus) == false then 
			if Attack2.typ == 1 then 
				DealDmg(HBarPlayer)
				DealDmg(HBarPlayer)
				Attack3.typ = love.math.random(2) 
			else 
				DealDmg(HBarPlayer)
			end
		end
		
		if DeathCheck(HBarPlayer) == true then
			choice.Game = 1
		end
		choice.turn = 0
		choice.cho = 0
	
	end
end
end



function GUIDraw(self)
	
	love.graphics.setColor(self.r/255,self.g/255,self.b/255)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	love.graphics.setColor(1-self.r/255,1-self.g/255,1-self.b/255)
	love.graphics.print(self.name,self.x+5, self.y+5,0,self.scale)			
	
end

local TITLE = {
	r = 200, g = 160, b = 120,
	x = 200, y = 0,
	w = 300, h = 60,
	scale = 3
}

--   !!! ВАЖНО ДЛЯ АНИМАЦИ !!!

function love.update(dt)
	UpdCol(LINE,dt)
	anim.update(playerAnimation.current, dt)
	anim.update(MAUSAnim.current, dt)
	anim.update(ELGUTTAESTAnim.current, dt)
	anim.update(PITAnim.current, dt)
	anim.update(action1Animation.current, dt)
	anim.update(action2Animation.current, dt)
	anim.update(action3Animation.current, dt)
	
	for i, a in ipairs(FINLINE) do
		UpdCol(a,dt)
	
	end
	
	if HBarPit.hp == 0 then
		PITAnim.current = PITAnim.faint
		PITAnim.pic = P0
	end
	if HBarEl.hp == 0 then
		ELGUTTAESTAnim.current = ELGUTTAESTAnim.faint
		ELGUTTAESTAnim.pic = E0
	end
	if HBarMaus.hp == 0 then
		MAUSAnim.current = MAUSAnim.faint
		MAUSAnim.pic = M0
	end
	
	if choice.Game == 0 then 
		TITLE.name = 'FIGHT!!!'
	elseif choice.Game == 1 then
		TITLE.name = 'You Lost...('
	else 
		TITLE.name = 'YOU WON!'
		ELGUTTAESTAnim.pic = Ed
		MAUSAnim.pic = Md
		PITAnim.pic = Pd
		
	end
end

function love.draw()

	-- АНИМАЦИИ ВАЛЕБАТА И ДЕЙСТВИЙ
	anim.draw(playerAnimation.current,ValebatPic,player.x,player.y)
	anim.draw(ELGUTTAESTAnim.current,ELGUTTAESTAnim.pic,enemies.x1,enemies.y1)
	anim.draw(MAUSAnim.current,MAUSAnim.pic,enemies.x2,enemies.y2)
	anim.draw(PITAnim.current,PITAnim.pic,enemies.x,enemies.y)
	anim.draw(action1Animation.current,action1Animation.pic,action.x,action.y)
	anim.draw(action2Animation.current,action2Animation.pic,action.x1,action.y)
	anim.draw(action3Animation.current,action3Animation.pic,action.x2,action.y)
	
	
	
	-- ОТРИСОВКА МЕНЮ УПРАВЛЕНИЯ ИГРОЙ
	for i,a in ipairs(GUI) do
	
		GUIDraw(a)
	end
	GUIDraw(HBarPit)
	GUIDraw(HBarEl)
	GUIDraw(HBarMaus)
	GUIDraw(HBarPlayer)
	GUIDraw(TITLE)
	
	colDraw(LINE,choice)
	
	for i, a in ipairs(FINLINE) do
		choDraw(a)
	
	end
	
end

function love.load()
	tile = 30
	love.graphics.setBackgroundColor(1, 1, 1)
	r = 195
	g = 164
	b = 199
	p = 1
	sec = 0
	timer = 2.5
	cells = {}
	for i = 0, 20 do
		for j = 0, 17 do
			
				
			
			cell = {
			x = i*tile+tile/2,
			y = j*tile+tile/2,
			i = i,
			j = j,
			color = 0.5 + 0.5*bit.band((i+j),1),
			
			}
			
			table.insert(cells, cell)
			
		end
	end
	
end



function love.update(dt)
	timer = timer - dt*10
	if timer <= 0 then
		timer = 5
		r = r+p*46
		g = g+p*27
		b = b-p*137
		p = p*(-1)
		sec = sec+1
	end
	
	for i, a in ipairs(cells) do
		a.color = 0.5 + 0.5*bit.band((a.i+a.j+sec),1)
	end
	
end

function love.draw()
	
	for i, a in ipairs(cells) do
		love.graphics.setColor(r/255,g/255,b/255,a.color)
		love.graphics.rectangle("fill",
			a.x,
			a.y,
			tile,
			tile
			)
	end
	
	

end
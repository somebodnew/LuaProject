function GenCells(HorCell,VerCell,tileSize)
	cells = {}
	for i = 0, HorCell do
		for j = 1, VerCell do
			local c = math.pow(-1,i)*math.pow(-1,j)
			cell = {
			x = i*tileSize+tileSize/2,
			y = j*tileSize+tileSize/2, 
			defaultColor = {c,c,c},
			color = {c,c,c},
			timer = 0,
			Growing = false}
			
			table.insert(cells, cell)
			
		end
	end
	return cells
end
--grade = 0
function DrawCells(tileSize,cells)

	for l,a in ipairs(cells) do 
		love.graphics.setColor(a.color,a.color,a.color)
		love.graphics.rectangle("fill",a.x,a.y,tileSize,tileSize)

	end
	
end

function PlantCell(cells,player)

	for l,a in ipairs(cells) do 
		
		if a.x == player.x and a.y == player.y then 
			a.color = {171/255,82/255,54/255} 
			a.Growing = true
			a.timer = 15
		end

	end
end

function Harvest(Plant,player)

	if Plant.x == player.x and Plant.y == player.y then 
		Plant.ShouldDestroy = true
	end

end


function CellUpdate(cells,board)
	
	for l,a in ipairs(cells) do 
		
		if a.Growing == true  then 
			a.timer = a.timer - 1 
			
			if a.timer == 0 then
				a.Growing = false
				a.color = a.defaultColor
				board.tx = a.x
				board.ty = a.y
				board.Grown = true
			end
		end
		
	end

end
return {
	GenCells = GenCells,
	DrawCells = DrawCells,
	PlantCell = PlantCell,
	CellUpdate = CellUpdate,
	Harvest = Harvest
}
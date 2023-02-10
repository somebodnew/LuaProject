function GenCells(HorCell,VerCell,tileSize,pc)
	cells = {}
	for i = 0, HorCell do
		for j = 1, VerCell do
			
			cell = {
			x = i*tileSize+tileSize/2,
			y = j*tileSize+tileSize/2, 
			timer = 0,
			Growing = false,
			pic = pc,
			defpic = pc}
			
			table.insert(cells, cell)
			
		end
	end
	return cells
end
--grade = 0
function DrawCells(tileSize,cells)

	for l,a in ipairs(cells) do 
		love.graphics.setColor(1,1,1)
		love.graphics.draw(a.pic,a.x,a.y)

	end
	
end

function PlantCell(cells,player)

	for l,a in ipairs(cells) do 
		
		if a.x == player.x and a.y == player.y then 
			
			a.Growing = true
			a.timer = 5
		end

	end
end

function Harvest(Plant,player)

	if Plant.x == player.x and Plant.y == player.y then 
		Plant.ShouldDestroy = true
	end

end


function CellUpdate(a,board)
	
	 
		
		if a.Growing == true  then 
			a.timer = a.timer - 1 
			
			if a.timer == 0 then
				a.Growing = false
				a.color = a.defaultColor
				a.pic = a.defpic
				board.tx = a.x
				board.ty = a.y
				board.Grown = true
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
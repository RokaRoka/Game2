game_map = {}
game_map = Gamestate.new()

function game_map:init()
	--array enum
	--1 - Blank "Blank square."
	--2 - Snow "A tile for snow, the majority of the map."
	--3 - Road "A path that may lead somewhere"
	--4 - Grass "Not all of the ground is dirtied with the power of Winter"

	--initialize images
	texture = {}
	texture.img = love.graphics.newImage("Assets/Images/Textures/tile_snow.png")
	texture[1] = love.graphics.newQuad(0, 0, 64, 64, texture.img:getDimensions())
	texture.blank = texture[1]
	texture[2] = love.graphics.newQuad(64, 0, 64, 64, texture.img:getDimensions())
	texture.snow = texture[2]
	texture[3] = love.graphics.newQuad(0, 64, 64, 64, texture.img:getDimensions())
	texture.road = texture[3]
	texture[4] = love.graphics.newQuad(64, 64, 64, 64, texture.img:getDimensions())
	texture.grass = texture[4]

	map1 = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row1
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row2
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row3
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} --row4
	}
end

function game_map:enter()
	--create world
	world = love.physics.newWorld(0, 0)

	BG_southend = createMapTileBatch(map1) 
	--[[
	--create textures
	firstSnow = {}
	firstSnow.sprBat = love.graphics.newSpriteBatch(texture.snow, 16, "static")
	--first row
	firstSnow.tL = firstSnow.sprBat:add(0, 0)
	firstSnow.tM1 = firstSnow.sprBat:add(64, 0)
	firstSnow.tM2 = firstSnow.sprBat:add(64 + 64, 0)
	firstSnow.tR = firstSnow.sprBat:add(64 + 64 + 64, 0)
	--second row
	firstSnow.mL = firstSnow.sprBat:add(0, 64)
	firstSnow.mM1 = firstSnow.sprBat:add(64, 64)
	firstSnow.mM2 = firstSnow.sprBat:add(64 + 64, 64)
	firstSnow.mR = firstSnow.sprBat:add(64 + 64 + 64, 64)
	--third row
	firstSnow.m2L = firstSnow.sprBat:add(0, 64 + 64)
	firstSnow.m2M1 = firstSnow.sprBat:add(64, 64 +64)
	firstSnow.m2M2 = firstSnow.sprBat:add(64 + 64, 64 + 64)
	firstSnow.m2R = firstSnow.sprBat:add(64 + 64 + 64, 64 + 64)
	--forth row
	firstSnow.bL = firstSnow.sprBat:add(0, 64 + 64 + 64)
	firstSnow.bM1 = firstSnow.sprBat:add(64, 64 + 64 + 64)
	firstSnow.bM2 = firstSnow.sprBat:add(64 + 64, 64 + 64 + 64)
	firstSnow.bR = firstSnow.sprBat:add(64 + 64 + 64, 64 + 64 + 64)
	]]
	--create player
	player = Player(50, 50)
	--create houses

	--create interactables

	--create title of area
	area_title = "South End"
	area_window = Window((800/2) - (128/2), 0, 128, 48, nil, area_title)
end

function game_map:update(dt)
	Window.updateAll(dt)
	Object.updateAll(dt)
end

function game_map:draw()
	love.graphics.draw(BG_southend.sprBat, 0, 0)
	Window.drawAll()
	Object.drawAll()
end


function createMapTileBatch(arrayData)
	local tileBatch = {}
	tileBatch.sprBat = love.graphics.newSpriteBatch(texture.snow, 64, "static")
	for k, v in pairs(arrayData) do
		for j, i in pairs(v) do
			tileBatch.sprBat:add(texture[i], (j*64)-64, k)
		end
	end

	return tileBatch
end
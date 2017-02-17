--It's Cold - A (narrative) personal project by Sam Scott
--This game is about someone just trying to get inside. It's cold out, you know?
--The player can walk around the world. They can talk. They can receive items.
--The world is built up with places/people to interact

--set up HUMP
Class = require("hump.class")
Gamestate = require("hump.gamestate")
vector = require("hump.vector")

--classes
Debug = Class{
	init = function(self, text)
		self.text = text
		self.drawable = true
	end
}

Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		self.drawable = false

		self.obj_i = Object.obj_i + 1
		Object.all[self.obj_i] = self
		Object.obj_i = self.obj_i

		self.debug = Debug("Object "..self.obj_i.." Spawned!")
	end,
	all = {}, obj_i = 0,

	updateAll = function(dt)
		for i = 1, Object.obj_i do
			local current = Object.all[Object.obj_i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, Object.obj_i do
			local current = Object.all[Object.obj_i]
			--do this later, for now, draw hitboxes
			if current.drawable then
				--love.graphics.draw
			end
			if current.debug.drawable then
				love.graphics.rectangle("line", current.pos.x, current.pos.y, current.w, current.h)
			end
		end
	end
}

--TODO CLASS Background = Class{}

Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)
	end,

	--player default values
	speed = 100
}

function Player:update(dt)
	self:walk(dt)
end

function Player:walk(dt)
	if love.keyboard.isDown('left') then
        self:move(dt, -1, 0)
    elseif love.keyboard.isDown('right') then
        self:move(dt, 1, 0)
    end
    if love.keyboard.isDown('up') then
        self:move(dt, 0, -1)
    elseif love.keyboard.isDown('down') then
        self:move(dt, 0, 1)
    end
end

function Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	delta:normalizeInplace()
	self.pos = self.pos + delta * self.speed * dt
end

--Require files
require("color_shortcut")

function love.load()
	--initialize images
	texture = {}
	texture.snow = love.graphics.newImage("Assets/Images/Textures/tile_snow.png")
	--create world
	world = love.physics.newWorld(0, 0)
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
	--create player
	player = Player(50, 50)
	--create houses

end

function love.update(dt)
	Object.updateAll(dt)
end

function love.draw()
	love.graphics.draw(firstSnow.sprBat, 0, 0)
	Object.drawAll()
end
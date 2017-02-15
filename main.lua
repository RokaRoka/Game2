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

		self.obj_i = Object.obj_i + 1
		Object.all[self.obj_i] = self
		Object.obj_i = self.obj_i

		self.debug = Debug("Object "..self.obj_i.." Spawned!")
	end,
	all = {}, obj_i = 0,

	drawAll = function()
		for i = 1, Object.obj_i do
			local current = Object.all[Object.obj_i]
			--do this later, for now, draw hitboxes love.graphics.draw()
			local x, y = current.pos:unpack()
			love.graphics.rectangle("line", x, y, current.w, current.h)
		end
	end
}

--TODO CLASS Background = Class{}

Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)

	end

}


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
	firstSnow.tL = firstSnow.sprBat:add(64, 64)
	firstSnow.tM1 = firstSnow.sprBat:add(64 + 64, 64)
	firstSnow.tM2 = firstSnow.sprBat:add(64 + 64 + 64, 64)
	firstSnow.tR = firstSnow.sprBat:add(64 + 64 + 64 + 64, 64)
	--create player
	player = Player(50, 50)
	--create houses

end

function love.draw()
	love.graphics.draw(firstSnow.sprBat, 0, 0)
	Object.drawAll()
end
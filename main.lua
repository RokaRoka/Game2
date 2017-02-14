--It's Cold - A personal (narrative) project by Sam Scott
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
	end
}

Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h
		self.obj_i = Object.obj_i + 1
		all[self.obj_i] = self
		Object.obj_i = self.obj_i
	end,
	all = {}, obj_i = 0

}

Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)

	end

}


function love.load()
	--create player
	--create world
	--create houses

end
--It's Cold - A (narrative) personal project by Sam Scott
--This game is about someone just trying to get inside. It's cold out, you know?
--The player can walk around the world. They can talk. They can receive items.
--The world is built up with places/people to interact

--set up HUMP
Class = require("hump.class")
Gamestate = require("hump.gamestate")
vector = require("hump.vector")

--preliminary includes
require("collision_masks")
require("objectPhysics")

--classes
Debug = Class{
	init = function(self, text)
		self.text = text
		self.drawable = true

		self.color = {75, 75, 200, 255}
	end
}

Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		--physical body (parent, x, y, type of body, shape, wr, h)
		self.p_body = PhysicsBody(self, self.pos.x, self.pos.y, "static", "rectangle", self.w, self.h)
		--physics trigger
		
		--Interactable, if the object has it
		--self.interact = interact or nil

		self.drawable = false

		self.obj_i = Object.obj_i + 1
		Object.all[self.obj_i] = self
		Object.obj_i = self.obj_i

		self.debug = Debug("Object "..self.obj_i.." Spawned!")
	end,
	all = {}, obj_i = 0,

	updateAll = function(dt)
		for i = 1, Object.obj_i do
			local current = Object.all[i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, Object.obj_i do
			local current = Object.all[i]
			--do this later, for now, draw hitboxes
			if current.drawable then
				current:draw()
			end
			if current.debug.drawable then
				love.graphics.setColor(current.debug.color)
				love.graphics.rectangle("line", current.pos.x - (current.w/2), current.pos.y - (current.h/2), current.w, current.h)
				love.graphics.setColor(255, 255, 255)

				if current.p_trigger then
					love.graphics.circle("line", current.pos.x, current.pos.y, current.p_trigger.shape:getRadius())
				end
			end
		end
	end
}

--TODO CLASS Background = Class{}

Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)
		self.p_body.body:setType("dynamic")
		self.busy = false
		self.in_range_of = {}

		self.drawable = true
	end,

	--player default values
	speed = 100
}

function Player:update(dt)
	if not player.busy then
		self:walk(dt)
		self:checkAction(dt)
	end
end

function Player:walk(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown('left') then
        dx = -1
    elseif love.keyboard.isDown('right') then
        dx = 1
    end
    if love.keyboard.isDown('up') then
        dy = -1
    elseif love.keyboard.isDown('down') then
        dy = 1
    end
    self:move(dt, dx, dy)
end

function Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	
	self.p_body.body:setLinearVelocity(delta.x * self.speed * (dt * 100), delta.y * self.speed * (dt * 100))
	local newPx, newPy = self.p_body.body:getPosition()
	newPx = math.floor(newPx)
	newPy = math.floor(newPy)

	self.pos = vector.new(newPx, newPy)
	--self.pos = self.pos + delta * self.speed * dt
end

function Player:checkAction(dt)
	if self.in_range_of[1] and love.keyboard.isDown('z') then
		self.debug.text = "Player talking!"
		self.in_range_of[1].interact:response()
	end
end

function Player:draw()
	love.graphics.print(self.debug.text, 600, 10)
end

NPC = Class{__includes = Object,
	init = function(self, x, y, w, h, dialogue)
		Object.init(self, x, y, w, h)
		--create trigger zone and pass to interactable
		self.p_trigger = PhysicsTrigger(self, self.p_body, "circle", self.w*1.5)
		self.interact = Talkable(self.p_trigger, dialogue)
	end
}

function NPC:update(dt)
	--something
end

function NPC:draw()
	--draw npc?
end

--Require files
require("color_shortcut")

--Require systemss
require("window")
require("interactable")

--Gamestate scenes
titleScreen = {}
titleScreen = Gamestate.new()
require("map_state") --game_map

function love.load()
	--make screen sizes accessible
	screen = {}
	--screen.w = t.window.width
	--screen.h = t.window.height
	Gamestate.registerEvents()
	Gamestate.switch(debug_room)
end

function love.update(dt)
	--Object.updateAll(dt)
end

function love.draw()
	--Object.drawAll()
end

--physics engine callbacks
function beginContact(fixtureA, fixtureB, contact)
	--do player collisions
	if fixtureA == player.p_body.fixture or fixtureB == player.p_body.fixture then
		player.debug.text = "Colliding!"
		player.debug.color = {25, 25, 255, 255}
		if fixtureA == NPC_npc1.p_trigger.fixture or fixtureB == NPC_npc1.p_trigger.fixture then
			player.debug.text = "In range of npc1"
			player.in_range_of = {NPC_npc1}
		end
	end
end

function endContact(fixtureA, fixtureB, contact)
	--do player collision ends
	if fixtureA == player.p_body.fixture or fixtureB == player.p_body.fixture then
		player.debug.text = "Not colliding!"
		player.debug.color = {75, 75, 175, 255}
		if fixtureA == NPC_npc1.p_trigger.fixture or fixtureB == NPC_npc1.p_trigger.fixture then
			player.in_range_of = {}
		end
	end
end
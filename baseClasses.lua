--BASE CLASS - Debug
--PURPOSE - A base class for debuging information
--STATUS - MODERATELY FUNCTIONAL
Debug = Class{
	init = function(self, text)
		self.text = text
		self.drawable = true

		self.color = {75, 75, 200, 255}
	end
}

--BASE CLASS - Part
--PURPOSE - A base class for all complex object components (Animations, Quests, Hitboxes)
--STATUS - INCOMPLETE
Part = Class{
	init = function(self, parent, name)
		self.parent = parent
		self.name = name
		self.active = true
	end
}

--BASE CLASS - Object
--PURPOSE - A base class for all  objects that appear in the world
--STATUS - MODERATELY FUNCTIONAL
Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		--bool for if the function can be drawn or not
		self.drawable = true

		--physical body (parent, x, y, type of body, shape, wr, h)
		self.p_body = PhysicsBody(self, self.pos.x, self.pos.y, "static", "rectangle", self.w, self.h)
		--physics trigger
		
		--Interactable, if the object has it
		--self.interact = interact or nil

		--Leave an array for parts
		self.parts = {}

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
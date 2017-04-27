Interactable = Class{
	init = function(self, p_trigger)
		self.p_trigger = p_trigger
		self.act_i = 1
	end
}

function Interactable:response()
	--Whether it is dialogue or interactable
end

Talkable = Class{__includes = Interactable,
	init = function(self, p_trigger, dialogue)
		Interactable.init(self, p_trigger)
		self.dialogue = dialogue
	end,
	Type = "Talkable"
}

function Talkable:response()
	Window_Dialogue.DW_Current = Window_Dialogue(self.dialogue)
end

Leverable = Class{__includes = Interactable,
	init = function(self, p_trigger)
		Interactable.init(self, p_trigger)
	end,
	Type = "Leverable"
}

--CLASS - Quest
--[[PURPOSE - Objects that control story beats/level progression.]]
--STATUS - INCOMPLETE
Quest = {__includes = Part,
	init = function(self, parent, name, completed)
		Part.init(self, parent, name)
		
		self.completed = false
	end,
	signals = Signal.new()
}

function Quest:loadSignals()
	self.signal:register(self.name, self:complete()) --add completion function
end

function Quest:complete()
	self.completed = true
end
_G.BTClass = {}
BTClass.__index = BTClass

local function InitDefault(class)
	function class:new(...)
		local ins = {}

		setmetatable(ins, {
			__index = self
		})

		if self.constructor then
			self.constructor(ins, ...)
		end

		return ins
	end

	function class:delete(...)
		if self.destructor then
			self:destructor(...)
		end
	end
end

function BTClass:Class(classname, class, super)
	if self[classname] then
		return self[classname]
	end

	class = class or {}

	InitDefault(class)

	if super then
		setmetatable(class, {
			__index = super
		})
	end

	self[classname] = class

	return class
end

function BTClass:Release(classname)
	self[classname] = nil
end

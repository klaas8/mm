if not BTClass then
	assert(false)

	return
end

if not loadwwwcache then
	assert(false)

	return
end

local BTCommandClass = BTClass:Class("BTCommand")

function BTCommandClass:constructor()
	self.AIFileManager = GetInst("AIFileManager")
	self.LuaInterface = LuaInterface
	self.GetAiCfgFenv = GetAiCfgFenv
	self.loadstring = loadstring
end

function BTCommandClass:LoadConfig(dir, filename)
	local path = dir .. "." .. filename
	local cfg = loadwwwcache(path)

	if not cfg then
		return nil
	end

	return cfg
end

function BTCommandClass:LoadAIEditConfig(filename)
	if not self.filecache then
		self.filecache = {}
	end

	if self:IsAbleUseConfig() and self.filecache[filename] then
		return self.filecache[filename][2]
	end

	local text = self.AIFileManager:LoadReadFile(filename)

	if not text then
		MiniLog("LoadAIEditConfig load nil ", filename)

		return nil
	end

	if IsOpenBtTreeDebug and IsOpenBtTreeDebug() then
		MiniLog("LoadAIEditConfig filename ", filename)
		MiniLog("LoadAIEditConfig text ", text)
	end

	local ok, func = pcall(self.loadstring, text, filename)
	local fenv = self.GetAiCfgFenv()

	if ok and func and fenv then
		setfenv(func, fenv)

		self.filecache[filename] = {
			ok,
			func()
		}

		return self.filecache[filename][2]
	else
		if IsOpenBtTreeDebug and IsOpenBtTreeDebug() then
			local wrfilename = filename:gsub(".lua", "")
			wrfilename = wrfilename .. "1.lua"

			gFunc_deleteFileByFullPath(wrfilename)
			gFunc_writeTxtFileByFullPath(wrfilename, text)
			self.LuaInterface:loadpackage(wrfilename)
			gFunc_deleteFileByFullPath(wrfilename)
		end

		MiniLog("LoadAIEditConfig loadstring err ", filename)
	end

	return nil
end

function BTCommandClass:IsAbleUseConfig()
	if self.WorldMgr == nil then
		self.WorldMgr = WorldMgr
	end

	if self.WorldMgr and self.WorldMgr:IsRentServerHost() then
		return true
	else
		if self.AccountManager == nil then
			self.AccountManager = AccountManager
		end

		if self.AccountManager:getMultiPlayer() == 0 then
			local wdesc = self.AccountManager:getCurWorldDesc()

			if wdesc and wdesc.realowneruin == wdesc.owneruin then
				return false
			end
		end
	end

	return true
end

function BTCommandClass:AIBTLoad(text)
	if type(text) ~= "string" then
		return nil, "text is not a string"
	end

	local ok, func = pcall(self.loadstring, text)

	if not ok then
		local errorMsg = "代码加载失败: " .. tostring(func)

		return nil, errorMsg
	end

	if not func then
		local errorMsg = "loadstring返回空函数"

		MiniLog("LoadAIEditConfigWithErrorHandling: ", errorMsg)

		return nil, errorMsg
	end

	local fenv = self.GetAiCfgFenv()

	if not fenv then
		local errorMsg = "无法获取函数环境"

		MiniLog("LoadAIEditConfigWithErrorHandling: ", errorMsg)

		return nil, errorMsg
	end

	setfenv(func, fenv)

	return func, nil
end

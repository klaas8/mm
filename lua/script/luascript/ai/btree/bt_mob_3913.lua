local function print(...)
	cclog("SmallYakAi__", ...)
end

local ll_BTTask_getRandStollPos = {}

function ll_BTTask_getRandStollPos.run()
	local obj = controller.target.get()
	local pos = {
		y = 0,
		x = 0,
		z = 0
	}
	pos.x, pos.y, pos.z = AIFunctionMgr:GetRandStrollPosBySelf(obj, pos.x, pos.y, pos.z, 8, 8)

	controller.bb.set("stollPos", pos)

	return controller.success()
end

local ll_BTTask_IsHurt = {
	run = function ()
		local obj = controller.target.get()
		local objId = controller.bb.get("bbKeyBeHurtTargetObjId").actor

		if objId > 0 and AIFunctionMgr:getActorByObjId(obj, objId) and (not controller.luabb.runTimes or controller.luabb.runTimes <= 0) then
			controller.luabb.runTimes = 2 + math.random(3)

			return controller.success()
		end

		if controller.luabb.runTimes and controller.luabb.runTimes > 0 then
			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_SubRuntimes = {
	run = function ()
		if controller.luabb.runTimes and controller.luabb.runTimes > 0 then
			controller.luabb.runTimes = controller.luabb.runTimes - 1

			if controller.luabb.runTimes == 0 then
				controller.bb.set("bbKeyBeHurtTargetObjId", {
					actor = 0
				})
			end
		end

		return controller.success()
	end
}
local ll_BTTask_GetNearBlockPos = {
	run = function ()
		local obj = controller.target.get()
		local blockId = controller.subparam.blockId or 1000
		local range = controller.subparam.range or 10
		local isOk, x, y, z = AIFunctionMgr:GetNearestBlockPos(obj, blockId, range, 0, 0, 0)

		if isOk then
			controller.bb.set("findBlockPos", {
				x = x,
				y = y,
				z = z
			})

			return controller.success()
		else
			return controller.fail()
		end
	end
}
local ll_BTTask_Random = {
	run = function ()
		local isOK = math.random(1000) < controller.subparam.rate * 1000

		if isOK then
			return controller.success()
		else
			return controller.fail()
		end
	end
}
local ll_BTTask_Timer = {
	run = function ()
		local tickName = controller.subparam.timerName
		local totalTime = controller.subparam.time
		local isFirstExe = controller.subparam.isFirstExe
		controller.luabb.times = controller.luabb.times and controller.luabb.times or {}
		controller.luabb.times[tickName] = controller.luabb.times[tickName] and controller.luabb.times[tickName] + 1 or 0

		if totalTime == controller.luabb.times[tickName] or isFirstExe and controller.luabb.times[tickName] == 0 then
			if controller.luabb.times[tickName] == totalTime then
				controller.luabb.times[tickName] = 0
			end

			return controller.success()
		else
			return controller.fail()
		end
	end
}
local bt_action_idle_stroll = {
	node = "BTNodeSequence",
	param = {
		tip = "bt_action_idle_stroll"
	},
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_getRandStollPos,
				subparam = {}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 0.8,
				minDistance = 1,
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false
			}
		}
	}
}
local bt_action_random = {
	node = "BTNodeRandom",
	children = {
		bt_action_idle_stroll,
		{
			node = "BTNodeWait",
			param = {
				wait = -1004
			}
		}
	}
}
local bt_action_RunAndPlayAnim = {
	node = "BTNodeSimpleParallel",
	children = {
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 2,
				minDistance = 1,
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				desc = "通用播放动作叶子，所有的播放动作都可用此叶子实现",
				subparam = {}
			}
		}
	}
}
local bt_action_run = {
	node = "BTNodeSequence",
	param = {
		tip = "bt_action_idle_stroll"
	},
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_getRandStollPos,
				subparam = {}
			}
		},
		bt_action_RunAndPlayAnim
	}
}
local bt_Attacked = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_IsHurt,
				subparam = {}
			}
		},
		bt_action_run,
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_SubRuntimes,
				subparam = {}
			}
		}
	}
}
local bt_eatFeed = {
	node = "BTNTaskEatFeedBlock",
	param = {
		max_eat_ticks = 50,
		blockID = 1753
	}
}
local bt_graze = {
	node = "BTNodeSequence",
	param = {},
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Timer,
				subparam = {
					time = 100,
					isFirstExe = true,
					timerName = "graze"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				tip = "ll_BTTask_Random",
				__USE_LOCAL_TABLE_ = ll_BTTask_Random,
				subparam = {
					rate = 0.5
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				tip = "ll_BTTask_GetNearBlockPos",
				__USE_LOCAL_TABLE_ = ll_BTTask_GetNearBlockPos,
				subparam = {
					blockId = 763,
					range = 10
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 3,
				bbkey_targetpos = "findBlockPos",
				CollideHorizontallyStop = false
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 5,
					animID = 100114
				}
			}
		}
	}
}
local ll_BTTask_getHaveFoodPlayer = {
	run = function ()
		local obj = controller.target.get()
		local range = controller.subparam.rangeMax or 3
		local itemID = controller.subparam.itemID or 0
		local uin = AIFunctionMgr:FindPlayerHandleSomeItem(obj, itemID, range)

		controller.bb.set("xiying_target", {
			actor = uin
		})

		if uin == 0 then
			return controller.fail()
		else
			return controller.success()
		end
	end
}
local bt_xiying = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_getHaveFoodPlayer,
				subparam = {
					rangeMax = 5,
					itemID = 11534
				}
			}
		},
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.3,
				minDistance = 2,
				bbkey_followobj = "xiying_target"
			}
		}
	}
}
local bt_main = {
	node = "BTNodePriority",
	children = {
		bt_Attacked,
		{
			node = "BTNodeSelector",
			children = {
				bt_eatFeed,
				bt_xiying,
				bt_graze,
				bt_action_random
			}
		}
	}
}

return bt_main

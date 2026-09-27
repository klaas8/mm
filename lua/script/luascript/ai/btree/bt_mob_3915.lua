local function print(...)
	cclog("IceMonster__", ...)
end

local ll_BTTask_getRandStollPos = {}

function ll_BTTask_getRandStollPos.run()
	local obj = controller.target.get()
	local pos = {
		y = 0,
		z = 0,
		x = 0
	}
	pos.x, pos.y, pos.z = AIFunctionMgr:GetRandStrollPosBySelf(obj, pos.x, pos.y, pos.z, 8, 8)

	controller.bb.set("stollPos", pos)

	return controller.success()
end

local ll_BTTask_IsHurt = {
	run = function ()
		local obj = controller.target.get()
		local objId = controller.bb.get("bbKeyBeHurtTargetObjId").actor

		if objId > 0 and AIFunctionMgr:getActorByObjId(obj, objId) then
			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_IsInRange = {
	run = function ()
		local obj = controller.target.get()
		local objId = controller.bb.get("bbKeyBeHurtTargetObjId").actor
		local enemyObj = GetWorldActorMgr(CurWorld):findActorByWID(objId)

		if enemyObj then
			local x, y, z = enemyObj:getPosition(0, 0, 0)
			x = math.floor(x / 100)
			y = math.floor(y / 100)
			z = math.floor(z / 100)
			local distance = AIFunctionMgr:GetTargetDis(obj, x, y, z)
			local range = controller.subparam.rangeMax or 10

			if distance < range then
				return controller.success()
			end
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
local ll_BTTask_CanPickSnowBall = {
	run = function ()
		local obj = controller.target.get()
		local blockID = AIFunctionMgr:GetStandBlockID(obj)
		local attackObjID = controller.bb.get("bb_attack_target").actor
		local enemyObj = GetWorldActorMgr(CurWorld):findActorByWID(attackObjID)
		local dist = AIFunctionMgr:DistActor2Actor(obj, enemyObj) / 100

		if AIFunctionMgr:GetHoldItemId(obj) == 0 and (blockID == 115 or blockID == 112 or blockID == 160001 or blockID == 161001) and dist >= 5 then
			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_equip = {
	run = function ()
		local obj = controller.target.get()

		AIFunctionMgr:addItemToBags(obj, controller.subparam.itemID, controller.subparam.itemNum)
		AIFunctionMgr:equipWeapon(obj, controller.subparam.itemID, controller.subparam.itemNum)

		if controller.subparam.itemID == 12316 then
			obj:setCustomScale(2.1)

			local dp = 40
			local att = obj:getAttrib()

			att:setMaxHP(att:getMaxHP() + dp)
			att:setHP(att:getHP() + dp)
		end

		return controller.success()
	end
}
local ll_BTTask_CheckArea2Attack = {
	run = function ()
		if CurWorld:isGodMode() then
			return controller.fail()
		end

		local obj = controller.target.get()
		local uin = AIFunctionMgr:findNearPlayer(obj, controller.subparam.range * 100)

		if uin ~= 0 then
			controller.bb.set("bb_attack_target", {
				actor = uin
			})

			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_godNotAttack = {
	run = function ()
		if CurWorld:isGodMode() then
			return controller.fail()
		end

		return controller.success()
	end
}
local ll_BTTask_ResetAttackTarget = {
	run = function ()
		local obj = controller.target.get()
		local hurtID = controller.bb.get("bbKeyBeHurtTargetObjId").actor

		controller.bb.set("bb_attack_target", {
			actor = hurtID
		})

		return controller.success()
	end
}
local ll_BTTask_IsEmptyInHandle = {
	run = function ()
		local obj = controller.target.get()

		if AIFunctionMgr:GetHoldItemId(obj) == 0 then
			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_IsRangeWeapon = {
	run = function ()
		local obj = controller.target.get()
		local itemID = AIFunctionMgr:GetHoldItemId(obj)

		if itemID == 12068 then
			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_ChangeRandom = {
	run = function ()
		local total = controller.subparam.total
		local start = controller.subparam.start
		local _end = controller.subparam._end
		local offset = controller.subparam.offset
		controller.luabb.lastWeight = controller.luabb.lastWeight or start
		local result = math.random(total)
		local isOK = result < controller.luabb.lastWeight

		if controller.luabb.lastWeight <= _end then
			controller.luabb.lastWeight = _end
		else
			controller.luabb.lastWeight = controller.luabb.lastWeight - offset
		end

		if isOK then
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
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false,
				speed = 0.8,
				minDistance = 1
			}
		}
	}
}
local bt_pick_snow_ball = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Timer,
				subparam = {
					time = 10,
					timerName = "pick_snow",
					isFirstExe = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_CanPickSnowBall,
				subparam = {}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				tip = "ll_BTTask_Random",
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Random,
				subparam = {
					rate = 0.15
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 1,
					animID = 100952
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_equip,
				subparam = {
					itemNum = 1,
					itemID = 12068
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3915.snowball"
				}
			}
		}
	}
}
local bt_Attack = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				tip = "ll_BTTask_IsRangeWeapon",
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_IsRangeWeapon,
				subparam = {}
			}
		},
		{
			node = "BTNTaskRangeAttack",
			param = {
				bbkey_attackobj = "bb_attack_target",
				count = 1,
				power = 0.7,
				max_attack_time = 0.5,
				min_attack_time = 0.2,
				bbkey_attackrange = AIFunctionDefsGetDefByKey("longRangeAttackSearch")
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNTaskFollow",
					param = {
						canTeleport = false,
						bbkey_followobj = "bb_attack_target",
						canFollowFly = true,
						speed = 1.1,
						minDistance = 1.5
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_TurnToTarget",
						subparam = {
							bbTargetKey = "bb_attack_target"
						}
					}
				},
				{
					node = "BTNTaskAttack",
					param = {
						bbkey_attackobj = "bb_attack_target",
						keeptick = 45
					}
				}
			}
		}
	}
}
local bt_pickSnowBallAndAttack = {
	node = "BTNodePriority",
	children = {
		bt_pick_snow_ball,
		bt_Attack
	}
}
local bt_fightback = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_ResetAttackTarget,
				subparam = {}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_godNotAttack,
				subparam = {}
			}
		},
		bt_pickSnowBallAndAttack
	}
}
local bt_action_RunAndPlayAnim = {
	node = "BTNodeSimpleParallel",
	children = {
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false,
				speed = 2,
				minDistance = 1
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "通用播放动作叶子，所有的播放动作都可用此叶子实现",
				script = "BTTask_commonPlayAction",
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
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						tip = "ll_BTTask_IsInRange",
						script = "__USE_LOCAL_TABLE_",
						__USE_LOCAL_TABLE_ = ll_BTTask_IsInRange,
						subparam = {
							rangeMax = 14
						}
					}
				},
				bt_fightback,
				{
					node = "BTNodeSequence",
					children = {
						bt_action_run,
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "bbKeyBeHurtTargetObjId",
									valueType = AIFunctionDefsGetDefByKey("valueType").value,
									value = {
										actor = 0
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt_isEmptyEquip = {
	node = "BTNodeTaskLua",
	param = {
		script = "__USE_LOCAL_TABLE_",
		__USE_LOCAL_TABLE_ = ll_BTTask_IsEmptyInHandle,
		subparam = {}
	}
}
local bt_pick_branch = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Timer,
				subparam = {
					time = 10,
					timerName = "pick_branch",
					isFirstExe = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				tip = "ll_BTTask_Random",
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Random,
				subparam = {
					rate = 0.5
				}
			}
		},
		bt_isEmptyEquip,
		{
			node = "BTNodeTaskLua",
			param = {
				tip = "ll_BTTask_GetNearBlockPos",
				script = "__USE_LOCAL_TABLE_",
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
				bbkey_targetpos = "findBlockPos",
				CollideHorizontallyStop = false,
				speed = 1,
				minDistance = 3
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3915.pick"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 1,
					animID = 100950
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_equip,
				subparam = {
					itemNum = 1,
					itemID = 12069
				}
			}
		}
	}
}
local bt_congeal_ice_lolly = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_Timer,
				subparam = {
					time = 30,
					timerName = "pick_ice_lolly",
					isFirstExe = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				tip = "ll_BTTask_ChangeRandom",
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_ChangeRandom,
				subparam = {
					_end = 5000,
					start = 70000,
					total = 1000000,
					offset = 5000
				}
			}
		},
		bt_isEmptyEquip,
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 1,
					animID = 100949
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_equip,
				subparam = {
					itemNum = 1,
					itemID = 12316
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3915.up"
				}
			}
		}
	}
}
local bt_checkAndAttackPlayer = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_CheckArea2Attack,
				subparam = {
					range = 14
				}
			}
		},
		bt_pickSnowBallAndAttack
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
	},
	param = {
		weight = {
			50,
			50
		}
	}
}
local bt_main = {
	node = "BTNodePriority",
	children = {
		{
			node = "BTNodeSelector",
			children = {
				bt_Attacked,
				bt_checkAndAttackPlayer
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_congeal_ice_lolly,
				bt_pick_branch,
				bt_action_random
			}
		}
	}
}

return bt_main

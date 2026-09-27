local function print(...)
	cclog("YakAi__", ...)
end

local ll_BTTask_getRandStollPos = {}

function ll_BTTask_getRandStollPos.run()
	local obj = controller.target.get()
	local pos = {
		x = 0,
		z = 0,
		y = 0
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
		else
			return controller.fail()
		end
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
local ll_BTask_FindBattleYak = {}

function ll_BTask_FindBattleYak.run()
	local normalRate = controller.subparam.normalRate
	local RiddenRate = controller.subparam.ridRate
	local range = controller.subparam.range or 13
	local obj = controller.target.get()
	local yak = tolua.cast(obj, "ActorYak")
	local mob = tolua.cast(obj, "ClientMob")

	controller.bb.set("find_battle_target", {
		actor = 0
	})

	if yak:GetBattleStatu() > 0 or yak:GetHornCount() <= 0 or mob:isInLove() then
		return controller.fail()
	end

	local pAttrib = yak:getLivingAttrib()

	if pAttrib and pAttrib:getBuffEffectBankInfo(2034) then
		return controller.fail()
	end

	local rid = yak:getRiddenByActor()
	local rate = normalRate

	if rid then
		rate = RiddenRate
	end

	if math.random(100) < rate * 100 then
		local otherObjID = AIFunctionMgr:FindNearYakForBattle(obj, range)

		if otherObjID == 0 then
			return controller.fail()
		else
			local otherObj = tolua.cast(GetWorldActorMgr(CurWorld):findActorByWID(otherObjID), "ClientMob")

			if not otherObj:isInLove() then
				local pAttribOhter = otherObj:getLivingAttrib()

				if pAttribOhter and pAttribOhter:getBuffEffectBankInfo(BUFFATTRT_FORBID_OPERATE) then
					return controller.fail()
				end

				controller.bb.set("find_battle_target", {
					actor = otherObjID
				})

				return controller.success()
			else
				return controller.fail()
			end
		end
	else
		return controller.fail()
	end
end

local ll_BTTask_HasHorn = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")

		if yak:GetHornCount() > 0 then
			return controller.success()
		else
			return controller.fail()
		end
	end
}
local ll_BTTask_Battleing = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")

		if yak:GetOtherYakID() > 0 then
			return controller.success()
		else
			return controller.fail()
		end
	end
}
local ll_BTTask_findCanBattleYak = {
	run = function ()
		local obj = controller.target.get()
		local range = controller.subparam.range or 13
		local otherObjID = AIFunctionMgr:FindNearYakForBattle(obj, range)
		controller.luabb.m_findCanBattleYakRet = otherObjID

		if otherObjID == 0 then
			return controller.fail()
		else
			return controller.success()
		end
	end
}
local ll_BTTask_IsInBattleRange = {
	run = function ()
		local obj = controller.target.get()
		local range = controller.subparam.range
		local otherObjID = controller.bb.get(controller.subparam.otherID).actor
		local otherObj = GetWorldActorMgr(CurWorld):findActorByWID(otherObjID)

		if otherObj then
			local dist = AIFunctionMgr:DistActor2Actor(obj, otherObj)

			if dist >= 0 and dist < range then
				return controller.success()
			end
		end

		return controller.fail()
	end
}
local ll_BTTask_PairForBattle = {
	run = function ()
		local obj = controller.target.get()
		local otherObjID = controller.bb.get(controller.subparam.otherID).actor
		local otherObj = GetWorldActorMgr(CurWorld):findActorByWID(otherObjID)

		if otherObj then
			local selfYak = tolua.cast(obj, "ActorYak")
			local otherYak = tolua.cast(otherObj, "ActorYak")

			if selfYak and otherYak and selfYak:GetBattleStatu() == 0 and otherYak:GetBattleStatu() == 0 then
				selfYak:SetOtherYakID(otherObjID)
				selfYak:SetBattleStatu(1)
				otherYak:SetOtherYakID(obj:getObjId())
				otherYak:SetBattleStatu(1)

				return controller.success()
			end
		end

		return controller.fail()
	end
}
local ll_BTTask_isReadyBattle = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")

		if yak:GetBattleStatu() == 1 then
			local otherYak = GetWorldActorMgr(CurWorld):findActorByWID(yak:GetOtherYakID())

			if otherYak then
				otherYak = tolua.cast(otherYak, "ActorYak")

				if otherYak:GetOtherYakID() == obj:getObjId() then
					controller.bb.set("find_battle_target", {
						actor = yak:GetOtherYakID()
					})

					return controller.success()
				else
					controller.bb.set("find_battle_target", {
						actor = 0
					})
					yak:SetBattleStatu(0)
					yak:SetOtherYakID(0)
				end
			end
		end

		return controller.fail()
	end
}
local ll_BTTask_needStartBattleOne = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")

		if yak:GetBattleStatu() == 1 then
			local pAttrib = yak:getLivingAttrib()

			if pAttrib and pAttrib:getBuffEffectBankInfo(BUFFATTRT_FORBID_OPERATE) then
				yak:SetBattleStatu(0)
				yak:SetOtherYakID(0)

				return controller.fail()
			end

			local otherYak = GetWorldActorMgr(CurWorld):findActorByWID(yak:GetOtherYakID())

			if otherYak then
				otherYak = tolua.cast(otherYak, "ActorYak")

				if otherYak:GetOtherYakID() == obj:getObjId() then
					local pAttribOther = otherYak:getLivingAttrib()

					if pAttribOther and pAttribOther:getBuffEffectBankInfo(BUFFATTRT_FORBID_OPERATE) then
						otherYak:SetBattleStatu(0)
						otherYak:SetOtherYakID(0)

						return controller.fail()
					end

					yak:SetBattleStatu(2)

					return controller.success()
				else
					yak:SetBattleStatu(0)
					yak:SetOtherYakID(0)
				end
			end
		end

		return controller.fail()
	end
}
local ll_BTTask_lookAtOhter = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")
		local other = GetWorldActorMgr(CurWorld):findActorByWID(yak:GetOtherYakID())

		if other then
			AIFunctionMgr:AdjustLookAtOhter(obj, other)

			return controller.success()
		end

		return controller.fail()
	end
}
local ll_BTTask_BattleOnceEnd = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")

		if math.random(0, 100) < controller.subparam.rate * 100 then
			yak:SetHornCount(0)
			yak:SetBattleStatu(0)
			yak:SetOtherYakID(0)

			if math.random(100) < 50 then
				AIFunctionMgr:dropItem(obj, 12622, 1)
			end
		else
			yak:SetBattleStatu(1)
		end

		local rider = yak:getRiddenByActor()

		if rider and math.random(100) > 50 then
			rider = tolua.cast(rider, "ClientPlayer")

			rider:mountActor(mob)
			rider:getAttrib():addHP(-5)
		end

		return controller.success()
	end
}
local ll_BTTask_AttackFly = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")
		local otherID = yak:GetOtherYakID()

		AIFunctionMgr:AttackFly(obj, GetWorldActorMgr(CurWorld):findActorByWID(otherID), 70)

		return controller.success()
	end
}
local ll_BTTask_IsRidden = {
	run = function ()
		local obj = controller.target.get()
		local yak = tolua.cast(obj, "ActorYak")
		local rider = yak:getRiddenByActor()

		if rider then
			return controller.success()
		end

		return controller.fail()
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
local ll_BTTask_attackCondition = {
	run = function ()
		if CurWorld:isGodMode() then
			return controller.fail()
		end

		local hurtID = controller.bb.get("bbKeyBeHurtTargetObjId").actor
		local obj = controller.target.get()

		if hurtID ~= 0 and AIFunctionMgr:getActorByObjId(obj, hurtID) then
			local yak = tolua.cast(obj, "ActorYak")
			local ridder = yak:getRiddenByActor()

			if ridder then
				local ridderID = ridder:getObjId()

				print("ridderID:", ridderID)
				print("hurtID:", hurtID)

				if ridderID == hurtID then
					controller.bb.set("bbKeyBeHurtTargetObjId", {
						actor = 0
					})

					return controller.fail()
				end
			end
		end

		if hurtID == obj:getObjId() then
			return controller.fail()
		end

		return controller.success()
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
				CollideHorizontallyStop = false,
				speed = 0.8,
				minDistance = 1,
				bbkey_targetpos = "stollPos"
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
local bt_Attack = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				canTeleport = false,
				speed = 1.1,
				minDistance = 1,
				bbkey_followobj = "bbKeyBeHurtTargetObjId",
				canFollowFly = true
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_TurnToTarget",
				subparam = {
					bbTargetKey = "bbKeyBeHurtTargetObjId"
				}
			}
		},
		{
			node = "BTNTaskAttack",
			param = {
				keeptick = 10,
				bbkey_attackobj = "bbKeyBeHurtTargetObjId"
			}
		}
	}
}
local bt_HurtAndAttack = {
	node = "BTNodeBranch",
	children = {
		{
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
					node = "BTNodeTaskLua",
					param = {
						script = "__USE_LOCAL_TABLE_",
						__USE_LOCAL_TABLE_ = ll_BTTask_IsInRange,
						subparam = {
							rangeMax = 10
						}
					}
				}
			}
		},
		bt_Attack,
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeFail",
					children = {
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
local bt_action_RunAndPlayAnim = {
	node = "BTNodeSimpleParallel",
	children = {
		{
			node = "BTNTaskMoveTo",
			param = {
				CollideHorizontallyStop = false,
				speed = 2,
				minDistance = 2,
				bbkey_targetpos = "stollPos"
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
	node = "BTNodeBranch",
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
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeBranch",
					children = {
						{
							node = "BTNodeSequence",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "__USE_LOCAL_TABLE_",
										__USE_LOCAL_TABLE_ = ll_BTTask_IsInRange,
										subparam = {
											rangeMax = 10
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "__USE_LOCAL_TABLE_",
										__USE_LOCAL_TABLE_ = ll_BTTask_attackCondition,
										subparam = {}
									}
								}
							}
						},
						bt_Attack,
						{
							node = "BTNodeSequence",
							children = {
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
								},
								bt_action_run
							}
						}
					}
				}
			}
		},
		{
			node = "BTNodeFail",
			children = {
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
				bbkey_followobj = "xiying_target",
				minDistance = 2
			}
		}
	}
}
local bt_findAndReadyBattle = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTask_FindBattleYak,
				subparam = {
					range = 13,
					ridRate = 0.75,
					normalRate = 0.15
				}
			}
		},
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.5,
				bbkey_followobj = "find_battle_target",
				minDistance = 4
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_IsInBattleRange,
				subparam = {
					range = 400,
					otherID = "find_battle_target"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_PairForBattle,
				subparam = {
					otherID = "find_battle_target"
				}
			}
		}
	}
}
local bt_dingjiao = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_needStartBattleOne,
				subparam = {}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_lookAtOhter,
				subparam = {}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3912.collision"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					animID = 100105,
					duration = 0.4
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_AttackFly,
				subparam = {}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_BattleOnceEnd,
				subparam = {
					rate = 0.15
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 0.5
			}
		}
	}
}
local bt_moveToOtherBattleingYak = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_isReadyBattle,
				subparam = {}
			}
		},
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.5,
				bbkey_followobj = "find_battle_target",
				minDistance = 3.5
			}
		},
		bt_dingjiao
	}
}
local bt_ridden_and_random_run = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "__USE_LOCAL_TABLE_",
				__USE_LOCAL_TABLE_ = ll_BTTask_IsRidden,
				subparam = {}
			}
		},
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
				CollideHorizontallyStop = false,
				speed = 7.5,
				minDistance = 1,
				bbkey_targetpos = "stollPos"
			}
		}
	}
}
local bt_eatFeed = {
	node = "BTNTaskEatFeedBlock",
	param = {
		blockID = 1753,
		max_eat_ticks = 50
	}
}
local bt_mate = {
	node = "BTNTaskMate",
	param = {
		min_babise = 2,
		speed = 1,
		max_babise = 4,
		spwan_delay = 100
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
					isFirstExe = true,
					time = 100,
					timerName = "graze"
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
		{
			node = "BTNodeTaskLua",
			param = {
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
				CollideHorizontallyStop = false,
				speed = 1,
				minDistance = 1,
				bbkey_targetpos = "findBlockPos"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3912.eat"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					animID = 100114,
					duration = 5
				}
			}
		}
	}
}
local bt_main = {
	node = "BTNodePriority",
	children = {
		bt_Attacked,
		bt_moveToOtherBattleingYak,
		{
			node = "BTNodeSelector",
			children = {
				bt_ridden_and_random_run,
				bt_findAndReadyBattle,
				{
					node = "BTNodePriority",
					children = {
						bt_mate,
						bt_eatFeed,
						bt_xiying,
						bt_graze,
						bt_action_random
					}
				}
			}
		}
	}
}

return bt_main

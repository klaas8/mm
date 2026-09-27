local bt_escape = {
	node = "BTNodeCondition",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_checkBeHurt",
				subparam = {
					range = 10,
					bbkey_targetpos = "bbKeyEscapeTargetPos"
				}
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							value = true,
							valueType = AIFunctionDefsGetDefByKey("valueType").loopAction,
							extraValue = {
								ACTOR_ANIM_FLAG_FLEE,
								true
							}
						}
					}
				},
				{
					node = "BTNodeSuccess",
					children = {
						node = "BTNodeTaskLua",
						param = {
							script = "BTTask_moveTo",
							subparam = {
								limit = 20,
								bbkey_targetpos = "bbKeyEscapeTargetPos",
								speed = 1.6,
								distance = 1
							}
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							value = false,
							valueType = AIFunctionDefsGetDefByKey("valueType").loopAction,
							extraValue = {
								ACTOR_ANIM_FLAG_FLEE,
								true
							}
						}
					}
				}
			}
		}
	}
}
local bt_action_idle_stroll = {
	node = "BTNodeSequence"
}
bt_action_idle_stroll.children = {
	{
		node = "BTNodeTaskLua",
		param = {
			script = "__USE_LOCAL_TABLE_",
			__USE_LOCAL_TABLE_ = {
				run = function ()
					local obj = controller.target.get("mob")
					local pos = {
						y = 0,
						z = 0,
						x = 0
					}
					pos.x, pos.y, pos.z = AIFunctionMgr:GetRandStrollPosBySelf(obj, pos.x, pos.y, pos.z, 8, 8)

					controller.bb.set("stollPos", pos)

					return controller.success()
				end
			}
		}
	},
	{
		node = "BTNodeTaskLua",
		param = {
			script = "BTTask_moveTo",
			subparam = {
				limit = 10,
				bbkey_targetpos = "stollPos",
				speed = 0.8,
				distance = 1
			}
		}
	}
}
local bt_action_idle_lookAround = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_LookAt",
		subparam = {
			actorwaittime = 1,
			searchRange = 4,
			waittimemax = 4,
			waittimemin = 1
		}
	}
}
local bt_action_idle_Leisure = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_commonPlayAction",
		subparam = {
			duration = 5,
			soundName = "ent.3200.relax",
			animID = 100162
		}
	}
}
local bt_action_idle_sitWander = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FindPosByNeedType",
								subparam = {
									bbkey_targetpos = "findChairPos",
									bbkey_itemid = "",
									bempty = true,
									equipslot = 0,
									searchType = 4
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_moveTo",
								subparam = {
									limit = 20,
									bbkey_targetpos = "findChairPos",
									speed = 1,
									distance = 1
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_sitDown",
								subparam = {
									bbkey_chairPos = "findChairPos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 5,
									soundName = "fantasy.ogg",
									animID = 100103
								}
							}
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_sitDown"
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 5,
									animID = 100103
								}
							}
						}
					}
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 2
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_standUp"
			}
		}
	}
}
local bt_find_my_bed = {
	node = "BTNodeTaskLua",
	param = {
		script = "__USE_LOCAL_TABLE_",
		__USE_LOCAL_TABLE_ = {
			run = function ()
				local selfActor = controller.target.get()

				if not selfActor then
					return controller.fail()
				end

				local selfTrader = tolua.cast(selfActor, "ActorTravelingTrader")

				if not selfTrader then
					return controller.fail()
				end

				local bedPos = selfTrader:getBedBindPos()

				controller.bb.set(controller.subparam.bb_bedpos, {
					x = bedPos.x,
					y = bedPos.y,
					z = bedPos.z
				})

				return controller.success()
			end
		},
		subparam = {
			bb_bedpos = "bedpos"
		}
	}
}
local bt_goto_my_bed = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_moveTo",
		subparam = {
			enforceWait = 30,
			bbkey_targetpos = "bedpos",
			limit = 70,
			distance = 1,
			speed = 1
		}
	}
}
local bt_check_bedinfo = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_travelingTraderCheckBed",
		subparam = {
			bb_bedpos = "bedpos"
		}
	}
}
local bt_goto_target_pos = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_moveTo",
		subparam = {
			enforceWait = 30,
			bbkey_targetpos = "targetPos",
			limit = 70,
			distance = 1,
			speed = 1
		}
	}
}
local bt_check_gohome_first = {
	node = "BTNodeTaskLua",
	param = {
		script = "__USE_LOCAL_TABLE_",
		__USE_LOCAL_TABLE_ = {
			run = function ()
				local selfActor = controller.target.get()

				if not selfActor then
					return controller.fail()
				end

				local selfTrader = tolua.cast(selfActor, "ActorTravelingTrader")

				if not selfTrader then
					return controller.fail()
				end

				local pos = selfTrader:GetLastInHomePos()

				if pos.y < 0 then
					return controller.success()
				else
					return controller.fail()
				end
			end
		}
	}
}
local bt_enable_sync_pos = {
	node = "BTNodeTaskLua",
	param = {
		script = "__USE_LOCAL_TABLE_",
		__USE_LOCAL_TABLE_ = {
			run = function ()
				local selfActor = controller.target.get()

				if not selfActor then
					return controller.fail()
				end

				local selfTrader = tolua.cast(selfActor, "ActorTravelingTrader")

				if not selfTrader then
					return controller.fail()
				end

				selfTrader:EnableSyncPosition()

				return controller.success()
			end
		}
	}
}

return {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "BBCompareValue",
					extraValue = {
						"bbkey_housingLv",
						0
					}
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeSequence",
					children = {
						bt_check_gohome_first,
						{
							node = "BTNodeTaskLua",
							param = {
								script = "__USE_LOCAL_TABLE_",
								__USE_LOCAL_TABLE_ = {
									run = function ()
										local selfActor = controller.target.get()

										if not selfActor then
											return controller.fail()
										end

										local selfTrader = tolua.cast(selfActor, "ActorTravelingTrader")

										if not selfTrader then
											return controller.fail()
										end

										local homePos = selfTrader:GetHomePos()
										homePos.x, homePos.y, homePos.z = CoordDivBlock(homePos.x, homePos.y, homePos.z)

										controller.bb.set(controller.subparam.bb_pos, {
											x = homePos.x,
											y = homePos.y,
											z = homePos.z
										})

										return controller.success()
									end
								},
								subparam = {
									bb_pos = "targetPos"
								}
							}
						},
						bt_goto_target_pos,
						bt_enable_sync_pos
					}
				},
				bt_escape,
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_travelingTraderLeave",
						subparam = {
							bbkey_inhome = "bbkey_inHome",
							maxWait = 30,
							leaveDistance = 40
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FindPosByNeedType",
								subparam = {
									searchType = 3,
									bbkey_targetpos = "bedpos",
									bempty = true
								}
							}
						},
						bt_goto_my_bed,
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_sleepOnAndBindBedEx",
								subparam = {
									bb_bedpos = "bedpos"
								}
							}
						},
						{
							node = "BTNodeWait",
							param = {
								wait = 2
							}
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonJudge",
						subparam = {
							compareValue = 1,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").isSleeping,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal
						}
					}
				},
				{
					node = "BTNodeRandom",
					param = {
						defWeight = 100,
						weight = {
							50,
							20,
							10,
							20
						}
					},
					children = {
						bt_action_idle_stroll,
						bt_action_idle_lookAround,
						bt_action_idle_Leisure,
						bt_action_idle_sitWander
					}
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeSequence",
					children = {
						bt_check_gohome_first,
						bt_find_my_bed,
						bt_goto_my_bed,
						{
							node = "BTNodeSuccess",
							children = {
								bt_check_bedinfo
							}
						},
						bt_enable_sync_pos
					}
				},
				bt_escape,
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "__USE_LOCAL_TABLE_",
								__USE_LOCAL_TABLE_ = {
									run = function ()
										local selfActor = controller.target.get()

										if not selfActor then
											return controller.fail()
										end

										if AIFunctionMgr:isInTempest(selfActor) or WorldMgr and WorldMgr.isVoidNight and WorldMgr:isVoidNight() then
											return controller.success()
										else
											return controller.fail()
										end
									end
								}
							}
						},
						{
							node = "BTNodeSuccess",
							children = {
								node = "BTNodeTaskLua",
								param = {
									script = "BTTask_wakeup"
								}
							}
						},
						bt_find_my_bed,
						bt_goto_my_bed,
						bt_check_bedinfo
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonCompare",
								subparam = {
									type = "BBCompareValue",
									extraValue = {
										"bbkey_inHome",
										false
									}
								}
							}
						},
						{
							node = "BTNodeSuccess",
							children = {
								node = "BTNodeTaskLua",
								param = {
									script = "BTTask_wakeup"
								}
							}
						},
						bt_find_my_bed,
						bt_goto_my_bed,
						bt_check_bedinfo,
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 5,
									isLoopAnim = true,
									animID = 140003
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_travelingTraderLeave",
								subparam = {
									bbkey_inhome = "bbkey_inHome",
									maxWait = 30,
									leaveDistance = 40
								}
							}
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "__USE_LOCAL_TABLE_",
								__USE_LOCAL_TABLE_ = {
									run = function ()
										local selfActor = controller.target.get()

										if not selfActor or not WorldMgr then
											return controller.fail()
										end

										local hour = WorldMgr:getHours()

										if hour >= 19 or hour < 8 then
											return controller.success()
										else
											return controller.fail()
										end
									end
								}
							}
						},
						{
							node = "BTNodeSelector",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonJudge",
										subparam = {
											compareValue = 1,
											judgeType = AIFunctionDefsGetDefByKey("judgeType").isSleeping,
											compareType = AIFunctionDefsGetDefByKey("compareType").equal
										}
									}
								},
								{
									node = "BTNodeSequence",
									children = {
										bt_find_my_bed,
										bt_goto_my_bed,
										bt_check_bedinfo,
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_sleepOnBed",
												subparam = {
													bb_bedpos = "bedpos"
												}
											}
										}
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
							script = "BTTask_wakeup"
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_travelingTraderHunger",
						subparam = {
							cd = 5,
							prob = 20
						}
					}
				},
				{
					node = "BTNodeRandom",
					param = {
						defWeight = 100,
						weight = {
							50,
							20,
							10,
							20
						}
					},
					children = {
						bt_action_idle_stroll,
						bt_action_idle_lookAround,
						bt_action_idle_Leisure,
						bt_action_idle_sitWander
					}
				}
			}
		}
	}
}

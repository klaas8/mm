local bt_fire_battle_attack_behurt = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				bbkey_followobj = "bbKeyBeHurtTargetObjId",
				avoidWater = false,
				canTeleport = false,
				minDistance = 1.5,
				speed = 1.1
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
				keeptick = 30,
				bbkey_attackobj = "bbKeyBeHurtTargetObjId"
			}
		}
	}
}
local bt_fire_battle_attack_enemy = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "actorIsInvalid",
					extraValue = "enemy_id"
				}
			}
		},
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonCompare",
						subparam = {
							type = "actorInView",
							extraValue = "enemy_id"
						}
					}
				},
				{
					node = "BTNodeSuccess",
					children = {
						{
							node = "BTNodeSequence",
							children = {
								{
									node = "BTNTaskFollow",
									param = {
										canTeleport = false,
										bbkey_followobj = "enemy_id",
										minDistance = 2.5,
										speed = 1.3
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_TurnToTarget",
										subparam = {
											bbTargetKey = "enemy_id"
										}
									}
								},
								{
									node = "BTNTaskAttack",
									param = {
										keeptick = 30,
										bbkey_attackobj = "enemy_id"
									}
								}
							}
						}
					}
				},
				{
					node = "BTNodeSuccess",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "enemy_id",
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
local bt_active_fire = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "actorIsInvalid",
					extraValue = "bbKeyBeHurtTargetObjId"
				}
			}
		},
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonCompare",
						subparam = {
							type = "actorInView",
							extraValue = "bbKeyBeHurtTargetObjId"
						}
					}
				},
				bt_fire_battle_attack_behurt,
				{
					node = "BTNodeSuccess",
					children = {
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
							}
						}
					}
				}
			}
		}
	}
}
local bt_fire = {
	node = "BTNodeSelector",
	children = {
		bt_active_fire,
		bt_fire_battle_attack_enemy
	}
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
				script = "BTTask_getRandStollPos",
				subparam = {
					rangeWidth = 10,
					bb_stollpos = "stollPos",
					centerPos = "bb_workPos",
					rangeHeight = 2
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isUsablePosCheckBlock",
					bb_pos = "stollPos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				CollideHorizontallyStop = false,
				speed = 0.8,
				avoidWater = false,
				minDistance = 0,
				bbkey_targetpos = "stollPos"
			}
		}
	}
}
local bt_alert = {
	node = "BTNodeSelector",
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							key = "alertTime",
							value = 0,
							valueType = AIFunctionDefsGetDefByKey("valueType").value
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "findHavePlayerSurround"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "alertTime",
									value = 3,
									valueType = AIFunctionDefsGetDefByKey("valueType").value
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 1,
									animID = 100882
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "mobResetAI"
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt_action_idle_lookAround = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_LookAt",
		subparam = {
			waittimemin = 1,
			actorwaittime = 2,
			searchRange = 4,
			needSearchPlayer = false,
			waittimemax = 4
		}
	}
}
local bt_search = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 0,
					curValue = "alertTime",
					judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
					compareType = AIFunctionDefsGetDefByKey("compareType").more
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					minus = 1,
					minuend = "alertTime",
					fun = "numberMinus"
				}
			}
		},
		{
			node = "BTNodeSimpleParallel",
			param = {
				loop = true
			},
			children = {
				bt_action_idle_lookAround,
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "findPlayerByMobViewRay",
									player = "bbKeyBeHurtTargetObjId"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "mobResetAI"
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt_lazy = {
	node = "BTNodeSimpleParallel",
	param = {
		loop = true
	},
	children = {
		{
			node = "BTNodeSuccess",
			children = {
				node = "BTNodeSequence",
				children = {
					{
						node = "BTNodeTaskLua",
						param = {
							script = "BTTask_simpleFun",
							subparam = {
								fun = "patrolMobSleep"
							}
						}
					},
					{
						node = "BTNodeTaskLua",
						param = {
							script = "BTTask_commonPlayAction",
							subparam = {
								duration = 20,
								animID = 100103
							}
						}
					},
					{
						node = "BTNodeTaskLua",
						param = {
							script = "BTTask_wakeup"
						}
					}
				}
			}
		},
		bt_alert
	}
}
local bt_partol = {
	node = "BTNodeSequence",
	param = {
		tip = "bt_action_idle_stroll"
	},
	children = {
		{
			node = "BTNodeSimpleParallel",
			param = {
				loop = true
			},
			children = {
				bt_action_idle_stroll,
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "findPlayerByMobViewRay",
									player = "bbKeyBeHurtTargetObjId"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									fun = "mobResetAI"
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt_slack = {
	node = "BTNodeRandom",
	param = {
		weight = {
			85,
			15
		}
	},
	children = {
		bt_partol,
		bt_lazy
	}
}
local bt_judgeWorkPos = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isPosOutRange",
					extraValue = {
						comparePos = "bb_workPos",
						range = 16
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_taskExplore",
				subparam = {
					stagePos = "bb_curToPos",
					explorePos = "bb_workPos"
				}
			}
		},
		{
			node = "BTNodeSuccess",
			children = {
				{
					node = "BTNTaskMoveTo",
					param = {
						avoidWater = false,
						speed = 1,
						minDistance = 0,
						bbkey_targetpos = "bb_curToPos"
					}
				}
			}
		}
	}
}
local bt_walkAround = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isUsableCenterPos",
					reversal = true,
					centerPos = "bb_workPos"
				}
			}
		},
		{
			node = "BTNodeSequence",
			param = {
				tip = "bt_action_walkAround"
			},
			children = {
				{
					node = "BTNodeSimpleParallel",
					param = {
						loop = true
					},
					children = {
						{
							node = "BTNodeSequence",
							param = {
								tip = "bt_action_idle_stroll"
							},
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											bb_stollpos = "stollPos",
											range = 8,
											fun = "findRangePosInWater"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										CollideHorizontallyStop = false,
										speed = 1.5,
										avoidWater = false,
										minDistance = 1,
										bbkey_targetpos = "stollPos"
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
										script = "BTTask_commonFindTargetPos",
										subparam = {
											bbKeyTargetObjId = "bbKeyBeHurtTargetObjId",
											range = 5,
											targetType = 3
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											fun = "mobResetAI"
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
}
local bt_main = {
	node = "BTNodeSelector",
	children = {
		bt_fire,
		bt_walkAround,
		bt_judgeWorkPos,
		bt_search,
		bt_slack
	}
}

return bt_main

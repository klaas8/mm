local bt_action_hello = {
	node = "BTNodeTaskLua",
	param = {
		script = "BTTask_LoockAtPlayer",
		subparam = {
			waittimemax = 4,
			waittimemin = 1,
			actorwaittime = 4,
			searchRange = 4
		}
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
				script = "BTTask_getSleepState"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_getDesertVillagePos",
				subparam = {
					bb_desertvillagepos = "desertvillagepos"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_getRandStollPos",
				subparam = {
					centerPos = "desertvillagepos",
					rangeHeight = 2,
					rangeWidth = 10,
					bb_stollpos = "stollPos"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_desertJudget",
				subparam = {
					judgettype = 1,
					bb_stollpos = "stollPos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 0.8,
				minDistance = 0,
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false
			}
		},
		bt_action_hello
	}
}
local bt_action_sleep2 = {
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
								script = "BTTask_getBedPos",
								subparam = {
									bb_bedpos = "bedpos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "bedpos",
									compareValue = 1,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isBindWithBedPoint,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
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
								script = "BTTask_FindPosByNeedType",
								subparam = {
									searchType = 3,
									bbkey_targetpos = "bedpos",
									bempty = true,
									equipslot = 0
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_desertJudget",
								subparam = {
									judgettype = 2,
									bbkey_targetpos = "bedpos"
								}
							}
						}
					}
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 0,
				bbkey_targetpos = "bedpos",
				avoidWater = true
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "bedpos",
									compareValue = 1,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isBindWithBedPoint,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "bedpos",
									compareValue = 0,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isBlockOccupyed,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonJudge",
						subparam = {
							extraValue = "bedpos",
							compareValue = 0,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").isBedBindWithOthers,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal
						}
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_sleepOnAndBindBed",
				subparam = {
					bb_bedpos = "bedpos"
				}
			}
		}
	}
}
local bt_action_sleep = {
	node = "BTNodeCondition",
	param = {
		tip = "bt_action_sleep"
	},
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_notDayTime",
				subparam = {
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					enemy_id = "enemy_id"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_action_sleep2,
				bt_action_idle_stroll,
				{
					node = "BTNodeWait",
					param = {
						wait = 1
					}
				}
			}
		}
	}
}
local bt_action_wakeup = {
	node = "BTNodeCondition",
	param = {
		tip = "bt_action_wakeup"
	},
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
								script = "BTTask_getBedPos",
								subparam = {
									bb_bedpos = "bedpos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "bedpos",
									compareValue = 0,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isBindWithBedPoint,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_isDayTime"
					}
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
local bt_fire_battle_attack_behurt = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.3,
				minDistance = 1,
				bbkey_followobj = "bbKeyBeHurtTargetObjId"
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
				bbkey_attackobj = "bbKeyBeHurtTargetObjId",
				keeptick = 10
			}
		}
	}
}
local bt_fire_battle_attack_target = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.3,
				minDistance = 1,
				bbkey_followobj = "bbKeyAttackTargetObjId"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_TurnToTarget",
				subparam = {
					bbTargetKey = "bbKeyAttackTargetObjId"
				}
			}
		},
		{
			node = "BTNTaskAttack",
			param = {
				bbkey_attackobj = "bbKeyAttackTargetObjId",
				keeptick = 10
			}
		}
	}
}
local bt_fire_battle_attack_enemy = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.3,
				minDistance = 1,
				bbkey_followobj = "enemy_id"
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
				bbkey_attackobj = "enemy_id",
				keeptick = 10
			}
		}
	}
}
local bt_fire = {
	node = "BTNodeSelector",
	param = {
		tip = "bt_fire1"
	},
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
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "bbKeyBeHurtTargetObjId",
									compareValue = 1,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isActorExist,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonCompare",
								subparam = {
									range = 8,
									extraValue = "bbKeyBeHurtTargetObjId",
									type = "actorInView"
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
								script = "BTTask_wakeup"
							}
						},
						bt_fire_battle_attack_behurt
					}
				},
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
		},
		{
			node = "BTNodeBranch",
			param = {
				tip = "bt_fire2"
			},
			children = {
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									extraValue = "enemy_id",
									compareValue = 1,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").isActorExist,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonCompare",
								subparam = {
									range = 8,
									extraValue = "enemy_id",
									type = "actorInView"
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
								script = "BTTask_wakeup"
							}
						},
						bt_fire_battle_attack_enemy
					}
				},
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
		},
		{
			node = "BTNodeSequence",
			param = {
				tip = "bt_fire3"
			},
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_checkAttack",
						subparam = {
							bbKeyTargetPos = "bbKeyAttackTargetPos",
							range = 16,
							bbKeyTargetObjId = "bbKeyAttackTargetObjId"
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_wakeup"
							}
						},
						bt_fire_battle_attack_target
					}
				}
			}
		}
	}
}
local bt_work_Tamed_Pick_Work_Drop = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "搜寻范围内列表里的掉落物的位置",
				script = "BTTask_FindDropByList",
				subparam = {
					bbTargetIdKey = "find_drop_targetid",
					bbPosKey = "find_drop_pos",
					listsKey = "famerToolsList"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 1,
				bbkey_targetpos = "find_drop_pos",
				CollideHorizontallyStop = false
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "捡起掉落物到背包",
				script = "BTTask_Pick",
				subparam = {
					out_Itemnum = "bb_gotItemNum",
					dropItemId = "find_drop_targetid",
					out_Itemid = "bb_gotItemid"
				}
			}
		}
	}
}
local find_crop = {
	node = "BTNodeCondition",
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FindBlock",
						subparam = {
							rangeY = 10,
							result_blockpos = "bbHackTreeTargetPos",
							range = 11,
							findPositionType = 2,
							findBlockType = AI_FIND_CROP
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_isDayTime"
					}
				}
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNTaskMoveTo",
					param = {
						speed = 1,
						minDistance = 1,
						bbkey_targetpos = "bbHackTreeTargetPos",
						avoidWater = true
					}
				},
				{
					node = "BTNTaskDigBlock",
					param = {
						speed = 0.6,
						dist = 6400,
						block_pos_key = "bbHackTreeTargetPos",
						dig_dist = 200
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
	}
}
local bt_save = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_isDayTime"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_HaveBagContainer"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindBlock",
				subparam = {
					rangeY = 10,
					result_blockpos = "finditem_out_boxpos",
					range = 11,
					findPositionType = 2,
					findBlockType = AI_FIND_BOX_NOT_FULL
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 1,
				bbkey_targetpos = "finditem_out_boxpos",
				avoidWater = true
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_storeItemByList",
				subparam = {
					in_TargetPos = "finditem_out_boxpos",
					storeMode = 2
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 1,
					animID = 100105
				}
			}
		}
	}
}
local bt_Plant_Seed = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_isDayTime"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindBlock",
				subparam = {
					rangeY = 10,
					result_blockpos = "find_CultivatedLand_pos",
					range = 11,
					findPositionType = 2,
					findBlockType = AI_FIND_CUSTOM,
					findCustomBlocks = {
						102
					}
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 1,
				bbkey_targetpos = "find_CultivatedLand_pos",
				avoidWater = true
			}
		},
		{
			node = "BTNTaskPlant",
			param = {
				speed = 1,
				isauto_change_land = 1,
				plant_type = 2,
				dist = 1600,
				block_pos_key = "find_CultivatedLand_pos"
			}
		}
	}
}
local bt_gossip = {
	node = "BTNodeSelector",
	tip = "gossip",
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
								tip = "get_gossipstate",
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 2,
									state = 2
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								tip = "get_gossipstate",
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 6
								}
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
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "isgoosiTime",
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossiptype = 1,
											state = 1
										}
									}
								},
								{
									node = "BTNodeSequence",
									children = {
										{
											node = "BTNodeTaskLua",
											param = {
												tip = "clearGossipState",
												script = "BTTask_DesertVillgerGossip",
												subparam = {
													gossiptype = 2,
													state = 0
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												tip = "setintervalTime",
												script = "BTTask_DesertVillgerGossip",
												subparam = {
													gossiptype = 0,
													state = 0
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_DesertVillgerGossip",
												subparam = {
													gossiptype = 7
												}
											}
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
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossiptype = 9
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "lookat_villger",
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossiptype = 3,
											state = 1
										}
									}
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
								tip = "get_interval_time",
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 0,
									state = 1
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 7
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 8
								}
							}
						},
						{
							node = "BTNodeSequence",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "around_gossipState",
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossipId = "gossipId",
											state = 1,
											gossiptype = 4,
											gossipPos = "gossipPos"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "set_gossipTime",
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossiptype = 1,
											state = 0
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "setGossipState",
										script = "BTTask_DesertVillgerGossip",
										subparam = {
											gossiptype = 2,
											state = 1
										}
									}
								},
								{
									node = "BTNodeSequence",
									children = {
										{
											desc = "moveto",
											node = "BTNTaskMoveTo",
											param = {
												speed = 1.3,
												minDistance = 2,
												bbkey_targetpos = "gossipPos",
												avoidWater = true
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												tip = "lookat_villger",
												script = "BTTask_DesertVillgerGossip",
												subparam = {
													gossiptype = 5,
													gossipId = "gossipId"
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
	}
}
local bt_inwater = {
	node = "BTNodeCondition",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 1,
					judgeType = AIFunctionDefsGetDefByKey("judgeType").isInWater,
					compareType = AIFunctionDefsGetDefByKey("compareType").equal
				}
			}
		},
		{
			node = "BTNodeSequence",
			param = {
				tip = "stroll_in_water"
			},
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						tip = "get_gossipstate",
						script = "BTTask_DesertVillgerGossip",
						subparam = {
							gossiptype = 2,
							state = 0
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_getRandStollPos",
						subparam = {
							bb_stollpos = "stollPos"
						}
					}
				},
				{
					node = "BTNTaskMoveTo",
					param = {
						bbkey_targetpos = "stollPos",
						speed = 1
					}
				}
			}
		}
	}
}
local bt_inspect = {
	node = "BTNodeSelector",
	children = {
		{
			node = "BTNodeInversion",
			children = {
				node = "BTNodeTaskLua",
				param = {
					script = "BTTask_getDesertVillagePos",
					subparam = {
						bb_desertvillagepos = "desertvillagepos"
					}
				}
			}
		},
		{
			node = "BTNodeCondition",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonJudge",
						subparam = {
							compareValue = 0,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").isInRange,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal,
							extraValue = AIFunctionDefsGetDefByKey("rangeType").village
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_wakeup"
							}
						},
						{
							node = "BTNTaskMoveTo",
							param = {
								speed = 1,
								minDistance = 3,
								bbkey_targetpos = "desertvillagepos",
								avoidWater = true
							}
						}
					}
				}
			}
		}
	}
}
local bt_setgossipaction = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeInversion",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_isDayTime"
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_DesertVillgerGossip",
				subparam = {
					gossiptype = 2,
					state = 0
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_DesertVillgerGossip",
				subparam = {
					gossiptype = 7
				}
			}
		}
	}
}
local bt_interact_look_node = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 0,
					curValue = "greeted_act_id",
					judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
					compareType = AIFunctionDefsGetDefByKey("compareType").more
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_TurnToTarget",
				subparam = {
					bbTargetKey = "greeted_obj_id"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					animID = "greeted_act_id"
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 1.2
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonSetValue",
				subparam = {
					value = 0,
					key = "greeted_act_id",
					valueType = AIFunctionDefsGetDefByKey("valueType").value
				}
			}
		}
	}
}
local hello_follow_player = {
	node = "BTNodeSimpleParallel",
	param = {
		loop = false
	},
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNTaskFollow",
					param = {
						speed = 1.3,
						minDistance = 3,
						bbkey_followobj = "followobjid"
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_TurnToTarget",
						subparam = {
							bbTargetKey = "followobjid"
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
						script = "BTTask_DesertVillgerGossip",
						subparam = {
							ticks = 40,
							gossiptype = 12,
							followtick = "followtick"
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_DesertVillgerGossip",
						subparam = {
							followobjid = "followobjid",
							followstate = "followstate",
							gossiptype = 11
						}
					}
				}
			}
		}
	}
}
local bt_followplayer = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_DesertVillgerGossip",
						subparam = {
							followobjid = "followobjid",
							bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
							enemy_id = "enemy_id",
							bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
							followstate = "followstate",
							gossiptype = 10
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonCompare",
						subparam = {
							range = 16,
							extraValue = "followobjid",
							type = "actorInView"
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
						script = "BTTask_wakeup"
					}
				},
				hello_follow_player
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
							key = "followobjid",
							valueType = AIFunctionDefsGetDefByKey("valueType").value,
							value = {
								actor = 0
							}
						}
					}
				},
				{
					node = "BTNodeFail",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_DesertVillgerGossip",
								subparam = {
									gossiptype = 7
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt = {
	node = "BTNodeSelector",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					reversal = true,
					type = "isOnGround"
				}
			}
		},
		{
			node = "BTNodeFail",
			children = {
				bt_inspect
			}
		},
		{
			node = "BTNodeFail",
			children = {
				bt_action_wakeup
			}
		},
		{
			node = "BTNodeFail",
			children = {
				bt_setgossipaction
			}
		},
		{
			node = "BTNodeFail",
			children = {
				bt_inwater
			}
		},
		{
			node = "BTNodeFail",
			children = {
				bt_interact_look_node
			}
		},
		bt_followplayer,
		bt_fire,
		bt_action_sleep,
		find_crop,
		bt_work_Tamed_Pick_Work_Drop,
		bt_Plant_Seed,
		bt_save,
		bt_action_idle_stroll,
		bt_gossip
	}
}

return bt

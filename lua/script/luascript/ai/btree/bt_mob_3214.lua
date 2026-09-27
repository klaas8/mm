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
				script = "BTTask_FishingVillagePos",
				subparam = {
					bb_fishingvillagepos = "fishingvillagepos"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_getRandStollPos",
				subparam = {
					rangeWidth = 10,
					bb_stollpos = "stollPos",
					centerPos = "fishingvillagepos",
					rangeHeight = 2
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
				canTeleport = false,
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
local bt_fire_battle_attack_enemy = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNTaskFollow",
			param = {
				speed = 1.3,
				minDistance = 1,
				canTeleport = false,
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
									extraValue = "bbKeyBeHurtTargetObjId",
									range = 16,
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
									extraValue = "enemy_id",
									range = 16,
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
		}
	}
}
local bt_action_sleep2 = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 0,
					judgeType = AIFunctionDefsGetDefByKey("judgeType").isSleeping,
					compareType = AIFunctionDefsGetDefByKey("compareType").equal
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillagePos",
				subparam = {
					bb_fishingvillagepos = "fishingvillagepos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 0,
				bbkey_targetpos = "fishingvillagepos",
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
				script = "BTTask_sleepOnAndBindBedEx",
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
				script = "BTTask_FishingVillageSleepTime",
				subparam = {
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
					enemy_id = "enemy_id"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_action_sleep2,
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
								script = "BTTask_FishingVillageGossip",
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
								script = "BTTask_FishingVillageGossip",
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
										script = "BTTask_FishingVillageGossip",
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
												script = "BTTask_FishingVillageGossip",
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
												script = "BTTask_FishingVillageGossip",
												subparam = {
													gossiptype = 0,
													state = 0
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_FishingVillageGossip",
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
										script = "BTTask_FishingVillageGossip",
										subparam = {
											gossiptype = 9
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "lookat_villger",
										script = "BTTask_FishingVillageGossip",
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
								script = "BTTask_FishingVillageGossip",
								subparam = {
									gossiptype = 0,
									state = 1
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FishingVillageGossip",
								subparam = {
									gossiptype = 7
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FishingVillageGossip",
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
										script = "BTTask_FishingVillageGossip",
										subparam = {
											gossiptype = 4,
											gossipId = "gossipId",
											gossipPos = "gossipPos",
											state = 1
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										tip = "set_gossipTime",
										script = "BTTask_FishingVillageGossip",
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
										script = "BTTask_FishingVillageGossip",
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
												speed = 1,
												minDistance = 2,
												bbkey_targetpos = "gossipPos",
												avoidWater = true
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												tip = "lookat_villger",
												script = "BTTask_FishingVillageGossip",
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
local bt_setgossipaction = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillageSleepTime",
				subparam = {
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
					enemy_id = "enemy_id"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillageGossip",
				subparam = {
					gossiptype = 2,
					state = 0
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillageGossip",
				subparam = {
					gossiptype = 7
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
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FishingVillageWorkTime",
						subparam = {
							bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
							bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
							enemy_id = "enemy_id"
						}
					}
				},
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
local bt_save = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillagePos",
				subparam = {
					bb_fishingvillagepos = "fishingvillagepos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				minDistance = 0,
				bbkey_targetpos = "fishingvillagepos",
				avoidWater = true
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindBlock",
				subparam = {
					range = 16,
					result_blockpos = "finditem_out_boxpos",
					rangeY = 5,
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
					storeMode = 1
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					duration = 1,
					animID = 100829
				}
			}
		}
	}
}
local bt_need_save = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_HaveBagContainerEx",
				subparam = {
					objId = 3214,
					itemCount = 10,
					itemId = 12520
				}
			}
		},
		bt_save
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
					script = "BTTask_FishingVillagePos",
					subparam = {
						bb_fishingvillagepos = "fishingvillagepos"
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
								bbkey_targetpos = "fishingvillagepos",
								avoidWater = true
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
						script = "BTTask_FishingVillageGossip",
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
local bt_meet_rainbow = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_findRainbow"
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonJudge",
						subparam = {
							curValue = "isRainbow",
							compareValue = 0,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal
						}
					}
				},
				{
					node = "BTNodeSequence",
					children = {
						{
							node = "BTNodeSelector",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_FishingVillageWorkTime",
										subparam = {
											bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
											bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
											enemy_id = "enemy_id"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_FishingVillageOtherTime",
										subparam = {
											bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
											bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
											enemy_id = "enemy_id"
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
									extraValue = 10,
									compareValue = 5,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").randomValue,
									compareType = AIFunctionDefsGetDefByKey("compareType").lessEqual
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									soundName = "ent.3214.surprise",
									duration = 1,
									animID = 100865
								}
							}
						},
						{
							node = "BTNodeWait",
							param = {
								wait = 3
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									value = 1,
									key = "isRainbow",
									valueType = AIFunctionDefsGetDefByKey("valueType").value
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
					script = "BTTask_commonSetValue",
					subparam = {
						value = 0,
						key = "isRainbow",
						valueType = AIFunctionDefsGetDefByKey("valueType").value
					}
				}
			}
		}
	}
}
local bt_avoid_tempest = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_isInTempestWeather"
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeSelector",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FishingVillageWorkTime",
								subparam = {
									bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
									bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
									enemy_id = "enemy_id"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FishingVillageOtherTime",
								subparam = {
									bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
									bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
									enemy_id = "enemy_id"
								}
							}
						}
					}
				},
				{
					node = "BTNodeBranch",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									curValue = "is_avoid_tempest",
									compareValue = 1,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						},
						{
							node = "BTNodeSequence",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonJudge",
										subparam = {
											extraValue = 10,
											compareValue = 5,
											judgeType = AIFunctionDefsGetDefByKey("judgeType").randomValue,
											compareType = AIFunctionDefsGetDefByKey("compareType").lessEqual
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_getRandStollPos",
										subparam = {
											rangeWidth = 2,
											bb_stollpos = "stollPos",
											rangeHeight = 1
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										speed = 0.5,
										minDistance = 0,
										bbkey_targetpos = "stollPos",
										CollideHorizontallyStop = false
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_FishingVillagePos",
										subparam = {
											bb_fishingvillagepos = "fishingvillagepos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										speed = 1,
										minDistance = 0,
										bbkey_targetpos = "fishingvillagepos",
										avoidWater = true
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
										script = "BTTask_FishingVillagePos",
										subparam = {
											bb_fishingvillagepos = "fishingvillagepos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										speed = 1.2,
										minDistance = 0,
										bbkey_targetpos = "fishingvillagepos",
										avoidWater = true
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonSetValue",
										subparam = {
											value = 1,
											key = "is_avoid_tempest",
											valueType = AIFunctionDefsGetDefByKey("valueType").value
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
					script = "BTTask_commonSetValue",
					subparam = {
						value = 0,
						key = "is_avoid_tempest",
						valueType = AIFunctionDefsGetDefByKey("valueType").value
					}
				}
			}
		}
	}
}
local bt_hunger_status = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 30,
					judgeType = AIFunctionDefsGetDefByKey("judgeType").fullUp,
					compareType = AIFunctionDefsGetDefByKey("compareType").less
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_getRandStollPos",
				subparam = {
					rangeWidth = 6,
					bb_stollpos = "stollPos",
					centerPos = "villagepos",
					rangeHeight = 2
				}
			}
		},
		{
			node = "BTNodeSimpleParallel",
			children = {
				{
					node = "BTNodeSimpleParallel",
					children = {
						{
							node = "BTNTaskMoveTo",
							param = {
								speed = 0.3,
								minDistance = 1,
								bbkey_targetpos = "stollPos",
								CollideHorizontallyStop = false
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									effectID = "mob_3200_hungery",
									duration = 1,
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
								script = "BTTask_getFollowTick",
								subparam = {
									followtick = "followtick"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 1,
									soundName = "npc.hungry"
								}
							}
						}
					}
				}
			}
		}
	}
}
local bt_need_Tamed_Eat_BagHaveFood = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "判断：背包内有食物",
				script = "BTTask_commonJudge",
				subparam = {
					judgeType = 12,
					compareType = 3,
					compareValue = 0,
					extraValue = {
						1,
						true
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "把食物放在手上",
				script = "BTTask_putFoodInHand",
				subparam = {
					bbFoodId = ""
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 1
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonSetValue",
				subparam = {
					value = true,
					valueType = AIFunctionDefsGetDefByKey("valueType").loopAction,
					extraValue = {
						ACTOR_ANIM_FLAG_EAT,
						true
					}
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 5
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "吃手上的食物",
				script = "BTTask_EatHandFood"
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
						ACTOR_ANIM_FLAG_EAT,
						true
					}
				}
			}
		}
	}
}
local bt_need_Tamed_Eat_BagHaveNotFood = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "判断：背包中没有食物",
				script = "BTTask_commonJudge",
				subparam = {
					judgeType = 12,
					compareType = 2,
					compareValue = 0,
					extraValue = {
						1,
						true
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillagePos",
				subparam = {
					bb_fishingvillagepos = "fishingvillagepos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1.2,
				minDistance = 0,
				bbkey_targetpos = "fishingvillagepos",
				avoidWater = true
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						desc = "获取需求箱子位置 ",
						script = "BTTask_FindPosByNeedType",
						subparam = {
							searchType = 2,
							findboxid = 801,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						desc = "获取需求箱子位置 ",
						script = "BTTask_FindPosByNeedType",
						subparam = {
							searchType = 2,
							findboxid = 1180,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						desc = "获取需求箱子位置 ",
						script = "BTTask_FindPosByNeedType",
						subparam = {
							searchType = 2,
							findboxid = 1181,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0
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
				bbkey_targetpos = "BTTask_FindStoragePos",
				CollideHorizontallyStop = false
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				desc = "从箱子中取出一定数量的道具",
				script = "BTTask_TakeItemToPack",
				subparam = {
					bbkey_in_boxpos = "BTTask_FindStoragePos",
					bbkey_one_takenum = 5,
					bbkey_one_takeid = "finditem"
				}
			}
		}
	}
}
local bt_need_eat = {
	node = "BTNodeSelector",
	param = {
		tip = "need eat"
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
							curValue = "isEating",
							compareValue = 1,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal
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
										script = "BTTask_commonJudge",
										subparam = {
											compareValue = 80,
											judgeType = AIFunctionDefsGetDefByKey("judgeType").fullUp,
											compareType = AIFunctionDefsGetDefByKey("compareType").moreEqual
										}
									}
								},
								{
									node = "BTNodeSuccess",
									children = {
										node = "BTNodeTaskLua",
										param = {
											script = "BTTask_commonSetValue",
											subparam = {
												value = 0,
												key = "isEating",
												valueType = AIFunctionDefsGetDefByKey("valueType").value
											}
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_PutHandItemInBags",
										subparam = {}
									}
								}
							}
						},
						bt_need_Tamed_Eat_BagHaveFood,
						{
							node = "BTNodeSequence",
							children = {
								{
									node = "BTNodeSelector",
									children = {
										bt_need_Tamed_Eat_BagHaveNotFood,
										bt_work
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
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonJudge",
						subparam = {
							compareValue = 30,
							judgeType = AIFunctionDefsGetDefByKey("judgeType").fullUp,
							compareType = AIFunctionDefsGetDefByKey("compareType").lessEqual
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							value = 1,
							key = "isEating",
							valueType = AIFunctionDefsGetDefByKey("valueType").value
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
						value = 0,
						key = "isEating",
						valueType = AIFunctionDefsGetDefByKey("valueType").value
					}
				}
			}
		}
	}
}
local bt_fishing = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeSelector",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FindBlock",
								subparam = {
									range = 6,
									result_blockpos = "find_fishing_pos",
									rangeY = 6,
									findPositionType = 5,
									findBlockType = AI_FIND_CUSTOM,
									findCustomBlocks = {
										3,
										4
									}
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FindBlock",
								subparam = {
									range = 20,
									result_blockpos = "find_fishing_pos",
									rangeY = 6,
									findPositionType = 2,
									findBlockType = AI_FIND_CUSTOM,
									findCustomBlocks = {
										3,
										4
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
							node = "BTNTaskMoveTo",
							param = {
								speed = 1,
								minDistance = 2,
								bbkey_targetpos = "find_fishing_pos",
								avoidWater = true
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 1,
									animID = 100921
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 0.5,
									animID = 100877
								}
							}
						},
						{
							node = "BTNodeSimpleParallel",
							param = {
								loop = true
							},
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonPlayAction",
										subparam = {
											duration = 25,
											animID = 100878
										}
									}
								},
								{
									node = "BTNodeCondition",
									children = {
										{
											node = "BTNodeSelector",
											children = {
												{
													node = "BTNodeTaskLua",
													param = {
														script = "BTTask_FishingVillageSleepTime",
														subparam = {
															bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
															bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
															enemy_id = "enemy_id"
														}
													}
												},
												{
													node = "BTNodeTaskLua",
													param = {
														script = "BTTask_isInTempestWeather"
													}
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_FishingVillageStopWorking"
											}
										}
									}
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 0.5,
									animID = 100879
								}
							}
						},
						{
							node = "BTNodeBranch",
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonJudge",
										subparam = {
											extraValue = 10,
											compareValue = 4,
											judgeType = AIFunctionDefsGetDefByKey("judgeType").randomValue,
											compareType = AIFunctionDefsGetDefByKey("compareType").lessEqual
										}
									}
								},
								{
									node = "BTNodeSequence",
									children = {
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_FishingSuccess",
												subparam = {
													probability = 10,
													bb_fishId = "fishId"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_commonPlayAction",
												subparam = {
													exchangeItemId = 12520,
													bb_fishId = "fishId",
													duration = 2,
													animID = 100829
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_PutHandItemInBags",
												subparam = {}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_commonPlayAction",
												subparam = {
													soundName = "ent.3214.happy",
													duration = 2,
													animID = 100880
												}
											}
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonPlayAction",
										subparam = {
											soundName = "ent.3214.lose",
											duration = 2,
											animID = 100881
										}
									}
								}
							}
						}
					}
				},
				bt_action_idle_stroll
			}
		}
	}
}
local bt_work = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillageWorkTime",
				subparam = {
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
					enemy_id = "enemy_id"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					curValue = "is_avoid_tempest",
					compareValue = 0,
					judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
					compareType = AIFunctionDefsGetDefByKey("compareType").equal
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_need_save,
				bt_fishing
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
		bt_fire,
		bt_action_sleep,
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_getSleepState"
					}
				},
				{
					node = "BTNodeSelector",
					children = {
						bt_avoid_tempest,
						bt_need_eat,
						bt_meet_rainbow,
						bt_hunger_status,
						bt_work,
						bt_gossip
					}
				},
				bt_action_wakeup
			}
		},
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FishingVillageOtherTime",
						subparam = {
							bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
							bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId",
							enemy_id = "enemy_id"
						}
					}
				},
				bt_action_wakeup,
				{
					node = "BTNodeSelector",
					children = {
						bt_action_idle_stroll
					}
				}
			}
		}
	}
}

return bt

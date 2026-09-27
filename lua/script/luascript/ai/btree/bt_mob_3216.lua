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
					centerPos = "fishingvillagepos",
					rangeHeight = 2,
					rangeWidth = 10,
					bb_stollpos = "stollPos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "stollPos",
				CollideHorizontallyStop = false,
				speed = 0.8,
				minDistance = 0
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
				canTeleport = false,
				bbkey_followobj = "bbKeyBeHurtTargetObjId",
				speed = 1.3,
				minDistance = 1
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
				canTeleport = false,
				bbkey_followobj = "enemy_id",
				speed = 1.3,
				minDistance = 1
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
									compareValue = 1,
									extraValue = "bbKeyBeHurtTargetObjId",
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
									type = "actorInView",
									range = 16,
									extraValue = "bbKeyBeHurtTargetObjId"
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
									compareValue = 1,
									extraValue = "enemy_id",
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
									type = "actorInView",
									range = 16,
									extraValue = "enemy_id"
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
				bbkey_targetpos = "fishingvillagepos",
				avoidWater = true,
				speed = 1,
				minDistance = 0
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
									compareValue = 1,
									extraValue = "bedpos",
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
									bempty = true,
									equipslot = 0,
									searchType = 3,
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
				bbkey_targetpos = "bedpos",
				avoidWater = true,
				speed = 1,
				minDistance = 0
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
									compareValue = 1,
									extraValue = "bedpos",
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
									compareValue = 0,
									extraValue = "bedpos",
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
							compareValue = 0,
							extraValue = "bedpos",
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
					enemy_id = "enemy_id",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
	tip = "gossip",
	node = "BTNodeSelector",
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
												bbkey_targetpos = "gossipPos",
												avoidWater = true,
												speed = 1,
												minDistance = 2
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
					enemy_id = "enemy_id",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
						script = "BTTask_FishingVillageWomenWorkTime",
						subparam = {
							bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
							enemy_id = "enemy_id",
							bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
									compareValue = 0,
									extraValue = "bedpos",
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
				script = "BTTask_FishingVillageWomenWorkTime",
				subparam = {
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					enemy_id = "enemy_id",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
				bbkey_targetpos = "fishingvillagepos",
				avoidWater = true,
				speed = 1,
				minDistance = 0
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindBlock",
				subparam = {
					rangeY = 5,
					findPositionType = 2,
					range = 16,
					result_blockpos = "finditem_out_boxpos",
					findBlockType = AI_FIND_BOX_NOT_FULL
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "finditem_out_boxpos",
				avoidWater = true,
				speed = 1,
				minDistance = 1
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
								bbkey_targetpos = "fishingvillagepos",
								avoidWater = true,
								speed = 1,
								minDistance = 3
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
							compareValue = 0,
							curValue = "isRainbow",
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
										script = "BTTask_FishingVillageWomenWorkTime",
										subparam = {
											bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
											enemy_id = "enemy_id",
											bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_FishingVillageOtherTime",
										subparam = {
											bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
											enemy_id = "enemy_id",
											bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
									compareValue = 5,
									extraValue = 10,
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
									soundName = "ent.3216.surprise",
									animID = 100865,
									duration = 1
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
								script = "BTTask_FishingVillageWomenWorkTime",
								subparam = {
									bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
									enemy_id = "enemy_id",
									bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FishingVillageOtherTime",
								subparam = {
									bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
									enemy_id = "enemy_id",
									bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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
									compareValue = 1,
									curValue = "is_avoid_tempest",
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
											compareValue = 5,
											extraValue = 10,
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
											rangeHeight = 1,
											rangeWidth = 2,
											bb_stollpos = "stollPos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										bbkey_targetpos = "stollPos",
										CollideHorizontallyStop = false,
										speed = 0.5,
										minDistance = 0
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
										bbkey_targetpos = "fishingvillagepos",
										avoidWater = true,
										speed = 1,
										minDistance = 0
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
										bbkey_targetpos = "fishingvillagepos",
										avoidWater = true,
										speed = 1.2,
										minDistance = 0
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
					centerPos = "villagepos",
					rangeHeight = 2,
					rangeWidth = 6,
					bb_stollpos = "stollPos"
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
								bbkey_targetpos = "stollPos",
								CollideHorizontallyStop = false,
								speed = 0.3,
								minDistance = 1
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 1,
									animID = 100103,
									effectID = "mob_3200_hungery"
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
									soundName = "npc.hungry",
									duration = 1
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
				script = "BTTask_commonJudge",
				desc = "判断：背包内有食物",
				subparam = {
					compareType = 3,
					compareValue = 0,
					judgeType = 12,
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
				script = "BTTask_putFoodInHand",
				desc = "把食物放在手上",
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
				script = "BTTask_commonJudge",
				desc = "判断：背包中没有食物",
				subparam = {
					compareType = 2,
					compareValue = 0,
					judgeType = 12,
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
				bbkey_targetpos = "fishingvillagepos",
				avoidWater = true,
				speed = 1.2,
				minDistance = 0
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FindPosByNeedType",
						desc = "获取需求箱子位置 ",
						subparam = {
							findboxid = 801,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0,
							searchType = 2
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FindPosByNeedType",
						desc = "获取需求箱子位置 ",
						subparam = {
							findboxid = 1180,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0,
							searchType = 2
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_FindPosByNeedType",
						desc = "获取需求箱子位置 ",
						subparam = {
							findboxid = 1181,
							bbkey_itemid = "finditem",
							bbkey_targetpos = "BTTask_FindStoragePos",
							equipslot = 0,
							searchType = 2
						}
					}
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "BTTask_FindStoragePos",
				CollideHorizontallyStop = false,
				speed = 1,
				minDistance = 0
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_TakeItemToPack",
				desc = "从箱子中取出一定数量的道具",
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
										bt_harvesting_fish
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
local bt_drive_away = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindEatFishOfSeagulls",
				subparam = {
					bbkey_evictedobj = "bbkey_evictedobj",
					result_blockpos = "find_seagull_fish_frame_pos",
					searchRange = 20,
					mobId = 3622
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "find_seagull_fish_frame_pos",
				CollideHorizontallyStop = false,
				speed = 1.3,
				minDistance = 1
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3216.anger",
					animID = 100866,
					duration = 1
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_EvictedActor",
				subparam = {
					bbkey_evictedobj = "bbkey_evictedobj"
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 1
			}
		}
	}
}
local bt_node_find_item = {
	node = "BTNodeSelector",
	param = {
		tip = "find_item"
	},
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
			node = "BTNodeSequence",
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
					node = "BTNodeSelector",
					children = {
						{
							node = "BTNTaskMoveTo",
							param = {
								bbkey_targetpos = "fishingvillagepos",
								avoidWater = true,
								speed = 1,
								minDistance = AIFunctionDefsGetDefByKey("villageStoreRange")
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
							compareValue = 1,
							extraValue = "villagepos",
							judgeType = AIFunctionDefsGetDefByKey("judgeType").isBindWithVillagePoint,
							compareType = AIFunctionDefsGetDefByKey("compareType").equal
						}
					}
				},
				{
					node = "BTNodeSequence",
					param = {
						tip = "store range find items"
					},
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_FindItemFromBox",
								subparam = {
									findPositionType = 1,
									findCustomItems = "finditem_itemids",
									bbkey_out_iteminfo = "finditem_out_iteminfo",
									bbkey_out_boxpos = "finditem_out_boxpos",
									findItemType = AI_FIND_CUSTOM
								}
							}
						},
						{
							node = "BTNTaskMoveTo",
							param = {
								bbkey_targetpos = "finditem_out_boxpos",
								avoidWater = true,
								speed = 1,
								minDistance = 1
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_TakeItemToPack",
								subparam = {
									takeitemmode = 2,
									bbkey_in_boxpos = "finditem_out_boxpos",
									bbkey_multi_iteminfos = "finditem_itemids"
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
						script = "BTTask_FindItemFromBox",
						subparam = {
							findPositionType = 2,
							findCustomItems = "finditem_itemids",
							range = 11,
							bbkey_out_boxpos = "finditem_out_boxpos",
							findItemType = AI_FIND_CUSTOM
						}
					}
				},
				{
					node = "BTNTaskMoveTo",
					param = {
						bbkey_targetpos = "finditem_out_boxpos",
						avoidWater = true,
						speed = 1,
						minDistance = 1
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_TakeItemToPack",
						subparam = {
							takeitemmode = 2,
							bbkey_in_boxpos = "finditem_out_boxpos",
							bbkey_multi_iteminfos = "finditem_itemids"
						}
					}
				}
			}
		},
		bt_action_idle_stroll
	}
}
local bt_sun_dried_fish = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					curValue = "isSunDriedFish",
					compareValue = 1,
					judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
					compareType = AIFunctionDefsGetDefByKey("compareType").equal
				}
			}
		},
		{
			node = "BTNodeBranch",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_HaveBagContainerEx",
						subparam = {
							objId = 3216,
							workType = 1,
							itemCount = 1,
							itemId = 12520
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
									range = 20,
									bbKeyTargetPos = "find_sun_fish_frame_pos",
									targetID = 1192,
									targetType = AIFunctionDefsGetDefByKey("findTargetType").block
								}
							}
						},
						{
							node = "BTNTaskMoveTo",
							param = {
								bbkey_targetpos = "find_sun_fish_frame_pos",
								CollideHorizontallyStop = false,
								speed = 1,
								minDistance = 1
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_getFishStateByBlockFishFrame",
								subparam = {
									targettype = 0,
									blockpos = "find_sun_fish_frame_pos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_sunFishTakeInBags",
								subparam = {
									blockpos = "find_sun_fish_frame_pos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									duration = 0.5,
									animID = 100105
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
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							value = 0,
							key = "isSunDriedFish",
							valueType = AIFunctionDefsGetDefByKey("valueType").value
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
						script = "BTTask_HaveBagContainerEx",
						subparam = {
							objId = 3216,
							workType = 1,
							itemCount = 6,
							itemId = 12520
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_commonSetValue",
						subparam = {
							value = 1,
							key = "isSunDriedFish",
							valueType = AIFunctionDefsGetDefByKey("valueType").value
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
										script = "BTTask_commonSetValue",
										subparam = {
											key = "finditem_itemids",
											valueType = AIFunctionDefsGetDefByKey("valueType").value,
											value = {
												{
													itemid = 12520,
													num = 6
												}
											}
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonSetValue",
										subparam = {
											key = "finditem_itemids",
											valueType = AIFunctionDefsGetDefByKey("valueType").value,
											value = {
												{
													itemid = 12707,
													num = 6
												}
											}
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonSetValue",
										subparam = {
											key = "finditem_itemids",
											valueType = AIFunctionDefsGetDefByKey("valueType").value,
											value = {
												{
													itemid = 12708,
													num = 6
												}
											}
										}
									}
								}
							}
						},
						bt_node_find_item
					}
				}
			}
		}
	}
}
local bt_harvesting_fish = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonFindTargetPos",
				subparam = {
					range = 20,
					bbKeyTargetPos = "find_dried_fish_frame_pos",
					targetID = 1192,
					targetType = AIFunctionDefsGetDefByKey("findTargetType").block
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_getFishStateByBlockFishFrame",
						subparam = {
							targettype = 11659,
							blockpos = "find_dried_fish_frame_pos"
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_getFishStateByBlockFishFrame",
						subparam = {
							targettype = 12707,
							blockpos = "find_dried_fish_frame_pos"
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_getFishStateByBlockFishFrame",
						subparam = {
							targettype = 12708,
							blockpos = "find_dried_fish_frame_pos"
						}
					}
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "find_dried_fish_frame_pos",
				CollideHorizontallyStop = false,
				speed = 1,
				minDistance = 1
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_getAllSaltFishPutInBags",
				subparam = {
					bb_fishId = "fishId",
					blockpos = "find_dried_fish_frame_pos"
				}
			}
		},
		{
			node = "BTNodeWait",
			param = {
				wait = 0.5
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_EquipWeapon",
				subparam = {
					bbEquipItemNum = 1,
					bbEquipItemId = "fishId"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					soundName = "ent.3216.happy",
					animID = 100865
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
				script = "BTTask_PutHandItemInBags",
				subparam = {}
			}
		}
	}
}
local bt_pick_work_drop = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FindDropByList",
				desc = "搜寻范围内列表里的掉落物的位置",
				subparam = {
					bbPosKey = "find_drop_pos",
					bbTargetIdKey = "find_drop_targetid",
					listsKey = "famerToolsList"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				bbkey_targetpos = "find_drop_pos",
				CollideHorizontallyStop = false,
				speed = 1,
				minDistance = 1
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_Pick",
				desc = "捡起掉落物到背包",
				subparam = {
					out_Itemnum = "bb_gotItemNum",
					out_Itemid = "bb_gotItemid",
					dropItemId = "find_drop_targetid"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				desc = "通用播放动作叶子，所有的播放动作都可用此叶子实现",
				subparam = {
					duration = 0.5,
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
					objId = 3216,
					workType = 0,
					itemCount = 6,
					itemId = 11659
				}
			}
		},
		bt_save
	}
}
local bt_work = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_FishingVillageWomenWorkTime",
				subparam = {
					bbKeyBeHurtTargetObjId = "bbKeyBeHurtTargetObjId",
					enemy_id = "enemy_id",
					bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					compareValue = 0,
					curValue = "is_avoid_tempest",
					judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
					compareType = AIFunctionDefsGetDefByKey("compareType").equal
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_need_save,
				bt_drive_away,
				bt_harvesting_fish,
				bt_sun_dried_fish
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
					type = "isOnGround",
					reversal = true
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
							enemy_id = "enemy_id",
							bbKeyAttackTargetObjId = "bbKeyAttackTargetObjId"
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

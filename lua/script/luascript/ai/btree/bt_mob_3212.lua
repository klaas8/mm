local bt_fire_battle_attack_behurt = {
	node = "BTNodeSuccess",
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNTaskFollow",
					param = {
						speed = 1.1,
						canTeleport = false,
						bbkey_followobj = "bbKeyBeHurtTargetObjId",
						minDistance = 1.5
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
										speed = 1.3,
										canTeleport = false,
										bbkey_followobj = "enemy_id",
										minDistance = 2.5
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
									script = "BTTask_simpleFun",
									subparam = {
										attackActor = "bbKeyBeHurtTargetObjId",
										extraValue = "ActorDesertBusInessMan",
										fun = "clearHateUin"
									}
								}
							},
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
local bt_active_hate_fire = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isAttacking"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					extraValue = "ActorDesertBusInessMan",
					fun = "checkHateUinAndAttack"
				}
			}
		}
	}
}
local bt_fire = {
	node = "BTNodeSelector",
	children = {
		bt_active_fire,
		bt_fire_battle_attack_enemy,
		bt_active_hate_fire
	}
}
local bt_action_sleep = {
	node = "BTNodeSelector",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSleeping"
				}
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
							type = "hourCompare",
							reversal = true,
							extraValue = {
								min = 9,
								max = 19
							}
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_standUp"
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
										script = "BTTask_commonCompare",
										subparam = {
											type = "isUableBedPos",
											extraValue = "bedpos"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonSetValue",
										subparam = {
											value = 0,
											key = "bb_needResetGuardPos",
											valueType = AIFunctionDefsGetDefByKey("valueType").value
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
											bbkey_targetpos = "bedpos",
											bempty = true,
											equipslot = 0,
											searchType = 11
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonSetValue",
										subparam = {
											value = 1,
											key = "bb_needResetGuardPos",
											valueType = AIFunctionDefsGetDefByKey("valueType").value
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
						bbkey_targetpos = "bedpos",
						avoidWater = true,
						minDistance = 2
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
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_sleepOnAndBindBed",
						subparam = {
							bb_bedpos = "bedpos"
						}
					}
				},
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_simpleFun",
						subparam = {
							extraValue = 1,
							fun = "informGuard"
						}
					}
				},
				{
					node = "BTNodeSuccess",
					children = {
						node = "BTNodeSequence",
						children = {
							{
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											bb_pitch = "pitchPos",
											bb_pitchDir = "pitchDir",
											bb_bed = "bedpos",
											fun = "findPitchPos"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											extraValue = 4,
											fun = "informGuard"
										}
									}
								},
								node = "BTNodeTaskLua",
								param = {
									script = "BTTask_commonJudge",
									subparam = {
										curValue = "bb_needResetGuardPos",
										compareValue = 1,
										judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
										compareType = AIFunctionDefsGetDefByKey("compareType").equal
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
local bt_action_wakeup = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSleeping"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isAvoidingStand",
					extraValue = "ActorDesertBusInessMan",
					reversal = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "hourCompare",
					extraValue = {
						min = 9,
						max = 19
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_wakeAndbedUnOccupied",
				subparam = {
					bb_bedpos = "bedpos"
				}
			}
		}
	}
}
local bt_MovetoPitch = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "hourCompare",
					extraValue = {
						min = 9,
						max = 19
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
								script = "BTTask_commonCompare",
								subparam = {
									type = "isUsablePos",
									bb_pos = "pitchPos",
									range = 32
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									value = 0,
									key = "bb_needResetGuardPos",
									valueType = AIFunctionDefsGetDefByKey("valueType").value
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
									bbkey_targetpos = "bedpos",
									bempty = true,
									equipslot = 0,
									searchType = 11
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									extraValue = "bedpos",
									fun = "setBedBind"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									bb_pitch = "pitchPos",
									bb_pitchDir = "pitchDir",
									bb_bed = "bedpos",
									fun = "findPitchPos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									workDir = "pitchDir",
									workPos = "pitchPos",
									fun = "setMobWorkPos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									extraValue = 4,
									fun = "informGuard"
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
								script = "BTTask_FindPlaneArea",
								subparam = {
									bb_pitch = "pitchPos",
									extraValue = {
										range = 8,
										w = 3,
										blockid = {
											3,
											4,
											5,
											6,
											12,
											13,
											14,
											0
										}
									}
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									workDir = "pitchDir",
									workPos = "pitchPos",
									fun = "setMobWorkPos"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									value = 3,
									key = "bb_needResetGuardPos",
									valueType = AIFunctionDefsGetDefByKey("valueType").value
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
				bbkey_targetpos = "pitchPos",
				avoidWater = true,
				minDistance = 0.5
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_sitDown",
				subparam = {
					type = "ActorDesertBusInessMan"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_turnBodyByDir",
				subparam = {
					standDir = "pitchDir"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					extraValue = 0,
					fun = "informGuard"
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
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonJudge",
								subparam = {
									curValue = "bb_needResetGuardPos",
									compareValue = 3,
									judgeType = AIFunctionDefsGetDefByKey("judgeType").value,
									compareType = AIFunctionDefsGetDefByKey("compareType").equal
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									extraValue = 1,
									fun = "informGuard"
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
			searchRange = 4,
			waittimemax = 4,
			waittimemin = 1,
			actorwaittime = 2
		}
	}
}
local bt_specialSale = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					curValue = "bb_saleType",
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
								script = "BTTask_simpleFun",
								subparam = {
									bb_saleNum = "saleItemNum",
									bb_exchange = "exchangeItem",
									bb_player = "greeted_obj_id",
									fun = "exchangeItemFormPlayer",
									refuseSound = "bb_refuseSoundName",
									bb_exchangeNum = "exchangeItemNum",
									bb_sale = "saleItem"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									animID = 100829,
									duration = 2.5,
									exchangeItemId = "exchangeItem",
									soundName = "ent.3212.accept"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "greeted_obj_id",
									valueType = AIFunctionDefsGetDefByKey("valueType").value,
									value = {
										actor = 0
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
								script = "BTTask_commonPlayAction",
								subparam = {
									animID = 100828,
									duration = 1,
									soundName = "bb_refuseSoundName"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "greeted_obj_id",
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
local bt_camelSale = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonJudge",
				subparam = {
					curValue = "bb_saleType",
					compareValue = 2,
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
								script = "BTTask_simpleFun",
								subparam = {
									bb_saleNum = "saleItemNum",
									bb_exchange = "exchangeItem",
									bb_player = "greeted_obj_id",
									fun = "camelExchange",
									refuseSound = "bb_refuseSoundName",
									bb_exchangeNum = "exchangeItemNum",
									bb_sale = "saleItem"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonPlayAction",
								subparam = {
									animID = 100829,
									duration = 2.5,
									exchangeItemId = "exchangeItem",
									soundName = "ent.3212.accept"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "greeted_obj_id",
									valueType = AIFunctionDefsGetDefByKey("valueType").value,
									value = {
										actor = 0
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
								script = "BTTask_commonPlayAction",
								subparam = {
									animID = 100828,
									duration = 1,
									soundName = "bb_refuseSoundName"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonSetValue",
								subparam = {
									key = "greeted_obj_id",
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
local bt_interact = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "actorIsExist",
					extraValue = "greeted_obj_id"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_camelSale,
				bt_specialSale,
				{
					node = "BTNodeSuccess"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonSetValue",
				subparam = {
					value = 0,
					key = "bb_saleType",
					valueType = AIFunctionDefsGetDefByKey("valueType").value
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonSetValue",
				subparam = {
					key = "greeted_obj_id",
					valueType = AIFunctionDefsGetDefByKey("valueType").value,
					value = {
						actor = 0
					}
				}
			}
		}
	}
}
local bt_pitch = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "hourCompare",
					extraValue = {
						min = 9,
						max = 19
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
						script = "BTTask_commonCompare",
						subparam = {
							type = "isOnGround"
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
										script = "BTTask_commonCompare",
										subparam = {
											type = "isSitting",
											reversal = true
										}
									}
								},
								bt_MovetoPitch
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
											type = "isSitting"
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
											node = "BTNodeRandom",
											param = {
												defWeight = 120
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
																	script = "BTTask_commonSetValue",
																	subparam = {
																		value = 1,
																		key = "bb_saleType",
																		valueType = AIFunctionDefsGetDefByKey("valueType").value
																	}
																}
															},
															{
																node = "BTNodeTaskLua",
																param = {
																	script = "BTTask_simpleFun",
																	subparam = {
																		bb_saleNum = "saleItemNum",
																		bb_exchange = "exchangeItem",
																		fun = "setExchangeItem",
																		bb_exchangeNum = "exchangeItemNum",
																		bb_sale = "saleItem"
																	}
																}
															},
															{
																node = "BTNodeTaskLua",
																param = {
																	script = "BTTask_commonPlayAction",
																	subparam = {
																		exchangeItemId = "exchangeItem",
																		duration = 15,
																		soundName = "ent.3212.called",
																		saleItemId = "saleItem",
																		animID = 100110,
																		bb_exchangeNum = "exchangeItemNum",
																		bb_saleNum = "saleItemNum"
																	}
																}
															}
														}
													}
												},
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
																		value = 2,
																		key = "bb_saleType",
																		valueType = AIFunctionDefsGetDefByKey("valueType").value
																	}
																}
															},
															{
																node = "BTNodeTaskLua",
																param = {
																	script = "BTTask_commonCompare",
																	subparam = {
																		type = "haveSaleCamel"
																	}
																}
															},
															{
																node = "BTNodeTaskLua",
																param = {
																	script = "BTTask_simpleFun",
																	subparam = {
																		bb_saleNum = "saleItemNum",
																		bb_exchange = "exchangeItem",
																		fun = "setCamelExchangeItem",
																		bb_exchangeNum = "exchangeItemNum",
																		bb_sale = "saleItem"
																	}
																}
															},
															{
																node = "BTNodeTaskLua",
																param = {
																	script = "BTTask_commonPlayAction",
																	subparam = {
																		exchangeItemId = "exchangeItem",
																		duration = 15,
																		soundName = "ent.3212.called",
																		saleItemId = "saleItem",
																		animID = 100110,
																		bb_exchangeNum = "exchangeItemNum",
																		bb_saleNum = "saleItemNum",
																		isActor = true
																	}
																}
															}
														}
													}
												}
											}
										},
										bt_action_idle_lookAround
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
local bt_judgeWorkPos = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSitting",
					reversal = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSleeping",
					reversal = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isUsablePos",
					bb_pos = "pitchPos",
					range = 3200
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isPosOutRange",
					extraValue = {
						comparePos = "pitchPos",
						range = 2
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_standUp"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_taskExplore",
				subparam = {
					explorePos = "pitchPos",
					stagePos = "bb_curToPos"
				}
			}
		},
		{
			node = "BTNodeSuccess",
			children = {
				{
					node = "BTNTaskMoveTo",
					param = {
						speed = 1,
						bbkey_targetpos = "bb_curToPos",
						avoidWater = false,
						minDistance = 0
					}
				}
			}
		}
	}
}
local bt_judgeSitWorkPos = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSitting"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isSleeping",
					reversal = true
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isUsablePos",
					bb_pos = "pitchPos",
					range = 3200
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isPosOutRange",
					extraValue = {
						comparePos = "pitchPos",
						range = 2
					}
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_standUp"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_taskExplore",
				subparam = {
					explorePos = "pitchPos",
					stagePos = "bb_curToPos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1,
				bbkey_targetpos = "bb_curToPos",
				avoidWater = false,
				minDistance = 0
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_sitDown",
				subparam = {
					type = "ActorDesertBusInessMan"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_turnBodyByDir",
				subparam = {
					standDir = "pitchDir"
				}
			}
		}
	}
}
local bt_free = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isToEnd"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_judgeWorkPos,
				bt_judgeSitWorkPos,
				bt_action_sleep,
				bt_interact,
				bt_pitch
			}
		}
	}
}
local bt_follow = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isFollow"
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
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_simpleFun",
								subparam = {
									extraValue = "bb_followObj",
									fun = "setFollowObj"
								}
							}
						},
						{
							node = "BTNTaskFollow",
							param = {
								speed = 1.2,
								bbkey_followobj = "bb_followObj",
								minDistance = 2.5
							}
						}
					}
				}
			}
		}
	}
}
local bt_explore = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isToEnd",
					reversal = true
				}
			}
		},
		{
			node = "BTNodeSuccess",
			children = {
				{
					node = "BTNodeSelector",
					children = {
						bt_follow,
						{
							node = "BTNodeSelector",
							children = {
								{
									node = "BTNodeSequence",
									children = {
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_commonCompare",
												subparam = {
													type = "isPosOutRange",
													reversal = true,
													extraValue = {
														comparePos = "bb_explorePos",
														range = 2
													}
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													fun = "nextExplore"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													extraValue = "bb_explorePos",
													fun = "setExplorePos"
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
												script = "BTTask_simpleFun",
												subparam = {
													extraValue = "bb_explorePos",
													fun = "setExplorePos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_taskExplore",
												subparam = {
													explorePos = "bb_explorePos",
													stagePos = "bb_curToPos"
												}
											}
										},
										{
											node = "BTNTaskMoveTo",
											param = {
												speed = 1,
												bbkey_targetpos = "bb_curToPos",
												avoidWater = false,
												minDistance = 1
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
local bt_avoidStand = {
	node = "BTNodeBranch",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isInStandStorm",
					extraValue = "ActorDesertBusInessMan"
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
							type = "isAvoidingStand",
							extraValue = "ActorDesertBusInessMan",
							reversal = true
						}
					}
				},
				{
					node = "BTNodeSelector",
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
												script = "BTTask_commonCompare",
												subparam = {
													type = "isUsablePos",
													bb_pos = "bb_tentPos",
													range = 32,
													reversal = true
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_FindPlaneArea",
												subparam = {
													random = false,
													retType = 2,
													bb_pitch = "bb_tentPos",
													extraValue = {
														range = 5,
														w = 2,
														blockid = {
															3,
															4,
															5,
															6,
															12,
															13,
															14,
															0
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
												script = "BTTask_commonCompare",
												subparam = {
													type = "isUsablePos",
													bb_pos = "bb_tentPos",
													range = 32
												}
											}
										},
										{
											node = "BTNTaskMoveTo",
											param = {
												speed = 2,
												bbkey_targetpos = "bb_tentPos",
												avoidWater = true,
												minDistance = 0
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													bedPos = "bb_tentPos",
													fun = "placeBed"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_sleepOnAndBindBed",
												subparam = {
													bb_bedpos = "bb_tentPos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													value = true,
													extraValue = "ActorDesertBusInessMan",
													fun = "setAvoidStand"
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
												script = "BTTask_simpleFun",
												subparam = {
													bedPos = "bb_tentPos",
													extraValue = "ActorDesertBusInessMan",
													fun = "removeBed"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_wakeup",
												subparam = {
													bb_bedpos = "bb_tentPos"
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
														key = "bb_tentPos",
														valueType = AIFunctionDefsGetDefByKey("valueType").value,
														value = {
															z = 0,
															y = 0,
															x = 0
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
							node = "BTNodeSelector",
							param = {
								tip = "sit00000"
							},
							children = {
								{
									node = "BTNodeSequence",
									children = {
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													avoidStandPos = "bb_sitAvoidPos",
													extraValue = "ActorDesertBusInessMan",
													fun = "findSitAvoidStand"
												}
											}
										},
										{
											node = "BTNTaskMoveTo",
											param = {
												speed = 2,
												bbkey_targetpos = "bb_sitAvoidPos",
												avoidWater = true,
												minDistance = 0
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_sitDown",
												subparam = {
													type = "ActorDesertBusInessMan"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													value = true,
													extraValue = "ActorDesertBusInessMan",
													fun = "setAvoidStand"
												}
											}
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
												key = "bb_sitAvoidPos",
												valueType = AIFunctionDefsGetDefByKey("valueType").value,
												value = {
													z = 0,
													y = 0,
													x = 0
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
					node = "BTNodeSelector",
					children = {
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonCompare",
								subparam = {
									type = "isSleeping"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_commonCompare",
								subparam = {
									type = "isSitting"
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
											bb_bedpos = "bb_tentPos"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonCompare",
										subparam = {
											type = "isUableBedPos",
											extraValue = "bb_tentPos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										speed = 2,
										bbkey_targetpos = "bb_tentPos",
										avoidWater = true,
										minDistance = 0
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_sleepOnAndBindBed",
										subparam = {
											bb_bedpos = "bb_tentPos"
										}
									}
								}
							}
						},
						{
							node = "BTNodeSequence",
							param = {
								tip = "sit111"
							},
							children = {
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											bedPos = "bb_tentPos",
											extraValue = "ActorDesertBusInessMan",
											fun = "removeBed"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_getBedPos",
										subparam = {
											bb_bedpos = "bb_sitAvoidPos"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonCompare",
										subparam = {
											type = "isUsablePos",
											bb_pos = "bb_sitAvoidPos",
											range = 32
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										speed = 2,
										bbkey_targetpos = "bb_sitAvoidPos",
										avoidWater = true,
										minDistance = 0
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_sitDown",
										subparam = {
											type = "ActorDesertBusInessMan"
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
										script = "BTTask_simpleFun",
										subparam = {
											value = false,
											extraValue = "ActorDesertBusInessMan",
											fun = "setAvoidStand"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											bedPos = "bb_tentPos",
											extraValue = "ActorDesertBusInessMan",
											fun = "removeBed"
										}
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
								script = "BTTask_commonCompare",
								subparam = {
									type = "isAvoidingStand",
									extraValue = "ActorDesertBusInessMan"
								}
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_getBedPos",
								subparam = {
									bb_bedpos = "bb_tentPos"
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
											type = "isUableBedPos",
											extraValue = "bb_tentPos"
										}
									}
								},
								{
									node = "BTNodeSequence",
									children = {
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_wakeup",
												subparam = {
													bb_bedpos = "bb_tentPos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													bedPos = "bb_tentPos",
													extraValue = "ActorDesertBusInessMan",
													fun = "removeBed"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_commonSetValue",
												subparam = {
													key = "bb_tentPos",
													valueType = AIFunctionDefsGetDefByKey("valueType").value,
													value = {
														z = 0,
														y = 0,
														x = 0
													}
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													value = false,
													extraValue = "ActorDesertBusInessMan",
													fun = "setAvoidStand"
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
												script = "BTTask_standUp"
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_wakeup",
												subparam = {
													bb_bedpos = "bb_tentPos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													bedPos = "bb_sitAvoidPos",
													extraValue = "ActorDesertBusInessMan",
													fun = "removeBed"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													bedPos = "bb_tentPos",
													extraValue = "ActorDesertBusInessMan",
													fun = "removeBed"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_commonSetValue",
												subparam = {
													key = "bb_tentPos",
													valueType = AIFunctionDefsGetDefByKey("valueType").value,
													value = {
														z = 0,
														y = 0,
														x = 0
													}
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													value = false,
													extraValue = "ActorDesertBusInessMan",
													fun = "setAvoidStand"
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
							script = "BTTask_simpleFun",
							subparam = {
								value = false,
								extraValue = "ActorDesertBusInessMan",
								fun = "setAvoidStand"
							}
						}
					}
				}
			}
		}
	}
}
local bt_avoidStandMain = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isToEnd",
					reversal = true
				}
			}
		},
		bt_avoidStand
	}
}
local bt_warn = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					camelPos = "bb_camelPos",
					fun = "getPickingCamelPos"
				}
			}
		},
		{
			node = "BTNTaskMoveTo",
			param = {
				speed = 1.5,
				bbkey_targetpos = "bb_camelPos",
				avoidWater = true,
				minDistance = 3
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					fun = "informPlayerCloseUI"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonPlayAction",
				subparam = {
					animID = 100827,
					duration = 1,
					soundName = "ent.3212.anger"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					attackActor = "bbKeyBeHurtTargetObjId",
					extraValue = "ActorDesertBusInessMan",
					fun = "clearHateUin"
				}
			}
		}
	}
}
local bt_warnMain = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isWarning"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_warn,
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_simpleFun",
						subparam = {
							attackActor = "bbKeyBeHurtTargetObjId",
							extraValue = "ActorDesertBusInessMan",
							fun = "clearHateUin"
						}
					}
				}
			}
		}
	}
}
local bt_main = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isOnGround"
				}
			}
		},
		{
			node = "BTNodeSelector",
			children = {
				bt_action_wakeup,
				bt_fire,
				bt_warnMain,
				bt_avoidStandMain,
				bt_explore,
				bt_free
			}
		}
	}
}

return bt_main

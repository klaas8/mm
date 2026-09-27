local bt_fire_battle_attack_behurt = {
	node = "BTNodeSuccess",
	children = {
		{
			node = "BTNodeSequence",
			children = {
				{
					node = "BTNTaskFollow",
					param = {
						bbkey_followobj = "bbKeyBeHurtTargetObjId",
						minDistance = 1.5,
						speed = 1.1,
						canTeleport = false
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
					extraValue = "enemy_id",
					type = "actorIsInvalid"
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
							extraValue = "enemy_id",
							type = "actorInView"
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
										bbkey_followobj = "enemy_id",
										minDistance = 2.5,
										speed = 1.3,
										canTeleport = false
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
					extraValue = "bbKeyBeHurtTargetObjId",
					type = "actorIsInvalid"
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
							extraValue = "bbKeyBeHurtTargetObjId",
							type = "actorInView"
						}
					}
				},
				bt_fire_battle_attack_behurt,
				{
					node = "BTNodeSuccess",
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
local bt_fire = {
	node = "BTNodeSelector",
	children = {
		bt_active_fire,
		bt_fire_battle_attack_enemy
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
			waittimemax = 4
		}
	}
}
local bt_free = {
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
							type = "isStandGuard"
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
										script = "BTTask_simpleFun",
										subparam = {
											standDir = "standDir",
											workPos = "bb_workPos",
											fun = "setStandGuardPos"
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
													fun = "findStandGuardPos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													standDir = "standDir",
													workPos = "bb_workPos",
													fun = "setStandGuardPos"
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
															bb_pos = "bb_workPos",
															range = 6,
															type = "isUsablePos"
														}
													}
												},
												{
													node = "BTNodeFail",
													children = {
														{
															node = "BTNodeTaskLua",
															param = {
																script = "BTTask_commonCompare",
																subparam = {
																	type = "clearPos"
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
						},
						{
							node = "BTNTaskMoveTo",
							param = {
								avoidWater = true,
								minDistance = 0,
								speed = 1,
								bbkey_targetpos = "bb_workPos"
							}
						},
						{
							node = "BTNodeTaskLua",
							param = {
								script = "BTTask_turnBodyByDir",
								subparam = {
									standDir = "standDir"
								}
							}
						}
					}
				},
				{
					node = "BTNodeRandom",
					param = {
						defWeight = 120,
						weight = {
							80,
							20
						}
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
											fun = "resetMobHeadDir"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_commonPlayAction",
										subparam = {
											animID = 200202,
											duration = 30,
											effectID = 29,
											soundName = "npc.sleep"
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
local bt_returnVillage = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_simpleFun",
				subparam = {
					standDir = "standDir",
					workPos = "bb_explorePos",
					type = "getGuardWorkPos"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					bb_pos = "bb_explorePos",
					range = 8,
					reversal = true,
					type = "isUsablePos"
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
						comparePos = "bb_explorePos",
						range = 1
					}
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
				avoidWater = false,
				minDistance = 0,
				speed = 1,
				bbkey_targetpos = "bb_curToPos"
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_turnBodyByDir",
				subparam = {
					standDir = "standDir"
				}
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
				script = "BTTask_simpleFun",
				subparam = {
					extraValue = "bb_followObj",
					fun = "setGuardObj"
				}
			}
		},
		{
			node = "BTNodeTaskLua",
			param = {
				script = "BTTask_commonCompare",
				subparam = {
					type = "isNeedFollowTrade"
				}
			}
		},
		{
			node = "BTNTaskFollow",
			param = {
				bbkey_followobj = "bb_followObj",
				minDistance = 2,
				speed = 1.3
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
					extraValue = "ActorDesertBusInessManGuard",
					type = "isInStandStorm"
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
							extraValue = "ActorDesertBusInessManGuard",
							reversal = true,
							type = "isAvoidingStand"
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
													bb_pos = "bb_tentPos",
													range = 32,
													reversal = true,
													type = "isUsablePos"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_FindPlaneArea",
												subparam = {
													retType = 2,
													random = false,
													bb_pitch = "bb_tentPos",
													extraValue = {
														w = 2,
														range = 5,
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
													bb_pos = "bb_tentPos",
													range = 32,
													type = "isUsablePos"
												}
											}
										},
										{
											node = "BTNTaskMoveTo",
											param = {
												avoidWater = true,
												minDistance = 0,
												speed = 2,
												bbkey_targetpos = "bb_tentPos"
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
													extraValue = "ActorDesertBusInessManGuard",
													value = true,
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
													extraValue = "ActorDesertBusInessManGuard",
													bedPos = "bb_tentPos",
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
													extraValue = "ActorDesertBusInessManGuard",
													fun = "findSitAvoidStand"
												}
											}
										},
										{
											node = "BTNTaskMoveTo",
											param = {
												avoidWater = true,
												minDistance = 0,
												speed = 2,
												bbkey_targetpos = "bb_sitAvoidPos"
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_sitDown",
												subparam = {
													type = "ActorDesertBusInessManGuard"
												}
											}
										},
										{
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													extraValue = "ActorDesertBusInessManGuard",
													value = true,
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
											extraValue = "bb_tentPos",
											type = "isUableBedPos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										avoidWater = true,
										minDistance = 0,
										speed = 2,
										bbkey_targetpos = "bb_tentPos"
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
											extraValue = "ActorDesertBusInessManGuard",
											bedPos = "bb_tentPos",
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
											bb_pos = "bb_sitAvoidPos",
											range = 32,
											type = "isUsablePos"
										}
									}
								},
								{
									node = "BTNTaskMoveTo",
									param = {
										avoidWater = true,
										minDistance = 0,
										speed = 2,
										bbkey_targetpos = "bb_sitAvoidPos"
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_sitDown",
										subparam = {
											type = "ActorDesertBusInessManGuard"
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
											extraValue = "ActorDesertBusInessManGuard",
											value = false,
											fun = "setAvoidStand"
										}
									}
								},
								{
									node = "BTNodeTaskLua",
									param = {
										script = "BTTask_simpleFun",
										subparam = {
											extraValue = "ActorDesertBusInessManGuard",
											bedPos = "bb_tentPos",
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
									extraValue = "ActorDesertBusInessManGuard",
									type = "isAvoidingStand"
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
											extraValue = "bb_tentPos",
											type = "isUableBedPos"
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
													extraValue = "ActorDesertBusInessManGuard",
													bedPos = "bb_tentPos",
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
													extraValue = "ActorDesertBusInessManGuard",
													value = false,
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
												script = "BTTask_simpleFun",
												subparam = {
													extraValue = "ActorDesertBusInessManGuard",
													bedPos = "bb_sitAvoidPos",
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
											node = "BTNodeTaskLua",
											param = {
												script = "BTTask_simpleFun",
												subparam = {
													extraValue = "ActorDesertBusInessManGuard",
													bedPos = "bb_tentPos",
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
													extraValue = "ActorDesertBusInessManGuard",
													value = false,
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
								extraValue = "ActorDesertBusInessManGuard",
								value = false,
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
		bt_avoidStand
	}
}
local bt_main = {
	node = "BTNodeSelector",
	children = {
		bt_fire,
		bt_avoidStandMain,
		bt_follow,
		bt_returnVillage,
		bt_free
	}
}

return bt_main

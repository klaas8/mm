_G.BlackboardConfig = {
	MOB_3022 = "BB_MOB_3022",
	MOB_3915 = "BB_MOB_3915",
	MOB_3913 = "BB_MOB_3913",
	MOB_3912 = "BB_MOB_3912",
	MOB_3223 = "BB_MOB_3220",
	MOB_3222 = "BB_MOB_3220",
	MOB_3221 = "BB_MOB_3220",
	MOB_3220 = "BB_MOB_3220",
	MOB_3229 = "BB_MOB_3229",
	MOB_3219 = "BB_MOB_3218",
	MOB_3218 = "BB_MOB_3218",
	MOB_3217 = "BB_MOB_3216",
	MOB_3216 = "BB_MOB_3216",
	MOB_3215 = "BB_MOB_3214",
	MOB_3214 = "BB_MOB_3214",
	MOB_3209 = "BB_MOB_3208",
	MOB_3208 = "BB_MOB_3208",
	MOB_3207 = "BB_MOB_3204",
	MOB_3206 = "BB_MOB_3204",
	MOB_3205 = "BB_MOB_3204",
	MOB_3204 = "BB_MOB_3204",
	MOB_3213 = "BB_MOB_3210",
	MOB_3212 = "BB_MOB_3210",
	MOB_3211 = "BB_MOB_3210",
	MOB_3210 = "BB_MOB_3210",
	MOB_3239 = "BB_MOB_3200",
	MOB_3238 = "BB_MOB_3200",
	MOB_3237 = "BB_MOB_3200",
	MOB_3236 = "BB_MOB_3200",
	MOB_3235 = "BB_MOB_3200",
	MOB_3234 = "BB_MOB_3200",
	MOB_3233 = "BB_MOB_3200",
	MOB_3202 = "BB_MOB_3200",
	MOB_3201 = "BB_MOB_3200",
	MOB_3200 = "BB_MOB_3200"
}

function CheckBlackboardConfig(btscript)
	return BlackboardConfig[btscript] and true or false
end

function GetBlackboardConfig(btscript)
	return BlackboardConfig[btscript] or ""
end

function InitBlackboard_MOB_3200(bb)
	bb:SetData("bb_escapeSoundName", "ent.3200.scare")
	bb:SetData("bb_relaxSoundName", "ent.3200.relax")
	bb:SetData("bb_dying1SoundName", "ent.3200.dying1")
	bb:SetData("bb_tamedFoodId", 12502)
end

function InitBlackboard_MOB_3201(bb)
	bb:SetData("bb_escapeSoundName", "ent.3201.scare")
	bb:SetData("bb_relaxSoundName", "ent.3201.relax")
	bb:SetData("bb_dying1SoundName", "ent.3201.dying1")
	bb:SetData("bb_tamedFoodId", 12502)
end

function InitBlackboard_MOB_3202(bb)
	bb:SetData("bb_escapeSoundName", "ent.3202.scare")
	bb:SetData("bb_relaxSoundName", "ent.3202.relax")
	bb:SetData("bb_dying1SoundName", "ent.3202.dying1")
	bb:SetData("bb_tamedFoodId", 12502)
end

local function InitFunc(bb, id)
	local scare = string.format("ent.%d.scare", id)
	local relax = string.format("ent.%d.relax", id)
	local dying1 = string.format("ent.%d.dying1", id)

	bb:SetData("bb_escapeSoundName", scare)
	bb:SetData("bb_relaxSoundName", relax)
	bb:SetData("bb_dying1SoundName", dying1)
	bb:SetData("bb_tamedFoodId", 12534)
end

function InitBlackboard_MOB_3233(bb)
	InitFunc(bb, 3233)
end

function InitBlackboard_MOB_3234(bb)
	InitFunc(bb, 3234)
end

function InitBlackboard_MOB_3235(bb)
	InitFunc(bb, 3233)
end

function InitBlackboard_MOB_3236(bb)
	InitFunc(bb, 3233)
end

function InitBlackboard_MOB_3237(bb)
	InitFunc(bb, 3233)
end

function InitBlackboard_MOB_3238(bb)
	InitFunc(bb, 3233)
end

function InitBlackboard_MOB_3239(bb)
	InitFunc(bb, 3234)
end

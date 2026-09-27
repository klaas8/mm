local bt = {
	node = "BTNodeSequence",
	children = {
		{
			node = "BTNodeWait",
			param = {
				wait = 5
			}
		},
		{
			node = "BTNodeLoop",
			param = {
				loop = 2
			},
			children = {
				{
					node = "BTNodeTaskLua",
					param = {
						script = "BTTask_demo",
						subparam = {
							tool = 123
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
					1,
					20,
					100
				}
			},
			children = {
				{},
				{},
				{},
				{},
				{},
				{},
				{}
			}
		}
	}
}

return bt

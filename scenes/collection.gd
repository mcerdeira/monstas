extends Node2D

func _initialize(value):
	var monsta_nodes = get_children()
	for m in monsta_nodes:
		m.set_monsta(null)
		
	if !value:
		visible = false
	else:
		visible = true
		var id = null
		var monsta_idx = -1
		var count = 0
		var monstas = [] + Global.MONSTA_ENABLED
		monstas.sort()
		for m in monstas:
			if m.id != id:
				count = 1
				monsta_idx += 1
				id = m.id
				monsta_nodes[monsta_idx].set_monsta(m, count) 
			else:
				count += 1
				monsta_nodes[monsta_idx].set_monsta(m, count) 
				

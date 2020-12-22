class Lighting:
	
	const sz_tl = Globals.sz_tl
	const sz_ch = Globals.sz_ch
	
	var tl_color = {} # HSVA
	var tl_is_light = {} # bool
	
	var light_distance = 6
	var single_light = []
	var queue = []
	var dropoff = 0.7
	var dropoff_diag = dropoff * sqrt(2)
	
	func _init():
		for x in range(2*light_distance + 1):
			single_light.append([])
			for y in range(2*light_distance + 1):
				single_light[x].append([])
				for c in range(4):
					single_light[x][y].append(0)
	
	
	func get_color(x, y):
		return [0, 0, 0, 0]
	
	
	func set_color(x, y):
		pass
	
	
	func emit_single_light(x_root: int, y_root: int, color_root):
		
		for x in range(2*light_distance + 1):
			for y in range(2*light_distance + 1):
				for c in range(4):
					single_light[x][y][c] = 0
		queue.clear()
		
		single_light[light_distance][light_distance] = color_root
		queue.append(Vector2(x_root, y_root))
		
		while !queue.empty():
			var tl = queue.pop_front()
			var x = tl.x
			var y = tl.y
			
			var layer = max(abs(x - x_root), abs(y - y_root))
			
			var will_pass = false
			var color = get_color(x, y)
			
		
		return single_light
		#ch_loaded_ptr[ch].get_node("Sprite").material.set_shader_param("test", true)

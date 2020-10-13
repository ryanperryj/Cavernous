class Noise:

	var seed_hash : int 
	
	func _init(seed_string):
		seed_hash = seed_string.hash()
	
	func random_integer(lim_lower: int, lim_upper: int):
		# gives random integer in [lim_lower, lim_upper]
		randomize()
		return lim_lower + (randi() % (lim_upper - lim_lower + 1))
	
	func probability(chance: float):
		# gives boolean true at the chance (where chance ={ [0, 1])
		return chance*100 >= random_integer(1, 100)
	
	func random_2D(x: int, y: int) -> float:
		# standard "2D noise one-liner I found on the web"
		return fposmod(sin(Vector2(x, y).dot(Vector2(12.9898, 78.233))) * (43758.5453 + seed_hash % 100000), 1)
	
	func perlin_noise_2D(x: float, y: float, octaves: int) -> float:
		# perlin noise 2D with octaves loop
		if octaves < 1:
			return 0.0
		
		var final_val = 0.0
		var normalize_fac = 0.0
		var noise_scale = 0.5
		
		for _i in range(octaves):
			var floor_x: int = floor(x)
			var floor_y: int = floor(y)
			var fract_x = fposmod(x, 1)
			var fract_y = fposmod(y, 1)
			
			var tl = random_2D(floor_x    , floor_y    ) * 2*PI
			var tr = random_2D(floor_x + 1, floor_y    ) * 2*PI
			var bl = random_2D(floor_x    , floor_y + 1) * 2*PI
			var br = random_2D(floor_x + 1, floor_y + 1) * 2*PI
			
			var tl_x = -sin(tl)
			var tl_y = cos(tl)
			var tr_x = -sin(tr)
			var tr_y = cos(tr)
			var bl_x = -sin(bl)
			var bl_y = cos(bl)
			var br_x = -sin(br)
			var br_y = cos(br)
			
			var tl_dot = tl_x*(fract_x    ) + tl_y*(fract_y    )
			var tr_dot = tr_x*(fract_x - 1) + tr_y*(fract_y    )
			var bl_dot = bl_x*(fract_x    ) + bl_y*(fract_y - 1)
			var br_dot = br_x*(fract_x - 1) + br_y*(fract_y - 1)
			
			var top_mix = lerp(tl_dot, tr_dot, fract_x)
			var bot_mix = lerp(bl_dot, br_dot, fract_x)
			var whole_mix = lerp(top_mix, bot_mix, fract_y)
			
			var noise_val = 0.5 * whole_mix
			
			final_val += noise_val * noise_scale
			normalize_fac += noise_scale
			x *= 2.0
			y *= 2.0
			noise_scale *= 0.5
			
		return final_val / normalize_fac
	
	func value_noise_2D(x: float, y: float) -> float:
		var floor_x: int = floor(x)
		var floor_y: int = floor(y)
		var fract_x = x - floor_x
		var fract_y = y - floor_y
		var tl = random_2D(floor_x    , floor_y    )
		var tr = random_2D(floor_x + 1, floor_y    ) 
		var bl = random_2D(floor_x    , floor_y + 1)
		var br = random_2D(floor_x + 1, floor_y + 1)
		
		var top_mix = lerp(tl, tr, fract_x)
		var bot_mix = lerp(bl, br, fract_x)
		
		return lerp(top_mix, bot_mix, fract_y)

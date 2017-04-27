shaderPointLight =  love.graphics.newShader[[
	extern vec2 light_pos;
	vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
		vec4 pixel = Texel(texture, texture_coords);//This is the current pixel color
		//define light radius
		number radius = 128;
		if (length(screen_coords - light_pos) < radius) {
			//brighten the ground smoothly
			number t = (length(screen_coords - light_pos)/radius)* 0.9;
			return mix(vec4(0.8, 0.8, 0.7, 1.0), pixel * color, t);
		} else {
			return pixel * color;
		}
	}
]]
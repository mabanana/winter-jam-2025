shader_type canvas_item;

uniform sampler2D noise;
uniform float noisiness = 0.8;
uniform float band_width = 0.4;
uniform sampler2D color_texture;
uniform float progress;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float time = TIME;
	vec2 shiftedUV = vec2(UV.x * (time - floor(time)), UV.y);
	COLOR *= mix(texture(noise, shiftedUV).r, COLOR.r, noisiness);
	COLOR.a = band_width - abs(COLOR.r - sin(progress)) * (1.0 / band_width);
	COLOR.rgb = texture(color_texture, shiftedUV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

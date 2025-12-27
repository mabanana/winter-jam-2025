shader_type canvas_item;

uniform sampler2D noise;
uniform float noisiness = 0.8;
uniform float band_width = 0.4;
uniform sampler2D color_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR *= mix(texture(noise, UV).r, COLOR.r, noisiness);
	COLOR.a = band_width - abs(COLOR.r - sin(TIME)) * (1.0 / band_width);
	COLOR.rgb = texture(color_texture, UV).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

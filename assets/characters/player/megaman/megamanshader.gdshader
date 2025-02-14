shader_type canvas_item;
uniform vec4 bodyoutline:source_color;uniform vec4 bodyoutlcharge:source_color;
uniform vec4 bodycolorI:source_color;uniform vec4 chargecolorI:source_color;
uniform vec4 bodycolorII:source_color;uniform vec4 chargecolorII:source_color;
uniform float color_similarity_threshold : hint_range(0.0, 1.0) = 0.1;
void fragment() {
	vec4 color=texture(TEXTURE,UV); //checks for all colors in the animatedsprite
	vec3 color_diff = abs(color.rgb - bodycolorI.rgb);
	vec3 color_diff2 = abs(color.rgb - bodycolorII.rgb);//checks for color diff b/n bodycolorII and what Godot got
	vec3 color_diff3= abs(color.rgb- bodyoutline.rgb);
	float total_diff = dot(color_diff, vec3(1.0));
	float total_diff2 = dot(color_diff2, vec3(1.0));
	float total_diff3 = dot(color_diff3, vec3(1.0));
	 if (total_diff <= color_similarity_threshold)//
	 {
        COLOR = chargecolorI;
		}
//	if (color==bodycolorI){
//		COLOR=chargecolorI;
//	}
//	if (color==bodycolorII){
//		COLOR=chargecolorII;
//	}
	if (total_diff2<=color_similarity_threshold){
		COLOR=chargecolorII;
}
	if (color==bodyoutline){
		COLOR=bodyoutlcharge;
	}
}
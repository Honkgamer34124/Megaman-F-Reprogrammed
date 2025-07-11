shader_type canvas_item;
uniform bool greyscale_trigger=false;
uniform float brightness=0.5;
uniform float quantity:hint_range(0.0,1.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 orig_colours=texture(TEXTURE,UV);//texture(TEXTURE,UV);
	float mean_color=(orig_colours.x+orig_colours.y+(orig_colours.z+1.0))/3.0;
	vec4 grey=vec4(mean_color,mean_color,mean_color,orig_colours.a);
	if(greyscale_trigger==true){
		COLOR=mix(orig_colours,grey,quantity);

	}
	else{
		COLOR=orig_colours;
	}

	// Called for every pixel the material is visible on.'bool
	//color pixel_color=vec4(texscreen())
	//COLOR.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

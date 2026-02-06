varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D texture_sampler;
uniform lowp vec4 tint;
uniform lowp vec4 sprite_size;
uniform lowp vec4 area_size;
uniform lowp vec4 sprite_counts;
uniform lowp sampler2D sprite;

lowp vec2 get_sprite_uv(lowp float sprite_count_x) {
	// Calculate aspect ratio correction for Y scaling
	lowp float x_scale = area_size.x / (sprite_size.x * sprite_count_x);
	lowp float y_scale = area_size.y / sprite_size.y;
	lowp float aspect_correction = y_scale / x_scale;

	// Divide the quad into equal horizontal sections
	lowp float section_width = 1.0 / sprite_count_x;

	// Calculate local UV within the current section (0 to section_width)
	lowp float local_u = mod(var_texcoord0.x, section_width);

	// Map local UV to sprite UV - X repeats, Y anchored at bottom
	// sprite_v starts at 0 at bottom, goes past 1.0 where sprite ends
	lowp float sprite_v = var_texcoord0.y * aspect_correction;

	return vec2(local_u * sprite_count_x, sprite_v);
}

// Skew configuration
const lowp vec2 skew_origin = vec2(0.0, 0.0);  // Pivot point: bottom-center
const lowp float skew_amount = 0.5;             // Skew intensity (positive = lean right, negative = lean left)

// Apply skew transformation around origin
// x_factor: 0-1 based on horizontal position (0 = left/less skew, 1 = right/full skew)
lowp vec2 apply_skew(lowp vec2 uv, lowp float x_factor) {
	// Distance from origin in Y determines how much to shift X
	lowp float y_dist = uv.y - skew_origin.y;
	// Modulate skew by horizontal position
	lowp float x_offset = y_dist * skew_amount * x_factor;

	// Shift X relative to origin
	return vec2(uv.x - skew_origin.x + x_offset + skew_origin.x, uv.y);
}

// Sample sprite only in valid UV range, return transparent outside
// x_factor: horizontal position for skew modulation
lowp vec4 sample_sprite_bottom(lowp vec2 sprite_uv, lowp float x_factor) {
	// Apply skew transformation
	lowp vec2 skewed_uv = apply_skew(sprite_uv, x_factor);

	// Only render where UV is within sprite bounds (0-1)
	if(skewed_uv.y < 0.0 || skewed_uv.y > 1.0 || skewed_uv.x < 0.0 || skewed_uv.x > 1.0) {
		return vec4(0.0);
	}
	return texture2D(sprite, skewed_uv);
}

void main() {
	lowp vec2 sprite_uv_back = get_sprite_uv(sprite_counts.x);
	lowp vec2 sprite_uv_front = get_sprite_uv(sprite_counts.y);

	// Use horizontal position (0-1) to modulate skew: left = less, right = more
	lowp float x_factor = var_texcoord0.x;

	lowp vec4 sprite_color_back = sample_sprite_bottom(sprite_uv_back, x_factor) * tint;
	lowp vec4 sprite_color_front = sample_sprite_bottom(sprite_uv_front, x_factor) * tint;

	// Alpha blend: front over back
	gl_FragColor = sprite_color_front + sprite_color_back * (1.0 - sprite_color_front.a);
}

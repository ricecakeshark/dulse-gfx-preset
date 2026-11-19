#version 460
#extension GL_EXT_scalar_block_layout : enable
// in
//layout(location = 0) in vec3 in_pos;
// out
layout(location = 0) out vec4 draw_color;

void main()
{
	draw_color = vec4(1.0, 0.0, 1.0, 0.5);
	
	return;
}
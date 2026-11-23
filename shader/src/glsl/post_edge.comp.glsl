#version 460
#extension GL_EXT_scalar_block_layout : enable

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
// read
layout(set = 0, binding = 0) uniform sampler2D edge_texture;
// write
layout(set = 1, binding = 0, rgba16f) uniform writeonly image2D render_image;
// UBO
layout(std430, set = 2, binding = 0) uniform EdgeThreshold
{
	float entity;
	float normal;
	float depth;
} edge_threshold;

layout(std430, set = 2, binding = 1) uniform EdgeColor
{
	vec4 entity;
	vec4 normal;
	vec4 depth;
} edge_color;

void main()
{
	const vec2 image_size = imageSize(render_image);
	const ivec2 screen_pos = ivec2(gl_GlobalInvocationID.xy);
	if(screen_pos.x >= image_size.x || screen_pos.y >= image_size.y)
	{
		return;
	}
	// read edge evaluation from texture (g-buffer)
	const vec4 edge_eval = texelFetch(edge_texture, screen_pos, 0);
	
	vec4 draw_color = vec4(0.0, 0.0, 0.0, 0.0);
	
	if(edge_color.entity.a > 0.01 && edge_eval.r > edge_threshold.entity)
	{
		draw_color = edge_color.entity;
	}
	else if(edge_color.normal.a > 0.01 && edge_eval.g > edge_threshold.normal)
	{
		draw_color = edge_color.normal;
	}
	else if(edge_color.depth.a > 0.01 && edge_eval.b > edge_threshold.depth)
	{
		draw_color = edge_color.depth;
	}

	if(draw_color != vec4(0.0, 0.0, 0.0, 0.0))
	{
		imageStore(render_image, screen_pos, draw_color);
	}
	return;
}
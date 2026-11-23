module dulse_preset.uniform.post_edge;

import dulse.math;

struct UniformEdgeThreshold
{
	float entity;
	float normal;
	float depth;
}

struct UniformEdgeColor
{
	Vec4 outline_entity;
	Vec4 outline_normal;
	Vec4 outline_depth;
}
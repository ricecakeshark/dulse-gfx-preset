module dulse_preset.pipeline.fwd_solid;

import dulse_sdl;
import dulse_gfx;
import dulse_preset.texture;

GraphicsContext create_pipeline_fwd_solid(
	ref GraphicsContext gc,
	ref GraphicsPipeline solid_pipeline
)
{
	scope GpuVertexShader vertex_shader;
	scope GpuFragmentShader fragment_shader;
	gc.create(solid_pipeline, vertex_shader, fragment_shader);
	vertex_shader.create(
		ShaderFile("fwd_solid.vert", gc.get_shader_format()),
		GpuShaderArguments(0, 2, 0, 0),
	);
	fragment_shader.create(
		ShaderFile("fwd_solid.frag", gc.get_shader_format()),
		GpuShaderArguments(0, 2, 0, 0),
	);
	// Defer Pipeline
	scope GraphicsPipelineCreateInfo solid_pipeline_info;
	solid_pipeline_info.vertex_shader = vertex_shader;
	solid_pipeline_info.fragment_shader = fragment_shader;
	with (solid_pipeline_info)
	{
		vertex_input_state = GpuVertexInputState(
			[
				vertex_buffer_description!(float[3], float[3], float[4])
			],
			vertex_attributes!(float[3], float[3], float[4])(0),
		);
		primitive_type = GpuPrimitiveType.triangle_list;
		rasterizer_state = GpuRasterizerState(
			GpuFillMode.fill,
			GpuCullMode.back,
			GpuFrontFace.counter_clockwise,
		);
		depth_stencil_state = GpuDepthStencilState(
			GpuCompareOp.less,
			GpuStencilOpState.init,
			GpuStencilOpState.init,
			0u, 0u,
			true, true, false,
		);
		target_info = GraphicsPipelineTargetInfo(
			[
			GpuColorTargetDescription(
				gc.preset.albedo.format,
			),
			/+GpuColorTargetDescription(
				gc.preset.normal.format,
			),
			GpuColorTargetDescription(
				gc.preset.material.format,
			),
			GpuColorTargetDescription(
				gc.preset.entity.format,
			),+/
		], gc.preset.depth.format,
		);
	}
	solid_pipeline
		.bind(solid_pipeline_info)
		.create();
	return gc;
}

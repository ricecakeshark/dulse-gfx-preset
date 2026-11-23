module dulse_preset.pipeline.defer_light;

import dulse_sdl;
import dulse_gfx;

GraphicsContext create_pipeline_light(
	ref GraphicsContext graphics_context,
	ref ComputePipeline pipeline,
)
{
	graphics_context.create(pipeline);
	auto pipeline_create_info = ComputePipelineCreateInfo(
		ShaderFile("defer_light.comp", GpuShaderFormat.spirv)
	);
	with (pipeline_create_info)
	{
		num_readonly_storage_buffers = 1;
		num_samplers = 4;
		num_readwrite_storage_textures = 1;
		num_uniform_buffers = 2;
		threadcount_x = 8;
		threadcount_y = 8;
		threadcount_z = 1;
	}
	pipeline
		.bind(pipeline_create_info)
		.create();
	return graphics_context;
}

function obj = squeezenet_autonn_custom_fn(block, inputs, ~)
% SQUEEZENET_AUTONN_CUSTOM_FN autonn custom layer converter

  switch class(block)
    case 'dagnn.Permute'
      obj = Layer.create(@permute, {inputs{1}, block.order}) ;
    case 'dagnn.Flatten'
      obj = Layer.create(@vl_nnflatten, {inputs{1}, block.axis}) ;
    case 'dagnn.Reshape'
      obj = Layer.create(@vl_nnreshape, {inputs{1}, block.shape}) ;
  end

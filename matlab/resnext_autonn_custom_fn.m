function obj = resnext_autonn_custom_fn(block, inputs, ~)
% RESNEXT_AUTONN_CUSTOM_FN autonn custom layer converter
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

  switch class(block)
    case 'dagnn.Permute'
      obj = Layer.create(@permute, {inputs{1}, block.order}) ;
    case 'dagnn.Flatten'
      obj = Layer.create(@vl_nnflatten, {inputs{1}, block.axis}) ;
    case 'dagnn.Reshape'
      obj = Layer.create(@vl_nnreshape, {inputs{1}, block.shape}) ;
  end

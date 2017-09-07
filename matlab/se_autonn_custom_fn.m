function obj = se_autonn_custom_fn(block, inputs, ~)
% SE_AUTONN_CUSTOM_FN autonn custom layer converter for 
% Squeeze-and-Excitation networks
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
    case 'dagnn.GlobalPooling'
      obj = Layer.create(@vl_nnglobalpool, inputs(1)) ;
    case 'dagnn.Axpy'
      obj = Layer.create(@vl_nnaxpy, inputs(1:3)) ;
    case 'dagnn.Scale'
      obj = Layer.create(@vl_nnscale, ...
            [inputs(1:2) {'hasBias', block.hasBias, 'size', block.size}]) ;
    otherwise, keyboard
  end

function obj = fcn_autonn_custom_fn(block, inputs, ~)
% FCN_AUTONN_CUSTOM_FN autonn custom layer converter
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

  switch class(block)
    case 'dagnn.Crop'
      obj = vl_nncrop_wrapper(inputs{1}, inputs{2}, block.crop) ;
  end

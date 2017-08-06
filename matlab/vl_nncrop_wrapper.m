function y = vl_nncrop_wrapper(x1, x2, crop, dzdy)
%VL_NNCROP_WRAPPER AutoNN wrapper for MatConvNet's vl_nncrop
%  This wrapper computes adaptived crop sizes (as used in the 
%  FCN segmentation framework) to enable direct use of the 
%  vl_nncrop interface by cropping X1 to match the size of X2 

% Copyright (C) 2017 Samuel Albanie
% All rights reserved.

  v2 = size(x1,1) - size(x2,1) ;
  u2 = size(x1,2) - size(x2,2) ;
  v1 = max(0, v2 - crop(1)) ;
  u1 = max(0, u2 - crop(2)) ;
  adjCrop = [v2 - v1, v1, u2 - u1, u1] ;
  if nargin < 4
    y = vl_nncrop(x1, adjCrop) ;
  else  % backward pass
    y = vl_nncrop(x1, adjCrop, dzdy, inSz) ;
  end

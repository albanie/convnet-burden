function y = vl_nnscale(x1, x2, varargin)
% VL_NNSCALE Feature scaling
%   Y = VL_NNSCALE(X1, X2) rescales array X1 by array X2
% 
%  NOTE: Dummy layer used to check computational estimates
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.hasBias = false ;
  opts.size = [0 0 0 0] ;
  [opts, varargin] = vl_argparse(opts, varargin) ;
  if opts.hasBias, b = varargin{1} ; varargin(1) = [] ; end
  [opts, dzdy] = vl_argparsepos(opts, varargin) ;

  if isempty(dzdy)
    y = bsxfun(@times, x1, x2) ;
    if opts.hasBias
      y = bsxfun(@plus, y, b) ;
    end
  else
    error('not implemented') ; % This layer is only used for forward checks
  end

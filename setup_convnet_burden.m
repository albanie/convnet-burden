function setup_convnet_burden()
%SETUP_CONVNET_BURDEN Sets up convnet-burden, by adding its folders 
% to the Matlab path
%
% Copyright (C) 2017 Samuel Albanie 
% Licensed under The MIT License [see LICENSE.md for details]

  root = fileparts(mfilename('fullpath')) ;
  addpath(root, [root '/matlab'], [root '/core']) ;

function setup_convnet_burden()
%SETUP_CONVNET_BURDEN Sets up convnet-burden, by adding its folders 
% to the Matlab path

  root = fileparts(mfilename('fullpath')) ;
  addpath(root, [root '/matlab'], [root '/core']) ;

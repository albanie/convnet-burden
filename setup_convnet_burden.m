function setup_mcnBurden()
%SETUP_MCNBURDEN Sets up mcnBURDEN, by adding its folders 
% to the Matlab path, as well as setting up mcnFasterBURDEN as a dependency

  root = fileparts(mfilename('fullpath')) ;
  addpath(root) ;
  addpath(root, [root '/matlab'], [root '/core']) ;

function setup_convnet_burden()
%SETUP_CONVNET_BURDEN Sets up convnet-burden, by adding its folders
% to the Matlab path
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  check_dependency('mcnExtraLayers') ;
  root = fileparts(mfilename('fullpath')) ;
  addpath(root, [root '/matlab'], [root '/core']) ;

% -----------------------------------
function check_dependency(moduleName)
% -----------------------------------

  name2path = @(name) strrep(name, '-', '_') ;
  setupFunc = ['setup_', name2path(moduleName)] ;
  if exist(setupFunc, 'file')
    vl_contrib('setup', moduleName) ;
  else
    % try adding the module to the path, supressing the warning
    warning('off', 'MATLAB:dispatcher:pathWarning') ;
    addpath(fullfile(vl_rootnn, 'contrib', moduleName)) ;
    warning('on', 'MATLAB:dispatcher:pathWarning') ;

    if exist(setupFunc, 'file')
      vl_contrib('setup', moduleName) ;
    else
      waiting = true ;
      msg = ['module %s was not found on the MATLAB path. Would you like ' ...
             'to install it now? (y/n)\n'] ;
      prompt = sprintf(msg, moduleName) ;
      while waiting
        str = input(prompt,'s') ;
        switch str
          case 'y'
            vl_contrib('install', moduleName) ;
            vl_contrib('compile', moduleName) ;
            vl_contrib('setup', moduleName) ;
            return ;
          case 'n'
            throw(exception) ;
          otherwise
            fprintf('input %s not recognised, please use `y` or `n`\n', str) ;
        end
      end
    end
  end


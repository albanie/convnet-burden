function demo_burden(varargin)
%DEMO_BURDEN Minimalistic demonstration of mcnBurden
%
% Copyright (C) 2017 Samuel Albanie
% All rights reserved.

  opts.gpus = [] ;
  opts.helper = [] ;
  opts.lastConv = 'pool5' ;
  opts.type = 'single' ;
  opts.batchSize = 10 ;
  opts.scales = 0.5:0.5:4 ;
  opts.modelPath = 'data/models-import/imagenet-matconvnet-alex.mat' ;
  opts = vl_argparse(opts, varargin) ;

  useGpu = numel(opts.gpus) > 0 ;dag = loadDagNN(opts) ; 
  [~,modelName,~] = fileparts(opts.modelPath) ;
  modelOpts.inputVars = dag.getInputs() ; modelOpts.name = modelName ;
  opts.modelOpts = modelOpts ; out = toAutonn(dag, opts) ; 
  net = Net(out{:}) ;

  if useGpu, net.move('gpu') ; end
  imsz = net.meta.normalization.imageSize(1:2) ;
  paramMem = computeMemory(net, 'params', [], opts) ;
  fullMem = computeMemory(net, 'feats', imsz, opts) ;

  % find fully convolutional component
  keyboard
  trunk = Net(out{1}.find(opts.lastConv, 1)) ;
  if useGpu, trunk.move('gpu') ; end
  trunkMem = computeMemory(trunk, 'feats', imsz, opts) ;
  tail = fullMem - trunkMem ;
  report(numel(opts.scales)).imsz = [] ;

  for ii = 1:numel(opts.scales)
    imsz_ = round(imsz * opts.scales(ii)) ;
    [mem, lastSz] = computeMemory(trunk, 'feats', imsz_, opts) ;
    mem = (mem + tail) * opts.batchSize ;
    report(ii).imsz = imsz_ ;
    report(ii).feat = readableMemory(mem) ;
    report(ii).lastSz = lastSz ;
  end
  printReport(paramMem, report, opts) ;
  if useGpu, trunk.move('cpu') ; end

% ------------------------------------------
function printReport(paramMem, report, opts)
% ------------------------------------------
  header = sprintf('Report for %s\n', opts.modelOpts.name) ;
  fprintf('%s\n', repmat('-', 1, numel(header))) ;
  fprintf(header) ;
  fprintf('%s\n', repmat('-', 1, numel(header))) ;
  fprintf('memory used by params: %s\n', readableMemory(paramMem)) ;
  fprintf('memory used by feats with bs %d: \n', opts.batchSize) ;
  disp(struct2table(report)) ;

% -----------------------------------
function memStr = readableMemory(mem)
% -----------------------------------
% READABLEMEMORY(MEM) convert total raw bytes into more readable summary
% based on J. Henriques' autonn varDisplay() function

  suffixes = {'B ', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB'} ;
  place = floor(log(mem) / log(1024)) ;  % 0-based index into 'suffixes'
  place(mem == 0) = 0 ;  % 0 bytes needs special handling
  num = mem ./ (1024 .^ place) ; memStr = num2str(num, '%.0f') ; 
  memStr(:,end+1) = ' ' ;
  memStr = [memStr, char(suffixes{max(1, place + 1)})] ;  
  memStr(isnan(mem),:) = ' ' ;  % leave invalid values blank

% --------------------------------
function dag = loadDagNN(opts)
% --------------------------------
  stored = load(opts.modelPath) ;
  if ~isfield(stored, 'params') % simplenn
    dag = dagnn.DagNN.fromSimpleNN(stored) ;
  else
    dag = dagnn.DagNN.loadobj(stored) ;
  end

% --------------------------------
function out = toAutonn(net, opts)
% --------------------------------
% provide required helper functions for custom architectures

  args = {net} ;
  if strfind(opts.modelOpts.name, 'faster-rcnn')
    args = [args {@faster_rcnn_autonn_custom_fn}] ;
  elseif strfind(opts.modelOpts.name, 'ssd')
    args = [args {@ssd_autonn_custom_fn}] ;
  end
  out = Layer.fromDagNN(args{:}) ;

% ------------------------------------------------------------
function [mem,lastSz] = computeMemory(net, target, imsz, opts)
% ------------------------------------------------------------

  if ~isempty(imsz) 
    x = zeros([imsz 3], opts.type) ; 
    if numel(opts.gpus), x = gpuArray(x) ; end
    keyboard
    net.eval({opts.modelOpts.inputVars{1}, x}, 'test') ;
  end

  params = [net.params.var] ;
  feats = find(arrayfun(@(x) ~ismember(x, params), 1:2:numel(params))) ;

  switch target
    case 'feats', p = feats ; lastSz = size(net.getValue(opts.lastConv)) ; 
    case 'params', p = params ; lastSz = [] ;
    otherwise, error('%s not recognised') ;
  end

  switch opts.type
    case 'int8', bytes = 1 ;
    case 'uint8', bytes = 1 ;
    case 'int16', bytes = 2 ;
    case 'uint16', bytes = 2 ;
    case 'int32', bytes = 4 ;
    case 'uint32', bytes = 4 ;
    case 'int64', bytes = 8 ;
    case 'uint64', bytes = 8 ;
    case 'single', bytes = 4 ;
    case 'double', bytes = 8 ;
    otherwise, error('data type %s not recognised') ;
  end

  total = sum(arrayfun(@(x) numel(net.vars{x}), p)) ;
  mem = total * bytes ;

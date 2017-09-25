function burden(varargin)
%BURDEN compute memory and computational burden of network
%
% Copyright (C) 2017 Samuel Albanie
% Licensed under The MIT License [see LICENSE.md for details]

  opts.gpus = [] ;
  opts.helper = [] ;
  opts.imsz = [224 224] ;
  opts.type = 'single' ;
  opts.batchSize = 128 ;
  opts.lastConvFeats = '' ;
  opts.scales = 0.5:0.5:3 ;
  opts.reportDir = fullfile(vl_rootnn, 'contrib/convnet-burden/reports') ;
  opts.modelPath = 'data/models-import/imagenet-matconvnet-alex.mat' ;
  opts = vl_argparse(opts, varargin) ;

  useGpu = numel(opts.gpus) > 0 ; dag = loadDagNN(opts) ; 

  % set options which are specific to current model
  [~,modelName,~] = fileparts(opts.modelPath) ;
  modelOpts.name = modelName ; modelOpts.inputVars = dag.getInputs() ; 
  modelOpts.lastConvFeats = getLastFullyConv(modelName, opts) ; 
  opts.modelOpts = modelOpts ; out = toAutonn(dag, opts) ; net = Net(out{:}) ;

  if useGpu, net.move('gpu') ; end
  imsz = opts.imsz ; 
  baseParams = computeBurden(net, 'params', imsz, opts) ;
  base.paramMem = sum(baseParams) ;
  [featMem,flops] = computeBurden(net, 'full', imsz, opts) ;
  base.featMem = sum(featMem) ; base.flops = sum(flops) ;
  plotProfile(baseParams, featMem, flops, opts) ;

  % find fully convolutional component
  if ~isempty(modelOpts.lastConvFeats)
    for ii = 1:numel(out) % to avoid hardcoding head ordering, try them in turn
      try tail = out{ii}.find(modelOpts.lastConvFeats, 1) ; break
      catch ME, tail = [] ; %#ok -> continue to try remaining heads
      end
    end
    trunk = Net(tail) ;
    if useGpu, trunk.move('gpu') ; end
  else
    trunk = net ;
  end
  report(numel(opts.scales)).imsz = [] ;

  for ii = 1:numel(opts.scales)
    imsz_ = round(imsz * opts.scales(ii)) ;
    [mem_, flops_, lastSz] = computeBurden(trunk, 'feats', imsz_, opts) ;
    mem = sum(mem_) * opts.batchSize ; flops = sum(flops_) * opts.batchSize ;
    report(ii).imsz = sprintf('%d x %d', imsz_) ;
    report(ii).flops = readableFlops(flops) ;
    report(ii).featMem = readableMemory(mem) ;
    report(ii).featSz = sprintf('%d x %d x %d', lastSz) ;
  end
  printReport(base, report, opts) ;
  if useGpu, trunk.move('cpu') ; end

% --------------------------------------
function printReport(base, report, opts)
% --------------------------------------
  modelName = readableName(opts.modelOpts.name) ;

  % produce readable output 
  header = sprintf('Report for %s\n', modelName) ;
  fprintf('%s\n', repmat('-', 1, numel(header))) ;
  fprintf(header) ;
  fprintf('Data type of feats and params: %s\n', opts.type) ; % for humans
  fprintf('Memory used by params: %s\n', readableMemory(base.paramMem)) ;

  msg1 = 'Computing burden for single item batch at imsz %s: \n' ;
  msg2 = '    Memory consumed by full feats: %s\n' ;
  msg3 = '    Estimated total flops: %s\n' ;
  baseImsz = report(opts.scales ==1).imsz ;
  fprintf(msg1, baseImsz) ;
  fprintf(msg2, readableMemory(base.featMem)) ;
  fprintf(msg3, readableFlops(base.flops)) ;

  msg1 = 'Computing burden for %d item batch at imsz %s: \n' ;
  msg2 = '    Memory consumed by full feats: %s\n' ;
  msg3 = '    Estimated total flops: %s\n' ;
  fprintf(msg1, opts.batchSize, baseImsz) ;
  fprintf(msg2, readableMemory(opts.batchSize*base.featMem)) ;
  fprintf(msg3, readableFlops(base.flops * opts.batchSize)) ;

  % produce output for shared table
  detailedReport = sprintf('reports/%s.md', modelName) ;
  stats = {readableMemory(base.paramMem), ...
           readableMemory(base.featMem), ...
           readableFlops(base.flops)} ;
  markdown = 'MD:: | [%s](%s) | %s | %s | %s | %s|\n' ; 
  fprintf(markdown, modelName, detailedReport, baseImsz, stats{:}) ;

  fprintf('%s\n', repmat('-', 1, numel(header))) ;
  msg = '\nFeature extraction burden at %s with batch size %d: \n\n' ;
  fprintf(msg, opts.modelOpts.lastConvFeats, opts.batchSize) ;
  disp(struct2table(report)) ;

  % generate detailed report for feature extraction
  if ~exist(opts.reportDir, 'dir'), mkdir(opts.reportDir) ; end
  reportPath = fullfile(opts.reportDir, sprintf('%s.md', modelName)) ;
  header = '### Report for %s\n' ;
  body = ['Model params %s \n\n' ...
          'Estimates for a single full pass of model at input size %s: \n' ...
          '\n' ...
          '* Memory required for features: %s \n' ...
          '* Flops: %s \n' ...
          '\n' ...
          'Estimates are given below of the burden of computing the `%s` ' ...
          'features in the network for different input sizes using a '...
          'batch size of %d: \n\n'] ;
  bodyArgs = {readableMemory(base.paramMem), baseImsz, ...
             readableMemory(base.featMem), readableFlops(base.flops), ...
             opts.modelOpts.lastConvFeats, opts.batchSize} ;

  tableHeader = ['| input size | feature size | feature memory | flops | \n' ...
                 '|------------|--------------|----------------|-------| \n'] ;
  tableRow = '| %s | %s | %s | %s |\n' ;
  graphDescription = ['\nA rough outline of where in the network memory is ' ...
  'allocated to parameters and features and where the greatest computational '...
  'cost lies is shown below.  The x-axis does not show labels (it becomes hard' ...
  ' to read for networks containing hundreds of layers) - it should be ' ...
  'interpreted as depicting increasing depth from left to right.  The goal is'  ...
  ' simply to give some idea of the overall profile of the model: \n\n'] ;
  graph = '![%s profile](figs/%s.png)\n' ;

  fid = fopen(reportPath, 'w') ;
  fprintf(fid, header, modelName) ;
  fprintf(fid, body, bodyArgs{:}) ;
  fprintf(fid, tableHeader) ;
  for ii = 1:numel(report)
    rec = report(ii) ;
    fprintf(fid, tableRow, rec.imsz, rec.featSz, rec.featMem, rec.flops) ;
  end
  fprintf(fid, graphDescription) ;
  fprintf(fid, graph, modelName, modelName) ;
  fclose(fid) ;

% ----------------------------------------------------
function plotProfile(baseParams, featMem, flops, opts)
% ----------------------------------------------------
  subplot(3,1,1) ; 
  [~,units,factor] = readableMemory(max(baseParams)) ;
  scaledParams = baseParams ./ factor ;
  bar(scaledParams, 'FaceAlpha', 0.6, 'edgecolor','none') ; 
  title('Parameter memory profile') ;  set(gca,'xtick',[]) ; 
  ylabel(sprintf('memory (%s)', units)) ;

  subplot(3,1,2) ; 
  [~,units,factor] = readableMemory(max(featMem)) ;
  scaledFeats = featMem ./ factor ;
  bar(scaledFeats, 'FaceAlpha', 0.4, 'FaceColor', 'r', 'edgecolor','none') ; 
  title('Feature memory profile') ;  set(gca,'xtick',[]) ; 
  ylabel(sprintf('memory (%s)', units)) ;

  subplot(3,1,3) ; 
  [~,units,factor] = readableFlops(max(flops)) ;
  scaledFlops = flops ./ factor ;
  bar(scaledFlops, 'FaceAlpha', 0.3, 'FaceColor', 'm', 'edgecolor','none') ; 
  title('Flops profile') ;  set(gca,'xtick',[]) ; 
  ylabel(sprintf('%sFLOPS', units)) ; xlabel('depth') ;
  figDir = fullfile(opts.reportDir, 'figs') ;
  if ~exist(figDir, 'dir'), mkdir(figDir) ; end
  figName = sprintf('%s.png', readableName(opts.modelOpts.name)) ;
  figPath = fullfile(figDir, figName)  ;
  print(figPath, '-dpng') ;

% -------------------------------------
function name = readableName(modelName)
% -------------------------------------
% READABLENAME(MODELNAME) renames the model to its canonical name 
% for easier reading

name = strrep(modelName, '_', '-') ; % use consistent separators
name = strrep(name, 'imagenet-', '') ; % clean up prefixes
name = strrep(name, '-pt-mcn', '') ; % clean up suffixes
name = strrep(name, '-mcn', '') ; 
name = strrep(name, '-dag', '') ; 
name = strrep(name, 'verydeep', 'vd') ; % consistent naming
name = strrep(name, 'reduced', 'atrous') ; 

switch name % handle special cases
  case 'matconvnet-alex', name = 'alexnet' ; 
  case 'caffe-ref', name = 'caffenet' ; 
end

% ----------------------------------------------------
function [memStr, units, factor] = readableMemory(mem)
% ----------------------------------------------------
% READABLEMEMORY(MEM) convert total raw bytes into more readable summary
% based on J. Henriques' autonn varDisplay() function

  suffixes = {'B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB'} ;
  place = floor(log(mem) / log(1024)) ;  % 0-based index into 'suffixes'
  place(mem == 0) = 0 ;  % 0 bytes needs special handling
  num = mem ./ (1024 .^ place) ; memStr = num2str(num, '%.0f') ; 
  memStr(:,end+1) = ' ' ; units = suffixes{max(1, place + 1)} ;
  memStr = [memStr, char(units)] ; factor = 1024^(max(place,1)) ;
  memStr(isnan(mem),:) = ' ' ;  % leave invalid values blank

% ------------------------------------------------------
function [flopStr, units, factor] = readableFlops(flops)
% ------------------------------------------------------
% READABLEFLOPS(FLOPS) convert total flops into more readable summary

  suffixes = {' ', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'} ;
  place = floor(log(flops) / log(1000)) ;  % 0-based index into 'suffixes'
  place(flops == 0) = 0 ;  % 0 bytes needs special handling
  num = flops ./ (1000 .^ place) ; flopStr = num2str(num, '%.0f') ; 
  flopStr(:,end+1) = ' ' ; units = suffixes{max(1, place + 1)} ;
  flopStr = [flopStr, char(units) 'FLOPs'] ; factor = 1000^(max(place,1)) ;
  flopStr(isnan(flops),:) = ' ' ;  % leave invalid values blank

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
  if contains(opts.modelOpts.name, 'faster-rcnn')
    args = [args {@faster_rcnn_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, 'ssd')
    args = [args {@ssd_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, 'rfcn')
    args = [args {@rfcn_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, 'squeezenet')
    args = [args {@squeezenet_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, 'resnext')
    args = [args {@resnext_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, 'inception')
    args = [args {@inception_autonn_custom_fn}] ;
  elseif contains(opts.modelOpts.name, {'SE', '-fcn', 'deeplab-'})
    args = [args {@extras_autonn_custom_fn}] ;
  end
  out = Layer.fromDagNN(args{:}) ;

% -----------------------------------------------
function last = getLastFullyConv(modelName, opts)
% -----------------------------------------------
%GETlASTCONV - find the last convolutional layer of the network
%  GETlASTCONV(OPTS) - looks up the last "fully convolutional"
%  layer of the network architecture. This is the last layer that can
%  be computed with any input image size (fully connected layers 
%  typically break under varying input sizes).  In this function the
%  last layer is "looked up" for common architectures as a convenience.
%  However, the user may also specify the name of the layer output
%  variable directly.

  last = opts.lastConvFeats ;
  if ~isempty(last) ; return ; end
  alexFamily = {'imagenet-matconvnet-alex', ...
                'imagenet-vgg-f', ...
                'imagenet-vgg-m', ...
                'imagenet-vgg-s', ...
                'imagenet-vgg-m-2048', ...
                'imagenet-vgg-m-1024', ...
                'imagenet-vgg-m-128', ...
                'imagenet-caffe-ref', ...
                'imagenet-vgg-verydeep-16', ...
                'imagenet-vgg-verydeep-19', ...
                'vgg-vd-16-reduced'}  ;
  resnets = {'imagenet-resnet-50-dag', ...
             'imagenet-resnet-101-dag', ...
             'imagenet-resnet-152-dag'} ;
  resnexts = {'resnext_50_32x4d-pt-mcn', ...
              'resnext_101_32x4d-pt-mcn', ...
              'resnext_101_64x4d-pt-mcn'} ;
  fcns = {'pascal-fcn32s-dag', 'pascal-fcn16s-dag', 'pascal-fcn8s-dag'} ;
  squeezenets = {'squeezenet1_0-pt-mcn', 'squeezenet1_1-pt-mcn'} ;
  if ismember(modelName, alexFamily), last = 'pool5' ; 
  elseif ismember(modelName, resnets), last = 'res5c_relu' ; 
  elseif ismember(modelName, resnexts), last = 'features_7_2_id_relu' ; 
  elseif ismember(modelName, squeezenets), last = 'features_12_cat' ; 
  elseif ismember(modelName, fcns), last = 'score_fr' ;
  elseif contains(modelName, 'googlenet'), last = 'icp9_out' ; 
  elseif contains(modelName, 'multipose'), last = 'Mconv6_stage6_L2' ; 
  elseif contains(modelName, 'faster-rcnn') || contains(modelName, 'rfcn') 
    if contains(modelName, 'vggvd'), last = 'relu5_3' ; end
    if contains(modelName, 'res50'), last = 'res5c_relu' ; end
    if contains(modelName, 'res101'), last = 'res5c_relu' ; end
  elseif contains(modelName, 'ssd')
    if contains(modelName, 'vggvd'), last = 'relu4_3' ; end
    if contains(modelName, 'res50'), last = 'res5c_relu' ; end
    if contains(modelName, 'res101'), last = 'res5c_relu' ; end
    if contains(modelName, 'mobilenet'), last = 'conv17_2_relu' ; end
  elseif contains(modelName, 'inception'), last = 'features_19' ; 
  elseif contains(modelName, 'SE-BN-Inception'), last = 'inception_5b_scale' ; 
  elseif contains(modelName, 'SE'), last = 'conv5_3' ; 
  elseif strcmp(modelName, 'deeplab-vggvd-v2'), last = 'fc8_interp' ;
  elseif strcmp(modelName, 'deeplab-res101-v2'), last = 'fc1_interp' ;
  else
    keyboard
  end
  msg = ['architecture not recognised, last fully convolutional layer must' ...
         ' be specified directly using the lastConvFeats option'] ;
  assert(~isempty(last), msg) ;

% -----------------------------------------------------------------
function [mem,flops,lastSz] = computeBurden(net, target, imsz, opts)
% -----------------------------------------------------------------

  flops = 0 ; lastSz = [] ; 
  last = opts.modelOpts.lastConvFeats ;
  params = [net.params.var] ;
  inputs = cellfun(@(x) net.inputs.(x), fieldnames(net.inputs))' ;
  feats = 3:2:numel(net.vars) ;
  keep = arrayfun(@(x) ~ismember(x, [params inputs]), feats) ;
  feats = feats(keep) ;

  switch target
    case 'params'
      p = params ; mem = computeMemory(net, p, opts) ; return 
    case {'feats', 'full'}
      x = zeros([imsz 3], opts.type) ; 
      if numel(opts.gpus), x = gpuArray(x) ; end
      inVars = opts.modelOpts.inputVars ; args = {inVars{1}, x} ;
      if ismember('im_info', inVars) && strcmp(target, 'full') % handle custom inputs
        args = [args {'im_info', [imsz 1]}] ;
      end
      net.eval(args, 'test') ; p = feats ; lastSz = size(net.getValue(last)) ;
      mem = computeMemory(net, p, opts) ;  flops = computeFlops(net) ;
    otherwise, error('%s not recognised') ;
  end

% ---------------------------------------
function mem = computeMemory(net, p, opts)
% ---------------------------------------
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
  mem = arrayfun(@(x) numel(net.vars{x}), p) * bytes ;

% -------------------------------------------
function totals = computeFlops(net, varargin) 
% -------------------------------------------
  opts.includeExp = 0 ;
  opts = vl_argparse(opts, varargin) ;

  totals = zeros(1, numel(net.forward)) ;
  for ii = 1:numel(net.forward)
    layer = net.forward(ii) ;
    ins = gather(net.vars(layer.inputVars)) ;
    outs = gather(net.vars(layer.outputVar)) ;
    funcStr = func2str(layer.func) ;
    switch funcStr
      case 'vl_nnconv' % count fused multiply-adds
        hasBias = (numel(ins) == 3) ;
        flops = numel(outs{1}) * numel(ins{2}(:,:,:,1)) ;
        if hasBias, flops = flops + numel(outs{1}) ; end
      case 'vl_nnconvt' 
        hasBias = (numel(ins) == 3) ;
        flops = numel(ins{1}) * numel(ins{2}(:,:,1,:)) ;
        if hasBias, flops = flops + numel(outs{1}) ; end
      case 'vl_nnrelu' % count as comparison + multiply
        flops = 2 * numel(outs{1}) ;
      case 'vl_nnpool' % assume two flops per location
        pos = find(cellfun(@(x) isequal(x, 'stride'), layer.args)) ;
        stride = layer.args{pos+1} ;
        flops = 2 * numel(outs{1}) * prod(stride) ;
      case 'vl_nnglobalpool' % FMA
        flops = numel(ins{1}) ;
      case 'vl_nnbnorm_wrapper', flops = 0 ; % assume merged at test time
      case 'vl_nnwsum', flops = numel(outs{1}) ; % count fused multiply-adds
      case 'vl_nnreshape', flops = 0 ; % essentially free
      case 'vl_nnflatten', flops = 0 ; % essentially free
      case 'vl_nncrop', flops = 0 ; % index slicing
      case 'permute', flops = 0 ; % expensive, but no flops
      case 'cat', flops = 0 ; % can be expensive, but no flops
      case 'size', flops = 0 ;
      case 'max', flops = numel(ins{1}) ; % comparisons
      case 'vl_nnproposalrpn', flops = 0 ; % would be too inaccurate
      case 'vl_nnmultiboxdetector', flops = 0 ; % would be too inaccurate
      case 'vl_nnpriorbox', flops = 0 ; % not worth computing
      case 'vl_nnroipool', flops = 0 ; % would be too inaccurate
      case 'vl_nnpsroipool', flops = 0 ; % would be too inaccurate
      case 'vl_nnmask', flops = 0 ; % dropout would be removed during inference
      case 'vl_nndropout_wrapper', flops = 0 ; % ditto
      case 'vl_nninterp', flops = 4 * numel(outs{1}) ;
      case 'vl_nnmax', flops = numel(outs{1}) * numel(ins) ;
      case {'vl_nnscalenorm', 'vl_nnnormalize'} 
        outSz = size(outs{1}) ; % simplifying assumption: common norm factors
        normFactors = (1 + 1 + 2 * outSz(3)) * prod(outSz(1:2)) ; 
        flops = numel(outs{1}) + normFactors ;
      case {'vl_nnsoftmax', 'vl_nnsoftmaxt'} % counting flops for exp is tricky
        if opts.includeExp
          flops = (2+1+5+1+2)*numel(outs{1}) ;
        else 
          flops = 0 ; 
        end
      case 'vl_nnsigmoid' % counting flops for exp is tricky
        if opts.includeExp, flops = 3*numel(outs{1}) ; else, flops = 0 ; end
      case 'vl_nnaxpy', flops = 2*numel(outs{1}) ; % use FMA
      case 'vl_nnscale', flops = numel(outs{1}) ; % use FMA
      case 'root', continue
      otherwise, error('layer %s not recognised', func2str(layer.func)) ;
    end
    totals(ii) = flops ;
  end

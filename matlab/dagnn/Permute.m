classdef Permute < dagnn.ElementWise
  properties
    order
  end

  methods
    function outputs = forward(obj, inputs, params)
      outputs{1} = permute(inputs{1}, obj.order);
    end

    function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
      derInputs{1} = ipermute(derOutputs{1}, obj.order) ;
      derParams = {} ;
    end

    function outputSizes = getOutputSizes(obj, inputSizes)
      outputSizes{1} = inputSizes{1}(obj.order) ;
    end

    function rfs = getReceptiveFields(obj)
      rfs = {} ;
    end

    function load(obj, varargin)
      s = dagnn.Layer.argsToStruct(varargin{:}) ;
      load@dagnn.Layer(obj, s) ;
    end

    function obj = Permute(varargin)
      obj.load(varargin{:}) ;
      obj.order = obj.order ;
    end
  end
end

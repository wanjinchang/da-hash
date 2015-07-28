classdef Concat < dagnn.ElementWise
  properties
    dim = 3
    numInputs = 2
  end

  properties (Transient)
    inputSizes = {}
  end
  
  methods
    function outputs = forward(obj, inputs, params)
      outputs{1} = vl_nnconcat(inputs, obj.dim) ;
      obj.inputSizes = cellfun(@size, inputs, 'UniformOutput', false) ;
    end

    function [derInputs, derParams] = backward(obj, inputs, params, derOutpus)
      outputs{1} = vl_nnconcat(inputs, derOutputs{1}, 'inputSizes', obj.inputSizes) ;
    end

    function reset(obj)
      obj.inputSizes = {} ;
    end

    function outputSizes = getOutputSizes(obj, inputSizes)
      sz = inputSizes{1} ;
      for k = 2:numel(inputSizes)
        sz(obj.dim) = sz(obj.dim) + inputSizes{k}(obj.dim) ;
      end
      outputSizes{1} = sz ;
    end
    
    function rfs = getReceptiveFields(obj)
      if obj.dim == 3 || obj.dim == 4
        rfs = getReceptiveFields@dagnn.ElementWise(obj) ;
        rfs = repmat(rfs, obj.numInputs, 1) ;
      else
        for i = 1:obj.numInputs
          rfs(i,1).size = [NaN NaN] ;
          rfs(i,1).stride = [NaN NaN] ;
          rfs(i,1).offset = [NaN NaN] ;
        end
      end
    end
          
    function obj = Concat(varargin)
      obj.load(varargin) ;
    end
  end
end

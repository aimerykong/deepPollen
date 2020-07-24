classdef MaxProb4MIL < dagnn.ElementWise
    properties (Transient)
        numInputs
        SIZE_
        viewIndex
    end
    
    methods        
        function outputs = forward(obj, inputs, params)            
            X = inputs{1};
            tmp = squeeze(X);
            tmp = max(tmp,[],1);
            tmp = squeeze(tmp);
            [~,obj.viewIndex] = max(tmp);
            outputs{1} = X(:,:,:,obj.viewIndex);            
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            derInputs = cell(1, numel(inputs));
                        
            dzdy = derOutputs{1};            
            X = inputs{1};
            dzdx = zeros(size(X,1),size(X,2),size(X,3),size(X,4),'single');
            dzdx = gpuArray(dzdx);
            dzdx(:,:,:,obj.viewIndex) = dzdy;
            derInputs{1} = gpuArray(dzdx);
            derParams = {} ;            
        end
        
        function obj = MaxProb4MIL(varargin)
            obj.load(varargin) ;
        end
    end
end

classdef SliceDiverter < dagnn.ElementWise
    properties
        sliceIndex
    end
    
    methods        
        function outputs = forward(obj, inputs, params)            
            X = inputs{1};            
            if obj.sliceIndex(1)<0            
                a = setdiff(1:size(X,4),abs(obj.sliceIndex));
                outputs{1} = X(:,:,:,a);
            else
                outputs{1} = X(:,:,:,obj.sliceIndex);
            end
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            derInputs = cell(1, numel(inputs));                        
            dzdy = derOutputs{1};
            X = inputs{1};
            dzdx = zeros(size(X,1),size(X,2),size(X,3),size(X,4),'single');  
            dzdx = gpuArray(dzdx);
            if obj.sliceIndex(1)<0            
                a = setdiff(1:size(X,4),abs(obj.sliceIndex));
                dzdx(:,:,:,a) = dzdy;
            else
                dzdx(:,:,:,obj.sliceIndex) = dzdy;
            end            
            % dzdx(:,:,:,obj.sliceIndex) = dzdy;
            derInputs{1} = gpuArray(dzdx);
            derParams = {} ;
        end
        
        function obj = SliceDiverter(varargin)
            obj.load(varargin) ;
        end
    end
end

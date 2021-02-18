classdef Method_III < Method_II

    properties
        % Empty
    end % class data members
    
    methods(Access = public)
        
        function obj = Method_III()
            obj@Method_II();
        end % end class constructor
      
        function obj = testAll(obj)
            
            obj.testsCount = ...
                zeros(1, length(1:obj.symbolSize:obj.codeSize));
            
            indexCounter = 1;
            totalBag = [];
            
            for i = 1:obj.symbolSize:obj.codeSize
                symbol = obj.codeWord(i:i+obj.symbolSize-1);
                [obj.testsCount(indexCounter), bag] = testSymbol(obj, symbol);
                totalBag = [totalBag, bag];
                indexCounter = indexCounter + 1;
            end % for
            
            % Make sure that length of total bag is divisible by
            % the symbol size. Add some zeros to make it divisible
            % This change the results but in a very insignificant way
            % e.g., in order of 1 in 5000. 
            extraZeros = obj.symbolSize -...
                mod(length(totalBag), obj.symbolSize);
            extraZeros = mod(extraZeros, obj.symbolSize);
            totalBag = [totalBag, zeros(1, extraZeros)];
            
            binaryTestPrune = Method_II();
            binaryTestPrune = setParameter(binaryTestPrune, ...
                totalBag, obj.symbolSize);
            binaryTestPrune = testAll(binaryTestPrune);
            obj.testsCount = [obj.testsCount, binaryTestPrune.testsCount];
            
        end % function testAll
        
    end % end class public services
    
    methods(Access = protected)
        
        function [testsPerformedCount, bag] = testSymbol(obj, symbol)
            
            % Coombine all samples and test them
            testsPerformedCount = 1;
            bag = [];
            
            % if there is only one sample, test that sample
            % and you are done
            if length(symbol) == 1                
                return;
            end
            
            % if there are more than one sample, combine all 
            % samples and test them. If the test is negative for
            % all of them, then no one has the disease and we 
            % are done. 
            if sum(symbol) == 0   
                return;
            end
            
            % The case where parent node is 01. Here, we know at least
            % one person is sick. As soon as we test the first node and
            % we see it is zero, we can conclude the other person is sick
            % and there is no reason to test the other person. So the
            % number of tests must be 2 as opposed to three. Here, we
            % start from zero to end up with 2.
            if length(symbol) == 2 && symbol(1) == 0
                testsPerformedCount = 0;
            end
            
            if length(symbol) == 2 && symbol(1) == 1
                testsPerformedCount = 0;
                bag = symbol(2);
            end
            
            % At this point, there is at least one sample with positive
            % result. Break the symbol into to halves and repeat to find
            % that positive symbol
            midIndex = length(symbol) / 2;
            
            [result1, bag1] = testSymbol(obj, symbol(1:midIndex));
            [result2, bag2] = testSymbol(obj, symbol(midIndex+1:end));
            bag = [bag, bag1, bag2];
            
            testsPerformedCount = testsPerformedCount +...
                result1 + result2;
        end % function testSymbol
        
    end % class protected utilities
    
end % class Method_III
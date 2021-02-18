classdef Method_I

    properties
        codeWord;
        codeSize;
        symbolSize;
        testsCount;
    end % class data members
    
    methods(Access = public)
        
        % Explicit initialization
        % Always a good idea
        function obj = Method_I()
            obj.codeWord = 0;
            obj.codeSize = 0;
            obj.symbolSize = 0;
            obj.testsCount = 0;
        end % end class constructor
        
        function obj = setParameter(obj, codeWord, symbolSize)            
            codeWordSize = length(codeWord);
            
            if mod(codeWordSize, symbolSize) ~= 0
                fprintf("Code word length must be divisible by symbol ");
                fprintf("length.\n");
                return;
            end

            obj.codeSize = codeWordSize;
            obj.codeWord = codeWord;
            obj.symbolSize = symbolSize;
            
            if log2(symbolSize) ~= round(log2(symbolSize))  
                fprintf("symbol length must be a power of 2.\n");
                return;
            end % if
                        
        end % function setBinarySearch
        
        function obj = testAll(obj)
            
            obj.testsCount = ...
                zeros(1, length(1:obj.symbolSize:obj.codeSize));
            
            indexCounter = 1;
            
            for i = 1:obj.symbolSize:obj.codeSize
                symbol = obj.codeWord(i:i+obj.symbolSize-1);
                obj.testsCount(indexCounter) = testSymbol(obj, symbol);
                indexCounter = indexCounter + 1;
            end % for
            
        end % function testAll
        
    end % end class public services
    
    methods(Access = protected)
        
        function testsPerformedCount = testSymbol(obj, symbol)
            
            % Coombine all samples and test them
            testsPerformedCount = 1;
            
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
            
            % At this point, there is at least one sample with positive
            % result. Break the symbol into to halves and repeat to find
            % that positive symbol
            midIndex = length(symbol) / 2;
            
            testsPerformedCount = testsPerformedCount +...
                testSymbol(obj, symbol(1:midIndex)) + ...
                testSymbol(obj, symbol(midIndex+1:end));
        end % function testSymbol
        
    end % class protected utilities
    
end % class Method_I
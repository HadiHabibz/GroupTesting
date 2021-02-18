classdef Method_V

    properties
        codeWord;
        codeSize;
        symbolSize;
        testsCount;
        bagFlag;
    end % class data members
    
    methods(Access = public)
        
        % Explicit initialization
        % Always a good idea
        function obj = Method_V()
            obj.codeWord = 0;
            obj.codeSize = 0;
            obj.symbolSize = 0;
            obj.testsCount = 0;
        end % end class constructor
        
        function obj = setParameter(obj, codeWord, symbolSize, doBaging)            
            codeWordSize = length(codeWord);
            
            if mod(codeWordSize, symbolSize) ~= 0
                fprintf("Code word length must be divisible by symbol ");
                fprintf("length.\n");
                return;
            end

            obj.codeSize = codeWordSize;
            obj.codeWord = codeWord;
            obj.symbolSize = symbolSize;
            
            if nargin <= 3
                obj.bagFlag = 1;
            else 
                obj.bagFlag = doBaging;
            end
            
            if mod(symbolSize, 3) ~= 0 ||...
                log2(symbolSize/3) ~= round(log2(symbolSize/3))  
                fprintf("symbol length must be in form 3 x 2^x.\n");
                return;
            end % if
                        
        end % function setBinarySearch
        
        function obj = testAll(obj)
            
            obj.testsCount = ...
                zeros(1, length(1:obj.symbolSize:obj.codeSize));
            totalbag = [];
                       
            indexCounter = 1;
            
            for i = 1:obj.symbolSize:obj.codeSize
                symbol = obj.codeWord(i:i+obj.symbolSize-1);
                [obj.testsCount(indexCounter), bag] = testSymbol(obj, symbol);
                totalbag = [totalbag, bag];
                indexCounter = indexCounter + 1;
            end % for
            
            % Make sure that length of total bag is divisible by
            % the symbol size. Add some zeros to make it divisible
            % This change the results but in a very insignificant way
            % e.g., in order of 1 in 5000. 
            extraZeros = obj.symbolSize -...
                mod(length(totalbag), obj.symbolSize);
            extraZeros = mod(extraZeros, obj.symbolSize);
            totalBag = [totalbag, zeros(1, extraZeros)];
            
            if obj.bagFlag ~= 0 || (~isempty(totalBag))
                tester = Method_V();
                tester = setParameter(tester, ...
                    totalBag, obj.symbolSize, 0);
                tester = testAll(tester);
                obj.testsCount = [obj.testsCount, tester.testsCount];
            end 
        end % function testAll
        
    end % end class public services
    
    methods(Access = protected)
        
        function [testsPerformedCount, bag] = testSymbol(obj, symbol)
            
            % Coombine all samples and test them
            testsPerformedCount = 1;
            bag = [];
            
            if length(symbol) == 1
                return;
            end
            
            if sum(symbol) == 0
                return;
            end
            
            if length(symbol) > 3            
                % At this point, there is at least one sample with positive
                % result. Break the symbol into to halves and repeat to find
                % that positive symbol
                midIndex = length(symbol) / 2;

                testsPerformedCount = testsPerformedCount +...
                    testSymbol(obj, symbol(1:midIndex)) + ...
                    testSymbol(obj, symbol(midIndex+1:end));
                return;
            end            
            
            if sum(symbol([1, 2])) == 0
                 testsPerformedCount = 2;    
                 return;
            end
            
            if sum(symbol([2, 3])) == 0
                 testsPerformedCount = 3;
                return;
            end
            
            if sum(symbol([1, 3])) == 0
                 testsPerformedCount = 4;
                return;
            end
            
            if symbol(1) == 0
                 testsPerformedCount = 5;
                return;
            end
            
            if symbol(2) == 0
                 testsPerformedCount = 6;
                return;
            end
            
            if obj.bagFlag == 0
                testsPerformedCount = 7;
                return;
            end
            
            bag = [bag, symbol(3)];
            testsPerformedCount = 6;
           
        end % function testSymbol
        
    end % class protected utilities
    
end % class Method_I
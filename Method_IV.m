classdef Method_IV < Method_I
    
    properties
        p;
        symbolsCount;
        huffmanCodes;
    end % class data members
    
    methods(Access = public)
        
        function obj = Method_IV()
            obj@Method_I();
            obj.p = 1/2;
            obj.symbolsCount = 0;
        end % function constructor
        
        function obj = setProbability(obj, probability)
            obj.p = probability;
            obj.huffmanCodes = extractHuffman(obj);
        end % class setProbability
        
    end % class public services
    
    methods(Access = protected)
        
        function codes = extractHuffman(obj)
            obj.symbolsCount = 2^obj.symbolSize;
            probabilityMass = zeros(1, obj.symbolsCount);
            
            for i = 1:obj.symbolsCount
                successCount = sum(dec2bin(i-1) - '0');
                failureCount = obj.symbolSize - successCount;
                probabilityMass(i) = obj.p^(successCount) *...
                    (1-obj.p)^(failureCount);
            end % for i
            
            symbols = 1:obj.symbolsCount;
            codes = huffmandict(symbols, probabilityMass);            
        end % function extractHuffman
        
        function testsPerformedCount = testSymbol(obj, symbol)            
            index = bin2dec(char(symbol+'0')) + 1;
            testsPerformedCount = length(obj.huffmanCodes{index, 2});
        end % function testSymbol
        
    end % class private utilities
    
end % class Method_IV
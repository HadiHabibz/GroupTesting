classdef Method_II < Method_I

    properties
        % Empty
    end % class data members
    
    methods(Access = public)
        
        function obj = Method_II()
            obj@Method_I();
        end % end class constructor
        
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
            
            % The case where parent node is 01. Here, we know at least
            % one person is sick. As soon as we test the first node and
            % we see it is zero, we can conclude the other person is sick
            % and there is no reason to test the other person. So the
            % number of tests must be 2 as opposed to three. Here, we
            % start from zero to end up with 2.
            if length(symbol) == 2 && symbol(1) == 0
                testsPerformedCount = 0;
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
    
end % class Method_II
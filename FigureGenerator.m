classdef FigureGenerator
    
    properties(Access = private)
        fontsize;
        linewidth;
        population;
        markersize;
    end % class data members
    
    methods(Access = public)
        
        function obj = FigureGenerator()
            obj.fontsize = 40;
            obj.linewidth = 8;
            obj.population = 256*1024; 
            obj.markersize = obj.fontsize / 5;
        end % Constructor
        
        function generate_bitrate(obj, groupSize)
            
            p =  0:0.0125:0.5;
            f0 = -1*(p.*log2(p) + (1-p).*log2(1-p));
            results = zeros(5, length(p));
            results(5, :) = [0, f0(2:end)];
            newPopulation = 3 * obj.population / 4;
            
            for i = 1:length(p)
                samples = generateBinaryString(obj, obj.population, p(i));
                
                method1 = Method_I();
                method1 = setParameter(method1, samples, groupSize(1));
                method1 = testAll(method1);

                method2 = Method_II();
                method2 = setParameter(method2, samples, groupSize(1));
                method2 = testAll(method2);

                method3 = Method_III();
                method3 = setParameter(method3, samples, groupSize(1));
                method3 = testAll(method3);  
                
                method5 = Method_V();                
                method5 = setParameter(method5, samples(1:newPopulation), 3);
                method5 = testAll(method5);
 
                results(1, i) = sum(method1.testsCount) / obj.population;
                results(2, i) = sum(method2.testsCount) / obj.population;
                results(3, i) = sum(method3.testsCount) / obj.population;
                results(4, i) = sum(method5.testsCount) / newPopulation;
            end % for i
            
            colors = linspecer(5);
            greyColor = [0.8,0.8,0.8];
            colors(5, :) = greyColor;
            markers = ['o', 's', '^', 'p', '+'];
            figure;            
            
            for i = 1:4
                plot(p, results(i, :), '-', 'Color', colors(i, :),...
                    'LineWidth', obj.linewidth, 'Marker', markers(i),...
                    'MarkerSize', obj.markersize, 'MarkerIndices',...
                    1:2:length(p));
                hold on;
            end % for i
            
            plot(p, results(5, :), '--', 'Color', colors(5, :),...
                    'LineWidth', obj.linewidth);
                
            hold off;
            xlabel('P');            
            ylabel('Entropy (bits)');
            xticks(0:0.05:0.5);
            xticklabels(0:0.05:0.5);
            ylim([0 1.4]);
            yticks(0:0.2:1.4);
            yticklabels(0:0.2:1.4);
            grid on;
            myLegend = legend('Method I', 'Method II', 'Method III',...
                'Method IV', 'H');
            myLegend.Location = 'southeast';
            box off;
            legend boxoff;
            set( gca,'FontSize', obj.fontsize,...
                'LineWidth', obj.linewidth/2,...
                'GridAlpha', 0.07,...
                'GridLineStyle', ':' );  

            
        end % function generate_bitrate
        
        function plotTheoric(obj)
            
            p =  0:0.0125:0.5;
            f0 = -1*(p.*log2(p) + (1-p).*log2(1-p));
            f1 = -2*p.^2 + 4*p + 1;
            f2 = -1*p.^2 + 3*p + 1;
            f3 = -0.5 * (p.^3 - p.^2 -5*p -2);
            f5 = -3*p.^3 + 2*p.^2 + 6*p + 1 +...
                (1/3) * p.^2 .* (-3*p.^3 + 3*p.^2 + 6*p + 1);
            f0(1) = 0;

            colors = linspecer(5);
            greyColor = [0.8,0.8,0.8];
            markers = ['o', 's', '^', 'p', '+'];
            figure;            
            plot(p, f1/2,  '-', 'Color', colors(1, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(1),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                    1:2:length(p));
            hold on;
            plot(p, f2/2,  '-', 'Color', colors(2, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(2),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                    1:2:length(p));
            plot(p, f3/2,  '-', 'Color', colors(3, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(3),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                    1:2:length(p));
            plot(p, f5/3,  '-', 'Color', colors(4, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(4),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                    1:2:length(p));
            plot(p, f0,  '--', 'Color', greyColor,...
                'LineWidth', obj.linewidth);
            
            xticks(0:0.05:0.5);
            xticklabels(0:0.05:0.5);
            
            hold off;
            xlabel('P');            
            ylabel('Entropy (bits)');
            ylim([0 1.4]);
            yticks(0:0.2:1.4);
            yticklabels(0:0.2:1.4);
            grid on;
            myLegend = legend('Method I', 'Method II', 'Method III',...
                'Method IV', 'H');
            myLegend.Location = 'southeast';
            box off;
            legend boxoff;
            set( gca,'FontSize', obj.fontsize,...
                'LineWidth', obj.linewidth/2,...
                'GridAlpha', 0.07,...
                'GridLineStyle', ':' ); 
            
        end % function plotTheoric
        
        function methodIV_performance(obj)
            
             p =  0:0.0125:0.5;
             groupMax = 4;
             results = zeros(groupMax+1, length(p));  
             colors = linspecer(groupMax+1);
             f0 = -1*(p.*log2(p) + (1-p).*log2(1-p));
             f0(1) = 0;            
             results(end, :) = f0;
             greyColor = [0.8,0.8,0.8];
             groups = [1, 2, 4, 8];
             
             parfor i = 1:length(p)
                 samples = generateBinaryString(obj, obj.population, p(i));
             
                 for group = 1:groupMax
                     method4 = Method_IV();
                     method4 = setParameter(method4, samples, groups(group));
                     method4 = setProbability(method4, p(i));
                     method4 = testAll(method4);
                     results(group, i ) = ...
                         sum(method4.testsCount) / obj.population;
                 end % for group
        
             end % for i
             
             markers = ['o', 's', '^', 'p', 'h'];
             figure;
             
             for i = 1:groupMax
                 plot(p, results(i, :),  '-', 'Color', colors(i, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(i),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                1:2:length(p)); 
                hold on;
             end % for i
             
             plot(p, results(end, :),  '--', 'Color', greyColor,...
                'LineWidth', obj.linewidth);
             
            xticks(0:0.05:0.5);
            xticklabels(0:0.05:0.5);            
            ylim([0 1.4]);
            yticks(0:0.2:1.4);
            yticklabels(0:0.2:1.4);
            hold off;
            xlabel('P');            
            ylabel('Entropy (bits)');
            grid on;
            myLegend = legend('Method IV (m=1)', ...
                'Method IV (m=2)', 'Method IV (m=4)',...
                'Method IV (m=8)', 'H');
            myLegend.Location = 'southeast';
            box off;
            legend boxoff;
            set( gca,'FontSize', obj.fontsize,...
                'LineWidth', obj.linewidth/2,...
                'GridAlpha', 0.07,...
                'GridLineStyle', ':' );        
        end % function methodIV_performance
        
        function performanceWithGroupsize(obj)
            p =  0:0.0125:0.5;            
            f0 = -1*(p.*log2(p) + (1-p).*log2(1-p));
            f0(1) = 0;
            results = zeros(4, 4, length(p));
            bestOnes = zeros(4, length(p));
            groupsizes = [1, 2, 4, 8];
            groupsizesV = [1, 6, 12, 24];
            greyColor = [0.8,0.8,0.8];
            
            for groupSize = 1:length(groupsizes)                
                 s = groupsizes(groupSize);
                 sV = groupsizesV(groupSize);
                 
                for i = 1:length(p)
                    samples = generateBinaryString(obj, obj.population, p(i));
                    newPopulation = 3 * obj.population / 4;
                    samplesV = samples(1:newPopulation);
                    
                    method1 = Method_I();
                    method1 = setParameter(method1, samples, s);
                    method1 = testAll(method1);

                    method2 = Method_II();
                    method2 = setParameter(method2, samples, s);
                    method2 = testAll(method2);

                    method3 = Method_III();
                    method3 = setParameter(method3, samples, s);
                    method3 = testAll(method3);  
                    
                    method5 = Method_V();                
                    method5 = setParameter(method5, samplesV, sV);
                    method5 = testAll(method5);

                    results(1, groupSize, i) = sum(method1.testsCount) / obj.population;
                    results(2, groupSize, i) = sum(method2.testsCount) / obj.population;
                    results(3, groupSize, i) = sum(method3.testsCount) / obj.population;
                    results(4, groupSize, i) = sum(method5.testsCount) / newPopulation;
                    bestOnes(1, i) = min(squeeze(results(1, :, i)));
                    bestOnes(2, i) = min(squeeze(results(2, :, i)));
                    bestOnes(3, i) = min(squeeze(results(3, :, i)));
                    bestOnes(4, i) = min(squeeze(results(4, :, i)));
                end % for i
                
            end % for groupSize
            
            colors = linspecer(5);
            colors2 = linspecer(4);
            markers = ['o', 's', '^', 'p', '+']; 
                       
            for k = 1:4
                figure;
                
                for i = 1:4
                    plot(p, squeeze(results(k, i, :)),...
                        '-', 'Color', colors2(i, :),...
                        'LineWidth', obj.linewidth, 'Marker', markers(i),...
                        'MarkerSize', obj.markersize, 'MarkerIndices',...
                        1:2:length(p));
                    hold on;
                end % for i
                                  
                plot(p, f0, '--', 'Color', greyColor, ... 
                    'LineWidth', obj.linewidth );

                hold off;
                xlabel('P');            
                ylabel('Entropy (bits)');
                xticks(0:0.05:0.5);
                xticklabels(0:0.05:0.5);
                ylim([0 1.4]);
                yticks(0:0.2:1.4);
                yticklabels(0:0.2:1.4);
                grid on;
                
                if k == 1
                    myLegend = legend('Method I (m=1)', ...
                        'Method I (m=2)', 'Method I (m=4)',...
                        'Method I (m=8)', 'H');
                elseif (k == 2)
                    myLegend = legend('Method II (m=1)', ...
                        'Method II (m=2)', 'Method II (m=4)',...
                        'Method II (m=8)', 'H');
                elseif (k == 3)
                    myLegend = legend('Method III (m=1)', ...
                        'Method III (m=2)', 'Method III (m=4)',...
                        'Method III (m=8)', 'H');
                else 
                    myLegend = legend('Method IV (m=1)', ...
                        'Method IV (m=6)', 'Method IV (m=12)',...
                        'Method IV (m=24)', 'H');
                end % if k
                
                myLegend.Location = 'southeast';
                box off;
                legend boxoff;
                set( gca,'FontSize', obj.fontsize,...
                    'LineWidth', obj.linewidth/2,...
                    'GridAlpha', 0.07,...
                    'GridLineStyle', ':' ); 
            end % for k
            
            figure;
            for j = 1:4
                plot(p, squeeze(bestOnes(j, :)),...
                        '-', 'Color', colors2(j, :),...
                        'LineWidth', obj.linewidth, 'Marker', markers(j),...
                        'MarkerSize', obj.markersize, 'MarkerIndices',...
                        1:2:length(p));
                    hold on;
            end % for j
               
            plot(p, f0, '--', 'Color', greyColor, ... 
                    'LineWidth', obj.linewidth );

            hold off;
            xlabel('P');            
            ylabel('Entropy (bits)');
            xticks(0:0.05:0.5);
            xticklabels(0:0.05:0.5);
            ylim([0 1.4]);
            yticks(0:0.2:1.4);
            yticklabels(0:0.2:1.4);
            grid on;
            myLegend = legend('Method I', 'Method II',...
                'Method III', 'Method IV', 'H');
            myLegend.Location = 'southeast';            
            box off;
            legend boxoff;
            set( gca,'FontSize', obj.fontsize,...
                'LineWidth', obj.linewidth/2,...
                'GridAlpha', 0.07,...
                'GridLineStyle', ':' );
            
            figure;
            plot(p, min(bestOnes, [], 1),...
                '-', 'Color', colors2(1, :),...
                'LineWidth', obj.linewidth, 'Marker', markers(1),...
                'MarkerSize', obj.markersize, 'MarkerIndices',...
                1:2:length(p));
            hold on;

            plot(p, f0, '--', 'Color', greyColor, ... 
                    'LineWidth', obj.linewidth );

            hold off;
            xlabel('P');            
            ylabel('Entropy (bits)');
            xticks(0:0.05:0.5);
            xticklabels(0:0.05:0.5);
            ylim([0 1.4]);
            yticks(0:0.2:1.4);
            yticklabels(0:0.2:1.4);
            grid on;
            myLegend = legend('Best Method', 'H');
            myLegend.Location = 'southeast';            
            box off;
            legend boxoff;
            set( gca,'FontSize', obj.fontsize,...
                'LineWidth', obj.linewidth/2,...
                'GridAlpha', 0.07,...
                'GridLineStyle', ':' );
        end % function performanceWithGroupsize
        
        % Generate a binary string of size n with
        % probability of 1 being p
        function randomString = generateBinaryString(obj, n, p)
            randomString = rand(1, n);
            randomString = (randomString <= p);
        end % function generateBinaryString
        
    end % class public services
    
end % class FigureGenerator
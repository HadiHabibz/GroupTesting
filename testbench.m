%% Hyperparameters
% population size
n = 9 * 5 * 7 * 1024;
n2 = 3*128*1024;

% probability of test being positive
p = 0.05;

% The number of samples that are mixed
groupSize = 2;

%% Simulate
% randomPopulation = generateBinaryString(n, p);
% randomPopulation2 = generateBinaryString(n2, p);
% 
% method1 = Method_I();
% method1 = setParameter(method1, randomPopulation, groupSize);
% method1 = testAll(method1);
% 
% method2 = Method_II();
% method2 = setParameter(method2, randomPopulation, groupSize);
% method2 = testAll(method2);
% 
% method3 = Method_III();
% method3 = setParameter(method3, randomPopulation, groupSize);
% method3 = testAll(method3);
% 
% method4 = Method_IV();
% method4 = setParameter(method4, randomPopulation, 10);
% method4 = setProbability(method4, p);
% method4 = testAll(method4);
% 
% method5 = Method_V();
% method5 = setParameter(method5, randomPopulation2, 3);
% method5 = testAll(method5);

%% PRINT RESULTS
% fprintf("Method 1: %0.2f\n", sum(method1.testsCount) / n);
% fprintf("Method 2: %0.2f\n", sum(method2.testsCount) / n);
% fprintf("Method 3: %0.2f\n", sum(method3.testsCount) / n);
% fprintf("Method 4: %0.2f\n", sum(method4.testsCount) / n);
% fprintf("Method 5: %0.2f\n", sum(method5.testsCount) / n2);

% figureGenerator = FigureGenerator();
% generate_bitrate(figureGenerator, 2); 
% plotTheoric(figureGenerator);
% methodIV_performance(figureGenerator);
performanceWithGroupsize(figureGenerator);
% 
% p = 0:0.0001:0.5;
% q = 1 - p;
% f0 = -2*(p.*log2(p) + q.*log2(q));
% f1 = -2*p.^2 + 4*p + 1;
% f2 = -p.^2 + 3*p + 1;
% f3 = -0.5 * (p.^3 - p.^2 - 5*p - 2);
% 
% figure;
% plot(p, f0, '-b', 'LineWidth', 2);
% hold on;
% plot(p, f1, '-g', 'LineWidth', 2);
% hold on;
% plot(p, f2, '-c', 'LineWidth', 2);
% hold on;
% plot(p, f3, '-r', 'LineWidth', 2);
%% 
% Generate a binary string of size n with
% probability of 1 being p
function randomString = generateBinaryString(n, p)
    randomString = rand(1, n);
    randomString = (randomString <= p);
end % function generateBinaryString
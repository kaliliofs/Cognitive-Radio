% Here we calculate the threhsold in energy detection by simulations. 
% This is a general method and applicable to all scenarios for energy detection.
% We assume that all the signals are complex Gaussian.
% Algorithm:
% 1. Assume onlt noise is received, i.e., primary user is absent.
% 2. If the only noise energy lies above the threhsold, it corresponds to
% false alarm.
% 3. Run this scenario for some number of iteration.
% 4. Probability of False Alarm = energy above threshold/No. of Iteration.
% Code written by: Sanket Kalamkar, Indian Institute of Technology Kanpur,
% India.

clc
close all
clear all
L = 1000; % Number of samples to be taken
iter = 1000; % Number of iterations
Pf = 0.01:0.01:1; % Probability of False Alarm
for tt = 1:length(Pf)
    tt
for kk=1:iter % Number of Monte Carlo Simulations

 n=(randn(1,L)+j*randn(1,L))./(sqrt(2)); % Primary User Gaussian Signal

 y = n; % Received signal at the secondary user
 energy = abs(y).^2; % Energy of received signal over L samples
 energy_fin(kk) =(1/L).*sum(energy); % Test Statistic of the energy detection

end
 energy_desc = sort(energy_fin,'descend'); % Arrange values in descending order
 thresh(tt) = energy_desc(ceil(Pf(tt)*iter)); % Threshold obtained by simulations; the first 'Pf' fraction of values lie above the threshold
end
plot(thresh, Pf)
hold on

%%
thresh1 = (qfuncinv(Pf)./sqrt(L))+ 1; % Theroretical value of threshold
plot(thresh1, Pf, 'r')
hold on




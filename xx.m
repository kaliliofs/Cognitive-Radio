clear all;
close all;
clc


u=1000;%time bandwidth factor
N=2*u;%samples
a=2;%path loss exponent
C=2;%constant losses
Crs=10; %Number of cognitive radio users
PdAnd=0;
%----------Pfa------------%
Pf=0.01:0.01:1;
Pfa=Pf.^2;
%---------signal-----%
t=1:N;
s1 = cos(pi*t);
stem(t,s1)
s1power=var(s1);


%-------- SNR ----------%
% Snrdb=-15:1:15;
Snrdb=15;
Snreal=power(10,Snrdb/10);%Linear Snr

% while Snrdb<15%
  lamda=ones(1,100);
for i=1:length(Pfa)
lamda(i)=gammaincinv(1-Pfa(i),u)*2; %theshold
% lamdadB=10*log10(lamda);
%--------Local spectrum sensing---------%
d=ones(1,10);
for j=1:Crs %for each node
detect=0;
d(j)=7+1.1*rand(); %random distanse
PL=C*(d(j)^-a); %path loss

for sim=1:10%Monte Carlo Simulation for 100 noise realisation

%-------------AWGN channel--------------------%
noise = randn(1,N); %Noise production with zero mean and s^2 var
noise_power = mean(noise.^2); %noise average power
amp = sqrt(noise.^2*Snreal);
s1=amp.*s1./abs(s1);
% SNRdB_Sample=10*log10(s1.^2./(noise.^2));
Rec_signal=s1+noise;%received signal
localSNR=ones(1,10);
localSNR(j)=mean(abs(s1).^2)*PL/noise_power;%local snr
pdth=cell(10,100);
pdth{1,100}=1:100;
pdth{10,10}='string';
Pdth(j,i)=marcumq(sqrt(2*localSNR(j)),sqrt(lamda(i )),u);%Pd for j node

%Computation of Test statistic for energy detection
Sum=abs(Rec_signal).^2*PL;
Test=ones(1,10);
Test(j,sim)=sum(Sum)
if (Test(j,sim)>lamda(i))
detect=detect+1;
end
end %END Monte Carlo
Pdsim=ones(1,10);
Pdsim(j)=detect/sim; %Pd of simulation for the j-th CRuser
end
PdAND=ones(1,100);
PdAND(i)=prod(Pdsim);
PdOR=ones(1,100);
PdOR(i)=1-prod(1-Pdsim);

end
PdAND5=(Pdth(5,:)).^5;
Pmd5=1-PdAND5;
PdANDth=(Pdth(Crs,:)).^Crs;
PmdANDth=1-PdANDth; %Probability of miss detection
Pmdsim=1-PdAND;
figure(2);
plot(Pfa,Pmdsim,'r-*',Pfa,PmdANDth,'k-o',Pfa,Pmd5,'g-*');
title('Complementary ROC of Cooperative sensing with AND rule under AWGN');
grid on
axis([0.0001,1,0.0001,1]);
xlabel('Probability of False alarm (Pfa)');
ylabel('Probability of Missed Detection (Pmd)');
legend('Simulation','Theory n=10','Theory n=5');
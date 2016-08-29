function [tfr]=tfrcwtbcpuTest(X,fmin,fmax,N, SR, b0) 
% X: Signal in Time as a column vector
% fmin & fmax: min and max Non-normalised frequencies for analysis
% N: number of linearly spaced frquencies between fmin and fmax
% tfr: complex coefficients of continuous wavelet tranform coefficients for
% all the frequncies specified and at all time points of X
% f: The frequencies
% b0: b0 is a paramter that determines how many sine oscillations fit into
% the gaussian, before suppression. Default: b0=1 was used. 
% Example: to calculate the CWT for this signals:
% t=0:0.01:5;
% X=sin(2.*pi.*5.*t).';
% we have SR=100. if we want to find coefficients from 1Hz (fmin=1/SR=1/100=0.01) to 50 Hz (fmax=50/SR=50/100=0.5) at each frequency (50 frequency bins=N) we can write:
% [tfr]=tfrcwtb(X,0.01,0.5,50, 100)
% tfr is the complex CWT coefficints to get the WL moduli we can use
% abs(tfr).^2

TS=1./SR;
z = hilbert((X - mean(X))');
NT=length(z);
f = linspace(fmin,fmax,N).';

for fi=f.'
    q=ceil(4./fi);
    t=(-q:TS:q);
    w=sqrt(fi/(2*pi)).*exp(-0.5.*b0.*(fi.*t).^2+1j.*2.*pi.*fi.*t);
    tfr(fi,1:NT)=(TS).*conv(z,w,'same');
end


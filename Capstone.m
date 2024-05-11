%Choice of waves(Sinusoidal,Square,Sinc,Triangular)
%Sinusoidal part
clc;
clear all;
close all;
Main();
function Main
function y = SINUSOID(A,f,t)
    y=A*cos(2*pi*f*t);    
end

function mod = DSBAM(miu,Ac,fm,fc,t)
    mod=Ac*(1+miu*cos(2*pi*fm*t)).*cos(2*pi*fc*t);
end
   
function mod = DSBSC(m,c)
    mod=m.*c;
end

function mod = SSBSC(m,Ac,fc,t,mode)
    if mode=="UPPER"
        mod= (Ac/2)*cos(2*pi*fc*t).*m - (Ac/2)*sin(2*pi*fc*t).*(imag(hilbert(m)));
    else    
        mod= (Ac/2)*cos(2*pi*fc*t).*m + (Ac/2)*sin(2*pi*fc*t).*(imag(hilbert(m)));
    end    
end

function demod= DEMODULATION(mod,c)
    demod=mod.*c;
end 

function demod_filtered = DEMODULATIONFILTER(demod,o,cut,Ac)
    [b,a] = butter(o,cut);
    demod_filtered=filter(b,a,demod)*2;
end   

function  f = FREQUENCY_DOMAIN(mod,fs)
    n=length(mod);
    f=-fs/2:fs/n:(fs/2-fs/n);
end

function X = FAST_FOURIER(mod)  
    X=fftshift(abs(fft(mod)));
end

Ac=input("Enter the amplitude of your carrier signal:");
fc=input("Enter the carrier signal frequency:");
start_time=input("Enter the start time:");
step_size=input("Enter the step size:");
stop_time=input("Enter the stop time:");
t=start_time:step_size:stop_time;
fs=1/step_size;
Am=input("Enter the amplitude of your message signal:");
fm=input("Enter the message signal frequency:");
choice=input("Enter your choice of amplitude modulation(DSBAM/DSBSC/SSBSC):",'s');
c=SINUSOID(Ac,fc,t);
m=SINUSOID(Am,fm,t);

if choice=="DSBAM"
    miu=Am/Ac;
    mod=DSBAM(miu,Ac,fm,fc,t);
elseif choice=="DSBSC"
    mod=DSBSC(m,c);
else
    mode=input("Enter your preferred mode of Sideband(UPPER/LOWER):","s");
    mod=SSBSC(m,Ac,fc,t,mode);
end
o=input("Enter the order of the Butterworth LPF:");
cut=(fc+10)/(fs/2);
demod= DEMODULATION(mod,c);
demod_filtered=DEMODULATIONFILTER(demod,o,cut,Ac);
f=FREQUENCY_DOMAIN(mod,fs);
mod_freqdomain=FAST_FOURIER(mod);

subplot(5,1,1)
plot(t,m)
title("Message Signal")
xlabel('Time')
ylabel('Amplitude')
grid on

subplot(5,1,2)
plot(t,c)
title("Carrier Signal")
xlabel('Time')
ylabel('Amplitude')
grid on

subplot(5,1,3)
plot(t,mod)
title("Modulated Signal")
xlabel('Time')
ylabel('Amplitude')
grid on

subplot(5,1,4)
plot(t,demod_filtered)
title("Demodulated Signal")
xlabel('Time')
ylabel('Amplitude')
grid on

subplot(5,1,5)
plot(f,mod_freqdomain)
title("Frequency Domain Modulated Signal")
xlabel('Frequency')
ylabel('Amplitude')
grid on
end



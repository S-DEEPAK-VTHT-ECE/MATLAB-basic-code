% Prompt for User input
b4_in = input('Insert 4-bit input: ' ,'s');
% Get the number of input digit
n_c=length(b4_in);
k = log2(n_c); % Number of bits per symbol
n = 30000;   % Number of bits to process
sps = 1;     % Number of samples per symbol (oversampling factor)
% Check the number of input digit
if(n_c < 4)
   disp([num2str(n_c) ': Not enough input digit. 4 digits are required'])
elseif(n_c > 4)
   disp([num2str(n_c) ': Too many input digit. 4 digits are required'])
else
   
      % Valid input: 4 digit, only "0" or "1"
      disp([b4_in ' Valid input'])
end

rng default;
dataIn = randi([0 1],n,1);
stem(dataIn(1:40),'filled');
figure(1);
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
figure(2);
dataSymbolsIn = int8(dataIn);
stem(dataSymbolsIn(1:10));
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');
[y,M1]=idft(dataIn,b4_in,n_c);
figure(3);
[f,Axk,Ayk]=noise(y);
d=length(f);
N=length(y);
a=length(Axk(1:N/2+1));
subplot(2,1,2); plot(f,Axk(1:N/2+1));
xlabel('Frequency (Hz)'); ylabel('Amplitude |X(f)|');grid;
subplot(2,1,1); plot(f,Axk(1:N/2+1));
xlabel('Frequency (Hz)'); ylabel('Amplitude |X(f)|');grid;
subplot(2,1,2);plot(f,Ayk(1:N/2+1)); 
xlabel('Frequency (Hz)'); ylabel('Amplitude |Y(f)|');grid;
[y,Et,Et_approx]=LinearWaveProp(d,a);
figure(5);
plot(y,abs(Et),'b')
hold on
plot(y,abs(Et_approx),'r')
axis([-50 50 0 1.2]);
set(gca,'XTick',[-50:10:50])
title('{\bfInterference pattern}','FontSize',14)
xlabel('{\bfDistance from the centre of screen (in cm)}')
ylabel('{\bfRelative Intensity}')
line([0 0],[0 1.2])
legend('Actual intensity','Approximated intensity','y-axis')
t=y;
x=abs(Et)+abs(Et_approx);
figure(6);
subplot(2,2,1);
plot(t,x);
title('Original signal');
xlabel('Time');
ylabel('Amplitude');
n=rand(1,length(t));
x=x+n;
subplot(2,2,2);
plot(t,x);
title('Noise corrupted signal');
xlabel('Time');
ylabel('Amplitude');
g=fft(x);
subplot(2,2,3);
plot(abs(g));
title('Magnitude part of fft');
f=find(abs(g)<50);
g(f)=zeros(size(f));
w=ifft(g);
subplot(2,2,4);
plot(w);
title('Signal after noise removal');
xlabel('Time');
ylabel('Amplitude');
x_QAM_demodeulated = QAM_demodulation(y,w );
M=16;
fft_size = 1024;
Eb_No = -20:3:20;
Eb = 2*(M-1)/(3*log2(M)); 
No_vect = Eb./(10.^(Eb_No/10));
Pe_vect = zeros(1,length(Eb_No));
frames_num = 25;
N_bits = 2336; 
ofdm_synbols_per_frame = 25;
channel_type = "AWGN";
 L = 1;
 h1 = 1;
 h2 = 1;
for i = 1:length(Eb_No)
  Pe_avg_frames_per_frame = 0;
  
  for k = 1:frames_num
count_err_per_ofdm_symbol = 0;
    count_err_per_frame = 0;
    for j = 1:ofdm_synbols_per_frame
        % Generate seq
        x = randi([0 1],1,N_bits);
        
        % Tx (Channel encoding, QAM modulation, OFDM)
        [y_Tx1, y_Tx2, x_QAM_modulated] = Tx(x, M, N_bits, L, No_vect(i), h1, h2, fft_size);
        
        % Rx (OFDM, QAM demodulation, Channel decoding)
        [x_Rx, x_before_demodulation] = Rx(M, L, y_Tx1, y_Tx2, x_QAM_modulated, h1, h2, fft_size);
        
        % Calc BER
        count_err_per_ofdm_symbol = biterr(x,x_Rx);

        % Average BER per run
        count_err_per_frame = count_err_per_frame + count_err_per_ofdm_symbol;
        
    end
    
    Pe_avg_frames_per_frame = Pe_avg_frames_per_frame + count_err_per_frame/(N_bits*ofdm_synbols_per_frame);
  end

  Pe_vect(i) = Pe_avg_frames_per_frame;

  % Plot the constellation diagram for each SNR 
%   scatterplot(x_before_demodulation);
%   title('Constellation Diagram'); 

end
%% plot
figure(7);
semilogy(Eb_No,Pe_vect);
title('BER vs Eb/No ' + channel_type + ' for ' + M + ' QAM');

xlabel('Eb/No (dB)');
ylabel('BER (dB)');


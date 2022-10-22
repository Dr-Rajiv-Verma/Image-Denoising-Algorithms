clear; clc; close all;
%% Author Details
%>>>>>>>>>>   Written by Rajiv Verma <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>>>>>>>> National Institute of Technology, Kurukshetra, India  <<<<<<<<

%%...................... Original Image ..................................%
path = 'C:\Users\RAS\Desktop\standard images\';
formatt = '*.png';              FILE = uigetfile(fullfile(path , formatt));
I = im2double(imread([path FILE]));
if(size(I,3) == 3)
    I = rgb2gray(I);
end

%% Noise generation
Sigma = input('Enter noise level (sigma) :: ');                            % Noise level [10-20-30-40-50]
Sigma = Sigma/255;

%% Noisy Image
J = I + (randn(size(I)).*Sigma);                                           % noisy image

%% NLM filter- Prefiltering process
ssize = 21;                                                                % search region
ksize = 7;                                                                 % patch size
h = 0.75*Sigma;                                                       % smoothing parameter
DNLM = zeros(size(I));                                                     % Denoise image by NLM filter
[DNLM] = NLM_FILTER(J,Sigma,h);                                              % NLM filter algorithm
PSNR_PREFILTER = psnr(I,DNLM);                                             % PSNR calculation
fprintf('PSNR of Prefiltered Image = %2.4f\n',PSNR_PREFILTER);

%% Gray Level difference computation
GLD = zeros(size(I));
psize = 7;                                                                 % patch size for computing gray level difference
MF = fspecial('average',[psize,psize]);                                    % averege filter
GImg = imfilter(DNLM,MF,'replicate');                                      % Gray level Difference image
GLD = abs(DNLM - GImg);                                                    % GLD image

%% Thresholding the GLD image
% mean and standrad deviation of an Gray level difference image
alpha=0.4;
mni = mean2(GLD);
sdi = std2(GLD);
thr = mni+(alpha*sdi);

%% segmenting image
GLDD = GLD(:);
SWmap = zeros(size(J));
a1 = find(GLDD <= mni);
SWmap(a1) = 21; 
a2 = find(GLDD > mni & GLDD < thr);
SWmap(a2)=15;
a3=find(GLDD >= thr);
SWmap(a3)=9;

%% Adaptive NLM
[DImg]=Adaptive_NLM(J,SWmap,ksize,Sigma);
PSNR_Pro = psnr(I,DImg);
fprintf('PSNR of Proposed Algorithm = %2.4f\n',PSNR_Pro);

figure(1), subplot(231),imshow(I), title('Clean');
subplot(232), imshow(J), title('noisy');
subplot(233), imshow(DNLM), title('Prefiltered');
subplot(234), imshow(GLD), title('GLD image')
subplot(235), imshow(SWmap/21), title('search window map')
subplot(236), imshow(DImg), title('Proposed')



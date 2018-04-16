tic

clear all
I = imread('Lena.png');
original_info = imfinfo('Lena.png');
original_FileSize = original_info.FileSize; % getting original image size
figure;
imshow(I);
title('original image');
R = I(:,:,1); 
G = I(:,:,2); 
B = I(:,:,3);

Cb = B - round((87/256)*R +(169/256)*G);
Cr = R - G;
Y = G + round((86/256)*Cr + (29/256)*Cb);

figure
imshow(Y);
title('original Y channel');

figure
imshow(Cb);
title('original Cb channel');

figure
imshow(Cr);
title('original Cr channel');

imwrite(Y, 'Lena_Y1.png');    % saving red channel for lossless compression at compressor.io

%% coding Cb and Cr channels 1st row by row Xe and Xo decomposition

Cbo = Cb(2:2:end,:);
Cbe = Cb(1:2:end,:);

Cro = Cr(2:2:end,:);
Cre = Cr(1:2:end,:);

%predictions for Cb

mCbo = size(Cbo,1);
nCbo = size(Cbo,2);

Cbh_predict = zeros(mCbo,nCbo);

for i = 1:mCbo
    for j = 2:nCbo
        Cbh_predict(i,j) = Cbo(i,j-1);
    end
end

mCbe = size(Cbe,1);
nCbe = size(Cbe,2);

Cbv_predict = zeros(mCbe,nCbe);

for i = 1:mCbe-1
    for j = 1:nCbe
        Cbv_predict(i,j) = round((Cbe(i,j) + Cbe(i+1,j))/2);
    end
end

%predictions for Cr

mCro = size(Cro,1);
nCro = size(Cro,2);

Crh_predict = zeros(mCro,nCro);

for i = 1:mCro
    for j = 2:nCro
        Crh_predict(i,j) = Cro(i,j-1);
    end
end

mCre = size(Cre,1);
nCre = size(Cre,2);

Crv_predict = zeros(mCre,nCre);

for i = 1:mCre-1
    for j = 1:nCre
        Crv_predict(i,j) = round((Cre(i,j) + Cre(i+1,j))/2);
    end
end

%calculation of dir Cb

Cbdir = [];

for i = 1:mCbo
    for j = 1:nCbo
        if abs(Cbo(i,j) - Cbh_predict(i,j)) + 3 < abs(Cbo(i,j) - Cbv_predict(i,j))
            Cbdir(i,j) = 'H';
        else
            Cbdir(i,j) = 'V';
        end
    end
end

Cbdir = char(Cbdir);

%calculation of dir Cr

Crdir = [];

for i = 1:mCro
    for j = 1:nCro
        if abs(Cro(i,j) - Crh_predict(i,j)) + 3 < abs(Cro(i,j) - Crv_predict(i,j))
            Crdir(i,j) = 'H';
        else
            Crdir(i,j) = 'V';
        end
    end
end

Crdir = char(Crdir);

%calculation of predicted x0 Cb

Cbo_hat = zeros(mCbo, nCbo);

for i = 2:mCbo
    for j = 2:nCbo
        if Cbdir(i-1,j) == 'H' || Cbdir(i,j-1) == 'H'
            Cbdir(i,j) = dir_calculator(Cbo(i,j),Cbh_predict(i,j),Cbv_predict(i,j));
            %encode Cbdir
            if Cbdir(i,j) == 'H'
                Cbo_hat(i,j) = Cbh_predict(i,j);
            else
                Cbo_hat(i,j) = Cbv_predict(i,j);
            end
        else
            Cbo_hat(i,j) = Cbv_predict(i,j);
            Cbdir(i,j) = dir_calculator(Cbo_hat(i,j),Cbh_predict(i,j),Cbv_predict(i,j));
        end
    end
end

%calculation of predicted x0 Cr

Cro_hat = zeros(mCro, nCro);

for i = 2:mCro
    for j = 2:nCro
        if Crdir(i-1,j) == 'H' || Crdir(i,j-1) == 'H'
            Crdir(i,j) = dir_calculator(Cro(i,j),Crh_predict(i,j),Crv_predict(i,j));
            %encode Crdir
            if Crdir(i,j) == 'H'
                Cro_hat(i,j) = Crh_predict(i,j);
            else
                Cro_hat(i,j) = Crv_predict(i,j);
            end
        else
            Cro_hat(i,j) = Crv_predict(i,j);
            Crdir(i,j) = dir_calculator(Cro_hat(i,j),Crh_predict(i,j),Crv_predict(i,j));
        end
    end
end

%% 2nd decomposition of Xe

sCbo = Cbe(:,2:2:end);
sCbe = Cbe(:,1:2:end);

sCro = Cre(:,2:2:end);
sCre = Cre(:,1:2:end);

%predictions for Cb

smCbo = size(sCbo,1);
snCbo = size(sCbo,2);

sCbh_predict = zeros(smCbo,snCbo);

for i = 1:smCbo
    for j = 2:snCbo
        sCbh_predict(i,j) = sCbo(i,j-1);
    end
end

smCbe = size(sCbe,1);
snCbe = size(sCbe,2);

sCbv_predict = zeros(smCbe,snCbe);

for i = 1:smCbe-1
    for j = 1:snCbe
        sCbv_predict(i,j) = round((sCbe(i,j) + sCbe(i+1,j))/2);
    end
end

%predictions for Cr

smCro = size(sCro,1);
snCro = size(sCro,2);

sCrh_predict = zeros(smCro,snCro);

for i = 1:smCro
    for j = 2:snCro
        sCrh_predict(i,j) = sCro(i,j-1);
    end
end

smCre = size(sCre,1);
snCre = size(sCre,2);

sCrv_predict = zeros(smCre,snCre);

for i = 1:smCre-1
    for j = 1:snCre
        sCrv_predict(i,j) = round((sCre(i,j) + sCre(i+1,j))/2);
    end
end

%calculation of dir Cb

sCbdir = [];

for i = 1:smCbo
    for j = 1:snCbo
        if abs(sCbo(i,j) - sCbh_predict(i,j)) + 3 < abs(sCbo(i,j) - sCbv_predict(i,j))
            sCbdir(i,j) = 'H';
        else
            sCbdir(i,j) = 'V';
        end
    end
end

sCbdir = char(sCbdir);

%calculation of dir Cr

sCrdir = [];

for i = 1:smCro
    for j = 1:snCro
        if abs(sCro(i,j) - sCrh_predict(i,j)) + 3 < abs(sCro(i,j) - sCrv_predict(i,j))
            sCrdir(i,j) = 'H';
        else
            sCrdir(i,j) = 'V';
        end
    end
end

sCrdir = char(sCrdir);

%calculation of predicted x0 Cb

sCbo_hat = zeros(smCbo, snCbo);

for i = 2:smCbo
    for j = 2:snCbo
        if sCbdir(i-1,j) == 'H' || sCbdir(i,j-1) == 'H'
            sCbdir(i,j) = dir_calculator(sCbo(i,j),sCbh_predict(i,j),sCbv_predict(i,j));
            %encode Cbdir
            if sCbdir(i,j) == 'H'
                sCbo_hat(i,j) = sCbh_predict(i,j);
            else
                sCbo_hat(i,j) = sCbv_predict(i,j);
            end
        else
            sCbo_hat(i,j) = sCbv_predict(i,j);
            sCbdir(i,j) = dir_calculator(sCbo_hat(i,j),sCbh_predict(i,j),sCbv_predict(i,j));
        end
    end
end

%calculation of predicted x0 Cr

sCro_hat = zeros(smCro, snCro);

for i = 2:smCro
    for j = 2:snCro
        if sCrdir(i-1,j) == 'H' || sCrdir(i,j-1) == 'H'
            sCrdir(i,j) = dir_calculator(sCro(i,j),sCrh_predict(i,j),sCrv_predict(i,j));
            %encode Crdir
            if sCrdir(i,j) == 'H'
                sCro_hat(i,j) = sCrh_predict(i,j);
            else
                sCro_hat(i,j) = sCrv_predict(i,j);
            end
        else
            sCro_hat(i,j) = sCrv_predict(i,j);
            sCrdir(i,j) = dir_calculator(sCro_hat(i,j),sCrh_predict(i,j),sCrv_predict(i,j));
        end
    end
end

%% calculating the prediction error

%calculating prediction error for Cb 1st decomposition

errCb = double(Cbo) - Cbo_hat;

for i = 1:size(errCb,1)-1
    for j = 1:size(errCb,2)
        sigmaCb(i,j) = abs(Cre(i,j) - Cre(i+1,j));
    end
end

q = quantizer([6 0], 'fixed');
sigma_Cb_quant = quantize(q, sigmaCb);

%calculating prediction error for Cr 1st decomposition

errCr = double(Cro) - Cro_hat;

for i = 1:size(errCr,1)-1
    for j = 1:size(errCr,2)
        sigmaCr(i,j) = abs(Cre(i,j) - Cre(i+1,j));
    end
end

q = quantizer([6 0], 'fixed');
sigma_Cr_quant = quantize(q, sigmaCr);

%calculating prediction error for Cb 2nd decomposition

serrCb = double(sCbo) - sCbo_hat;

for i = 1:size(serrCb,1)-1
    for j = 1:size(serrCb,2)
        sigmasCb(i,j) = abs(sCre(i,j) - sCre(i+1,j));
    end
end

q = quantizer([6 0], 'fixed');
sigma_sCb_quant = quantize(q, sigmasCb);

%calculating prediction error for Cr 2nd decomposition

serrCr = double(sCro) - sCro_hat;

for i = 1:size(serrCr,1)-1
    for j = 1:size(serrCr,2)
        sigmasCr(i,j) = abs(sCre(i,j) - sCre(i+1,j));
    end
end

q = quantizer([6 0], 'fixed');
sigma_sCr_quant = quantize(q, sigmasCr);

%% displaying compressed image and calculating number of bits per pixel, the compression ratio, MSE, PSNR and SSIM

%getting the compressed image

figure;
imshow('Lena_Y1-compressor.png');   % display compressed Y channel
title('compressed Y channel');

%getting Cb channel

tempCb = horzcat(sCbe, sCbo_hat);
temp2Cb = vertcat(tempCb, Cbo);

figure;
imshow(temp2Cb);    % display compressed Cb channel
title('compressed Cb channel');

%getting Cr channel

tempCr = horzcat(sCre, sCro_hat);
temp2Cr = vertcat(tempCr, Cro); % display compressed Cr channel 

figure;
imshow(temp2Cr);
title('compressed Cr channel');

just_Y_compressed = imread('Lena_Y1-compressor.png'); % loading the compressed (using compressor.io) Y channel from the working directory

G1 = just_Y_compressed - round((86/256)*Cr + (29/256)*Cb);
R1 = Cr + G1;
B1 = Cb + round((87/256)*R1 +(169/256)*G1);

compressed_image = cat(3, R1, G1, B1);
figure;
imshow(compressed_image);
title('Compressed image with compressed channels combined');
imwrite(compressed_image, 'compressed_image_paper2.png');

compressed_info = imfinfo('compressed_image_paper2.png');
compressed_FileSize = compressed_info.FileSize; % getting compressed image size
Nbpp_compressed = (compressed_FileSize*8)/(size(just_Y_compressed,1)*size(just_Y_compressed,2)*3)

compression_ratio = original_FileSize/compressed_FileSize

MSE = immse(compressed_image, I)
ff=im2double(I);
xdd=im2double(compressed_image);
peaksnr=psnr(xdd,ff)
[ssimval, ssimmap] = ssim(compressed_image, I);
fprintf('The SSIM value is %0 .4f.\n',ssimval);

toc
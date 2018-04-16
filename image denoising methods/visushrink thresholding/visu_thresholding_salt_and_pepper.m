function visu_thresholding_salt_and_pepper(input, variance, decomposition_level)

input_image = imread(input);
figure; 
imshow(input_image);
title('original image');

noisy_image = imnoise(input_image, 'salt & pepper', variance);
figure; 
imshow(noisy_image);
title('noisy image');

m_wavelet = 'sym6';

[C,S] = wavedec2(noisy_image, decomposition_level, m_wavelet);
var = length(C)-S(size(S,1)-1,1)^2+1;
sigma_hat = median(abs(C(var:length(C))))/0.6745;

M = size(input_image,1)^2;
universal_threshold = sigma_hat*sqrt(2*log(M));

hard_coefficients = [C(1:S(1,1)^2), hthresh(C(S(1,1)^2+1:length(C)), universal_threshold)];
hard_threshold_final_image = waverec2(hard_coefficients, S, m_wavelet);
figure;
imshow(uint8(hard_threshold_final_image));
title('denoised image using hard thresholding');

d_input_image = im2double(input_image);
d_hard_threshold_final_image = im2double(uint8(hard_threshold_final_image));
snr = psnr(d_input_image, d_hard_threshold_final_image)
hMSE = immse(uint8(hard_threshold_final_image), input_image);
fprintf('\nThe mean-squared error is %0.4f\n', hMSE);
[ssimval, ssimmap] = ssim(uint8(hard_threshold_final_image), input_image);
fprintf('The SSIM value is %0.4f.\n',ssimval);

soft_coefficients = [C(1:S(1,1)^2), sthresh(C(S(1,1)^2+1:length(C)), universal_threshold)];
soft_threshold_final_image = waverec2(soft_coefficients, S, m_wavelet);
figure;
imshow(uint8(soft_threshold_final_image));
title('denoised image using soft thresholding');

d_soft_threshold_final_image = im2double(uint8(soft_threshold_final_image));
snr = psnr(d_input_image, d_soft_threshold_final_image)
sMSE = immse(uint8(soft_threshold_final_image), input_image);
fprintf('\nThe mean-squared error is %0.4f\n', sMSE);
[ssimval, ssimmap] = ssim(uint8(soft_threshold_final_image), input_image);
fprintf('The SSIM value is %0.4f.\n',ssimval);

end
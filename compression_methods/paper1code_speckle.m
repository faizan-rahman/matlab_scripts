tic

clear all
img = imread('Lena.png'); % Read image
original_info = imfinfo('Lena.png');
original_FileSize = original_info.FileSize; %getting original image size
figure;
imshow(img);
title('original image');
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
x = 16*ones(32, 1);
y = 16*ones(32, 1);
r = mat2cell(red, x, y);
g = mat2cell(green, x, y);
b = mat2cell(blue, x, y);

a = zeros(size(img, 1), size(img, 2));
just_red = cat(3, uint8(red), a, a);
imwrite(just_red, 'Lena_red.png'); % saving red channel for lossless compression at compressor.io

%% approximating green band using red band as reference

rcpy = r;
gp1_size = zeros(32,32);
gp2_size = zeros(32,32);
gp3_size = zeros(32,32);
gp4_size = zeros(32,32);
gp5_size = zeros(32,32);
gp6_size = zeros(32,32);
gp7_size = zeros(32,32);
gp8_size = zeros(32,32);
block_matrix = zeros(512, 512);
block_partition_size = mat2cell(block_matrix, x, y);
g_hat = block_partition_size;

for m = 1:32    
    for n = 1:32
        for i = 1:16
            for j = 1:16
                if r{m,n}(i,j) >= 0 && r{m,n}(i,j) <= 31
                    rcpy{m,n}(i,j) = 1;
                    gp1_size(m,n) = gp1_size(m,n) + 1;
                elseif r{m,n}(i,j) > 31 && r{m,n}(i,j) <= 63
                    rcpy{m,n}(i,j) = 2;
                    gp2_size(m,n) = gp2_size(m,n) + 1;
                elseif r{m,n}(i,j) > 63 && r{m,n}(i,j) <= 95
                    rcpy{m,n}(i,j) = 3;
                    gp3_size(m,n) = gp3_size(m,n) + 1;
                elseif r{m,n}(i,j) > 95 && r{m,n}(i,j) <= 127
                    rcpy{m,n}(i,j) = 4;
                    gp4_size(m,n) = gp4_size(m,n) + 1;
                elseif r{m,n}(i,j) > 127 && r{m,n}(i,j) <= 159
                    rcpy{m,n}(i,j) = 5;
                    gp5_size(m,n) = gp5_size(m,n) + 1;
                elseif r{m,n}(i,j) > 159 && r{m,n}(i,j) <= 191
                    rcpy{m,n}(i,j) = 6;
                    gp6_size(m,n) = gp6_size(m,n) + 1;
                elseif r{m,n}(i,j) > 191 && r{m,n}(i,j) <= 223
                    rcpy{m,n}(i,j) = 7;
                    gp7_size(m,n) = gp7_size(m,n) + 1;
                elseif r{m,n}(i,j) > 223 && r{m,n}(i,j) <= 255
                    rcpy{m,n}(i,j) = 8;
                    gp8_size(m,n) = gp8_size(m,n) + 1;
                end
            end
        end
    end
end

gp1 = double(zeros(32,32));
gp2 = double(zeros(32,32));
gp3 = double(zeros(32,32));
gp4 = double(zeros(32,32));
gp5 = double(zeros(32,32));
gp6 = double(zeros(32,32));
gp7 = double(zeros(32,32));
gp8 = double(zeros(32,32));

gS1 = zeros(32,32);
gS2 = zeros(32,32);
gS3 = zeros(32,32);
gS4 = zeros(32,32);
gS5 = zeros(32,32);
gS6 = zeros(32,32);
gS7 = zeros(32,32);
gS8 = zeros(32,32);

for mm = 1:32    
    for nn = 1:32
        for ii = 1:16
            for jj = 1:16
                if rcpy{mm,nn}(ii,jj) == 1
                    gp1(mm,nn) = gp1(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));      %/p1_size;
                elseif rcpy{mm,nn}(ii,jj) == 2
                    gp2(mm,nn) = gp2(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 3
                    gp3(mm,nn) = gp3(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 4
                    gp4(mm,nn) = gp4(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 5
                    gp5(mm,nn) = gp5(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 6
                    gp6(mm,nn) = gp6(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 7
                    gp7(mm,nn) = gp7(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                elseif rcpy{mm,nn}(ii,jj) == 8
                    gp8(mm,nn) = gp8(mm,nn) + double(r{mm,nn}(ii,jj) - g{mm,nn}(ii,jj));
                end
            end
        end
        if gp1_size(mm,nn) == 0
            gp1_size(mm,nn) = 1;
        end
        if gp2_size(mm,nn) == 0
            gp2_size(mm,nn) = 1;
        end
        if gp3_size(mm,nn) == 0
            gp3_size(mm,nn) = 1;
        end
        if gp4_size(mm,nn) == 0
            gp4_size(mm,nn) = 1;
        end
        if gp5_size(mm,nn) == 0
            gp5_size(mm,nn) = 1;
        end
        if gp6_size(mm,nn) == 0
            gp6_size(mm,nn) = 1;
        end
        if gp7_size(mm,nn) == 0
            gp7_size(mm,nn) = 1;
        end
        if gp8_size(mm,nn) == 0
            gp8_size(mm,nn) = 1;
        end
        gS1(mm,nn) = -round(gp1(mm,nn)/gp1_size(mm,nn));
        gS2(mm,nn) = -round(gp2(mm,nn)/gp2_size(mm,nn));
        gS3(mm,nn) = -round(gp3(mm,nn)/gp3_size(mm,nn));
        gS4(mm,nn) = -round(gp4(mm,nn)/gp4_size(mm,nn));
        gS5(mm,nn) = -round(gp5(mm,nn)/gp5_size(mm,nn));
        gS6(mm,nn) = -round(gp6(mm,nn)/gp6_size(mm,nn));
        gS7(mm,nn) = -round(gp7(mm,nn)/gp7_size(mm,nn));
        gS8(mm,nn) = -round(gp8(mm,nn)/gp8_size(mm,nn));
    end
end


for m = 1:32    
    for n = 1:32
        for i = 1:16
            for j = 1:16
                if rcpy{m,n}(i,j) == 1;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS1(m,n);
                elseif rcpy{m,n}(i,j) == 2;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS2(m,n);
                elseif rcpy{m,n}(i,j) == 3;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS3(m,n);
                elseif rcpy{m,n}(i,j) == 4;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS4(m,n);
                elseif rcpy{m,n}(i,j) == 5;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS5(m,n);
                elseif rcpy{m,n}(i,j) == 6;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS6(m,n);
                elseif rcpy{m,n}(i,j) == 7;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS7(m,n);
                elseif rcpy{m,n}(i,j) == 8;
                    g_hat{m,n}(i,j) = r{m,n}(i,j) + gS8(m,n);
                end
            end
        end
    end
end

im_red = img;
im_green = img;
im_blue = img;

% Red channel only
im_red(:,:,2) = 0; 
im_red(:,:,3) = 0; 
figure; 
imshow(im_red);
title('original red band');

% Green channel only
im_green(:,:,1) = 0; 
im_green(:,:,3) = 0; 
figure; 
imshow(im_green);
title('original green band');

% Blue channel only
im_blue(:,:,1) = 0; 
im_blue(:,:,2) = 0; 
figure; 
imshow(im_blue);
title('original blue band');

figure;
imshow('lena_red-compressor.png');  % display compressed red channel
title('compressed red band');

a = zeros(size(img, 1), size(img, 2));
g_hatmat = cell2mat(g_hat);
just_green = cat(3, a, uint8(g_hatmat), a);
figure
imshow(just_green);
title('compressed green band');

figure
compensation_error_g = abs(255 - (uint8(g_hatmat) - green));
imshow(compensation_error_g);
title('error between original and compressed green bands');




%% approximating blue band using approximated green band as reference

gcpy = g_hat;
bp1_size = zeros(32,32);
bp2_size = zeros(32,32);
bp3_size = zeros(32,32);
bp4_size = zeros(32,32);
bp5_size = zeros(32,32);
bp6_size = zeros(32,32);
bp7_size = zeros(32,32);
bp8_size = zeros(32,32);
block_matrix = zeros(512, 512);
block_partition_size = mat2cell(block_matrix, x, y);
b_hat = block_partition_size;

for m = 1:32    
    for n = 1:32
        for i = 1:16
            for j = 1:16
                if g_hat{m,n}(i,j) >= 0 && g_hat{m,n}(i,j) <= 31
                    gcpy{m,n}(i,j) = 1;
                    bp1_size(m,n) = bp1_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 31 && g_hat{m,n}(i,j) <= 63
                    gcpy{m,n}(i,j) = 2;
                    bp2_size(m,n) = bp2_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 63 && g_hat{m,n}(i,j) <= 95
                    gcpy{m,n}(i,j) = 3;
                    bp3_size(m,n) = bp3_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 95 && g_hat{m,n}(i,j) <= 127
                    gcpy{m,n}(i,j) = 4;
                    bp4_size(m,n) = bp4_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 127 && g_hat{m,n}(i,j) <= 159
                    gcpy{m,n}(i,j) = 5;
                    bp5_size(m,n) = bp5_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 159 && g_hat{m,n}(i,j) <= 191
                    gcpy{m,n}(i,j) = 6;
                    bp6_size(m,n) = bp6_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 191 && g_hat{m,n}(i,j) <= 223
                    gcpy{m,n}(i,j) = 7;
                    bp7_size(m,n) = bp7_size(m,n) + 1;
                elseif g_hat{m,n}(i,j) > 223 && g_hat{m,n}(i,j) <= 255
                    gcpy{m,n}(i,j) = 8;
                    bp8_size(m,n) = bp8_size(m,n) + 1;
                end
            end
        end
    end
end

bp1 = double(zeros(32,32));
bp2 = double(zeros(32,32));
bp3 = double(zeros(32,32));
bp4 = double(zeros(32,32));
bp5 = double(zeros(32,32));
bp6 = double(zeros(32,32));
bp7 = double(zeros(32,32));
bp8 = double(zeros(32,32));

bS1 = zeros(32,32);
bS2 = zeros(32,32);
bS3 = zeros(32,32);
bS4 = zeros(32,32);
bS5 = zeros(32,32);
bS6 = zeros(32,32);
bS7 = zeros(32,32);
bS8 = zeros(32,32);

for mm = 1:32    
    for nn = 1:32
        for ii = 1:16
            for jj = 1:16
                if gcpy{mm,nn}(ii,jj) == 1
                    bp1(mm,nn) = bp1(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));      %/p1_size;
                elseif gcpy{mm,nn}(ii,jj) == 2
                    bp2(mm,nn) = bp2(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 3
                    bp3(mm,nn) = bp3(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 4
                    bp4(mm,nn) = bp4(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 5
                    bp5(mm,nn) = bp5(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 6
                    bp6(mm,nn) = bp6(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 7
                    bp7(mm,nn) = bp7(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                elseif gcpy{mm,nn}(ii,jj) == 8
                    bp8(mm,nn) = bp8(mm,nn) + double(g_hat{mm,nn}(ii,jj) - b{mm,nn}(ii,jj));
                end
            end
        end
        if bp1_size(mm,nn) == 0
            bp1_size(mm,nn) = 1;
        end
        if bp2_size(mm,nn) == 0
            bp2_size(mm,nn) = 1;
        end
        if bp3_size(mm,nn) == 0
            bp3_size(mm,nn) = 1;
        end
        if bp4_size(mm,nn) == 0
            bp4_size(mm,nn) = 1;
        end
        if bp5_size(mm,nn) == 0
            bp5_size(mm,nn) = 1;
        end
        if bp6_size(mm,nn) == 0
            bp6_size(mm,nn) = 1;
        end
        if bp7_size(mm,nn) == 0
            bp7_size(mm,nn) = 1;
        end
        if bp8_size(mm,nn) == 0
            bp8_size(mm,nn) = 1;
        end
        bS1(mm,nn) = -round(bp1(mm,nn)/bp1_size(mm,nn));
        bS2(mm,nn) = -round(bp2(mm,nn)/bp2_size(mm,nn));
        bS3(mm,nn) = -round(bp3(mm,nn)/bp3_size(mm,nn));
        bS4(mm,nn) = -round(bp4(mm,nn)/bp4_size(mm,nn));
        bS5(mm,nn) = -round(bp5(mm,nn)/bp5_size(mm,nn));
        bS6(mm,nn) = -round(bp6(mm,nn)/bp6_size(mm,nn));
        bS7(mm,nn) = -round(bp7(mm,nn)/bp7_size(mm,nn));
        bS8(mm,nn) = -round(bp8(mm,nn)/bp8_size(mm,nn));
    end
end


for m = 1:32    
    for n = 1:32
        for i = 1:16
            for j = 1:16
                if gcpy{m,n}(i,j) == 1;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS1(m,n);
                elseif gcpy{m,n}(i,j) == 2;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS2(m,n);
                elseif gcpy{m,n}(i,j) == 3;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS3(m,n);
                elseif gcpy{m,n}(i,j) == 4;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS4(m,n);
                elseif gcpy{m,n}(i,j) == 5;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS5(m,n);
                elseif gcpy{m,n}(i,j) == 6;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS6(m,n);
                elseif gcpy{m,n}(i,j) == 7;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS7(m,n);
                elseif gcpy{m,n}(i,j) == 8;
                    b_hat{m,n}(i,j) = g_hat{m,n}(i,j) + bS8(m,n);
                end
            end
        end
    end
end

a = zeros(size(img, 1), size(img, 2));
b_hatmat = cell2mat(b_hat);
just_blue = cat(3, a, a, uint8(b_hatmat));
figure
imshow(just_blue);
title('compressed blue band');

figure
compensation_error_b = abs(255 - (uint8(b_hatmat) - blue));
imshow(compensation_error_b);
title('error between original and compressed blue bands');


%% error coding using shift values

rpredictedS1 = zeros(32,32);
rpredictedS2 = zeros(32,32);
rpredictedS3 = zeros(32,32);
rpredictedS4 = zeros(32,32);
rpredictedS5 = zeros(32,32);
rpredictedS6 = zeros(32,32);
rpredictedS7 = zeros(32,32);
rpredictedS8 = zeros(32,32);

for m = 1:32
    for n = 1:32
        A = [bS1(m,n) bS2(m,n) bS3(m,n) bS4(m,n) bS5(m,n) bS6(m,n) bS7(m,n) bS8(m,n)];
        B = (A~=0);
        A = A.*B;
        ind = find(A);
        for i = 1:8
            if i == 1 && A(i) ~= 0
                temp = [A(i)-A(8) A(i)-A(7) A(i)-A(6)];
                if temp(1) ~= A(i)
                    rpredictedS1(m,n) = A(8);
                elseif temp(2) ~= A(i)
                    rpredictedS1(m,n) = A(7);
                elseif temp(3) ~= A(i)
                    rpredictedS1(m,n) = A(6);    
                else
                    rpredictedS1(m,n) = gS1(m,n);
                end
            elseif i == 2 && A(i) ~= 0
                temp = [A(i)-A(1) A(i)-A(8) A(i)-A(7)];
                if temp(1) ~= A(i)
                    rpredictedS2(m,n) = A(1);
                elseif temp(2) ~= A(i)
                    rpredictedS2(m,n) = A(8);
                elseif temp(3) ~= A(i)
                    rpredictedS2(m,n) = A(7);    
                else
                    rpredictedS2(m,n) = gS2(m,n);
                end
            elseif i == 3 && A(i) ~= 0
                temp = [A(i)-A(2) A(i)-A(1) A(i)-A(8)];
                if temp(1) ~= A(i)
                    rpredictedS3(m,n) = A(2);
                elseif temp(2) ~= A(i)
                    rpredictedS3(m,n) = A(1);
                elseif temp(3) ~= A(i)
                    rpredictedS3(m,n) = A(8);    
                else
                    rpredictedS3(m,n) = gS3(m,n);
                end
            elseif i == 4 && A(i) ~= 0
                temp = [A(i)-A(i-1) A(i)-A(i-2) A(i)-A(i-3)];
                if temp(1) ~= A(i)
                    rpredictedS4(m,n) = A(i-1);
                elseif temp(2) ~= A(i)
                    rpredictedS4(m,n) = A(i-2);
                elseif temp(3) ~= A(i)
                    rpredictedS4(m,n) = A(i-3);    
                else
                    rpredictedS4(m,n) = gS4(m,n);
                end
            elseif i == 5 && A(i) ~= 0
                temp = [A(i)-A(i-1) A(i)-A(i-2) A(i)-A(i-3)];
                if temp(1) ~= A(i)
                    rpredictedS5(m,n) = A(i-1);
                elseif temp(2) ~= A(i)
                    rpredictedS5(m,n) = A(i-2);
                elseif temp(3) ~= A(i)
                    rpredictedS5(m,n) = A(i-3);    
                else
                    rpredictedS5(m,n) = gS5(m,n);
                end
            elseif i == 6 && A(i) ~= 0
                temp = [A(i)-A(i-1) A(i)-A(i-2) A(i)-A(i-3)];
                if temp(1) ~= A(i)
                    rpredictedS6(m,n) = A(i-1);
                elseif temp(2) ~= A(i)
                    rpredictedS6(m,n) = A(i-2);
                elseif temp(3) ~= A(i)
                    rpredictedS6(m,n) = A(i-3);    
                else
                    rpredictedS6(m,n) = gS6(m,n);
                end
            elseif i == 7 && A(i) ~= 0
                temp = [A(i)-A(i-1) A(i)-A(i-2) A(i)-A(i-3)];
                if temp(1) ~= A(i)
                    rpredictedS7(m,n) = A(i-1);
                elseif temp(2) ~= A(i)
                    rpredictedS7(m,n) = A(i-2);
                elseif temp(3) ~= A(i)
                    rpredictedS7(m,n) = A(i-3);    
                else
                    rpredictedS7(m,n) = gS7(m,n);
                end
            elseif i == 8 && A(i) ~= 0
                temp = [A(i)-A(i-1) A(i)-A(i-2) A(i)-A(i-3)];
                if temp(1) ~= A(i)
                    rpredictedS8(m,n) = A(i-1);
                elseif temp(2) ~= A(i)
                    rpredictedS8(m,n) = A(i-2);
                elseif temp(3) ~= A(i)
                    rpredictedS8(m,n) = A(i-3);    
                else
                    rpredictedS8(m,n) = gS8(m,n);
                end
            end
        end
    end
end

coded_predictedS1 = zeros(size(rpredictedS1,1), size(rpredictedS1,2), 2);
coded_predictedS2 = zeros(size(rpredictedS2,1), size(rpredictedS2,2), 2);
coded_predictedS3 = zeros(size(rpredictedS3,1), size(rpredictedS3,2), 2);
coded_predictedS4 = zeros(size(rpredictedS4,1), size(rpredictedS4,2), 2);
coded_predictedS5 = zeros(size(rpredictedS5,1), size(rpredictedS5,2), 2);
coded_predictedS6 = zeros(size(rpredictedS6,1), size(rpredictedS6,2), 2);
coded_predictedS7 = zeros(size(rpredictedS7,1), size(rpredictedS7,2), 2);
coded_predictedS8 = zeros(size(rpredictedS8,1), size(rpredictedS8,2), 2);

for i = 1:size(rpredictedS1,1)
    for j = 1:size(rpredictedS1,2)
        if rpredictedS1(i,j) < -31 || rpredictedS1(i,j) > 31
            coded_predictedS1(i,j,1) = -32;
            if rpredictedS1(i,j) > 0 
                coded_predictedS1(i,j,2) = rpredictedS1(i,j) - 31;
            elseif rpredictedS1(i,j) < 0
                coded_predictedS1(i,j,2) = rpredictedS1(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS2,1)
    for j = 1:size(rpredictedS2,2)
        if rpredictedS2(i,j) < -31 || rpredictedS2(i,j) > 31
            coded_predictedS2(i,j,1) = -32;
            if rpredictedS2(i,j) > 0 
                coded_predictedS2(i,j,2) = rpredictedS2(i,j) - 31;
            elseif rpredictedS2(i,j) < 0
                coded_predictedS2(i,j,2) = rpredictedS2(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS3,1)
    for j = 1:size(rpredictedS3,2)
        if rpredictedS3(i,j) < -31 || rpredictedS3(i,j) > 31
            coded_predictedS3(i,j,1) = -32;
            if rpredictedS3(i,j) > 0 
                coded_predictedS3(i,j,2) = rpredictedS3(i,j) - 31;
            elseif rpredictedS3(i,j) < 0
                coded_predictedS3(i,j,2) = rpredictedS3(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS4,1)
    for j = 1:size(rpredictedS4,2)
        if rpredictedS4(i,j) < -31 || rpredictedS4(i,j) > 31
            coded_predictedS4(i,j,1) = -32;
            if rpredictedS4(i,j) > 0 
                coded_predictedS4(i,j,2) = rpredictedS4(i,j) - 31;
            elseif rpredictedS4(i,j) < 0
                coded_predictedS4(i,j,2) = rpredictedS4(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS5,1)
    for j = 1:size(rpredictedS5,2)
        if rpredictedS5(i,j) < -31 || rpredictedS5(i,j) > 31
            coded_predictedS5(i,j,1) = -32;
            if rpredictedS5(i,j) > 0 
                coded_predictedS5(i,j,2) = rpredictedS5(i,j) - 31;
            elseif rpredictedS5(i,j) < 0
                coded_predictedS5(i,j,2) = rpredictedS5(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS6,1)
    for j = 1:size(rpredictedS6,2)
        if rpredictedS6(i,j) < -31 || rpredictedS6(i,j) > 31
            coded_predictedS6(i,j,1) = -32;
            if rpredictedS6(i,j) > 0 
                coded_predictedS6(i,j,2) = rpredictedS6(i,j) - 31;
            elseif rpredictedS6(i,j) < 0
                coded_predictedS6(i,j,2) = rpredictedS6(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS7,1)
    for j = 1:size(rpredictedS7,2)
        if rpredictedS7(i,j) < -31 || rpredictedS7(i,j) > 31
            coded_predictedS7(i,j,1) = -32;
            if rpredictedS7(i,j) > 0 
                coded_predictedS7(i,j,2) = rpredictedS7(i,j) - 31;
            elseif rpredictedS7(i,j) < 0
                coded_predictedS7(i,j,2) = rpredictedS7(i,j) + 31;
            end
        end
    end
end

for i = 1:size(rpredictedS8,1)
    for j = 1:size(rpredictedS8,2)
        if rpredictedS8(i,j) < -31 || rpredictedS8(i,j) > 31
            coded_predictedS8(i,j,1) = -32;
            if rpredictedS8(i,j) > 0 
                coded_predictedS8(i,j,2) = rpredictedS8(i,j) - 31;
            elseif rpredictedS8(i,j) < 0
                coded_predictedS8(i,j,2) = rpredictedS8(i,j) + 31;
            end
        end
    end
end

%% displaying compressed image and calculating number of bits per pixel, the compression ratio, MSE, PSNR and SSIM

just_red_compressed = imread('Lena_red-compressor.png'); % loading the compressed (using compressor.io) red channel from the working directory
red_compressed = just_red_compressed(:,:,1); % Red channel
compressed_image = cat(3, red_compressed, g_hatmat, b_hatmat);
figure;
imshow(compressed_image);
title('Compressed image with compressed bands combined');
imwrite(compressed_image, 'compressed_image_paper1.png');

compressed_info = imfinfo('compressed_image_paper1.png');
compressed_FileSize = compressed_info.FileSize; % getting compressed image size
Nbpp_compressed = (compressed_FileSize*8)/(size(red,1)*size(red,2)*3)

compression_ratio = original_FileSize/compressed_FileSize

MSE = immse(compressed_image, img)
ff=im2double(img);
xdd=im2double(compressed_image);
peaksnr=psnr(xdd,ff)
[ssimval, ssimmap] = ssim(compressed_image, img);
fprintf('The SSIM value is %0 .4f.\n',ssimval);

toc
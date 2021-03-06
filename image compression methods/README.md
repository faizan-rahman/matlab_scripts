# Comparison of two color image compression methods

The techniques presented in the following papers have been implemented in MATLAB

[1]	S. Benierbah and M. Khamadja, “Compression of colour images by inter-band compensated prediction”. IEEE Proc.-Vis. Image Signal Process., Vol. 153, No. 2, April 2006

[2]	Seyun Kim and Nam Ik Cho, “Hierarchical Prediction and Context Adaptive Coding for Lossless Color Image Compression”. IEEE Transactions On Image Processing, Vol. 23, No. 1, January 2014




Instructions for running code:

Original images are named Lena, baboon and airplane.

The compressed Y and red channels of Lena, baboon and airplane are given by (Lena_Y1-compressor.png) and 
(Lena_red-compressor.png) and (baboon_Y1-compressor.png) and (baboon_red-compressor.png) and (airplane_Y1-compressor.png) 
and (airplane_red-compressor.png). Images named (Lena_Y1.png) and (Lena_red.png) and (baboon_Y1.png) and (baboon_red.png) and
(airplane_Y1.png) and (airplane_red.png) are compressed at (https://compressor.io) to obtain the compressed images stated above.

Code file for technique 1 (interband prediction) is named (paper1code_speckle.m)

Code file for technique 2 (hierarchical prediction) is named (paper2code_speckle.m) which utilizes a function 
named (dir_calculator.m)

To run code just run (paper1code_speckle.m) or (paper2code_speckle.m) as MATLAB script. Make sure you are in the working directory with all the
required images and helper functions.

To try baboon image in (paper1code_speckle.m) change image name in lines:

line 4: to baboon.png

line 5: to baboon.png

line 21: to baboon_red.png

line 201: to baboon_red-compressor.png

line 610: to baboon_red-compressor.png


To try baboon image in (paper2code_speckle.m) change image name in lines:

line 4: to baboon.png

line 5: to baboon.png

line 30: to baboon_Y1.png

line 351: to baboon_Y1-compressor.png

line 372: to baboon_Y1-compressor.png


Same can be done for airplane.


Final compressed images are stored in compressed_image_paper1.png and compressed_image_paper2.png for techniques 1 and
2 repectively.

Both techniques can be tested for color images of your choice! (as long as they have equal rows and columns).

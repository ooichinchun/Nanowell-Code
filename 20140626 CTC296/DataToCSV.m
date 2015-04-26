clear
clc
format long

%Only can do 11 x 9 array for this set of images
filename_before = 'Before 5X_F_CY3';
filename_after_PE = 'After PCR_5X F_CY3';
filename_after_FITC = 'After PCR_5X F_GFP';

% This should be the (x,y) coordinates for the first well in array
CD45_W1 = [129,19];
After_W1 = [108,15];

% This should be the (x,y) coordinates for the 64th well in first array
CD45_W64 = [224,113];
After_W64 = [202,109];

% Location the (x,y) coordinates above are in the first 8x8 well array
% x_vector_index = 1;
% y_vector_index = 1;

% (x,y) coordinates for the first well in the top-right array
CD45_TR = [1257,16];
After_TR = [1234,11];

% (x,y) coordinates for the first well in the bottom-left array
CD45_BL = [130,920];
After_BL = [108,914];

Num_Arrays = [11,9];

CD45 = MeasureImage(filename_before,CD45_W1,CD45_W64,CD45_TR,CD45_BL,Num_Arrays);
PE = MeasureImage(filename_after_PE,After_W1,After_W64,After_TR,After_BL,Num_Arrays);
FITC = MeasureImage(filename_after_FITC,After_W1,After_W64,After_TR,After_BL,Num_Arrays);


headers = cellstr(['O_Mean ';'O_Std  ';'O_75th ';'O_Med  ';'Sq_Mean';'Sq_Std ';'Sq_Mode';'Sq_Med ';'X      ';'Y      ']);


csvwrite_with_headers(strcat(filename_before,'.csv'),CD45,headers);
csvwrite_with_headers(strcat(filename_after_PE,'.csv'),PE,headers);
csvwrite_with_headers(strcat(filename_after_FITC,'.csv'),FITC,headers);
clear
clc
format long

filename_before = 'HEX_Before';
filename_after_PE = 'HEX_After';
filename_after_FITC = 'GFP_After';

% This should be the (x,y) coordinates for the first well in array
CD45_W1 = [146,20];
After_W1 = [130,29];

% This should be the (x,y) coordinates for the 64th well in first array
CD45_W64 = [240,115];
After_W64 = [225,123];

% Location the (x,y) coordinates above are in the first 8x8 well array
% x_vector_index = 1;
% y_vector_index = 1;

% (x,y) coordinates for the first well in the top-right array
CD45_TR = [1279,26];
After_TR = [1265,18];

% (x,y) coordinates for the first well in the bottom-left array
CD45_BL = [134,812];
After_BL = [131,822];

% Number of 8x8 well arrays in the entire image to scan
Num_Arrays = [11,8];

CD45 = MeasureImage(filename_before,CD45_W1,CD45_W64,CD45_TR,CD45_BL,Num_Arrays);
FITC = MeasureImage(filename_after_FITC,After_W1,After_W64,After_TR,After_BL,Num_Arrays);
PE = MeasureImage(filename_after_PE,After_W1,After_W64,After_TR,After_BL,Num_Arrays);


headers = cellstr(['O_Mean ';'O_Std  ';'O_75th ';'O_Med  ';'Sq_Mean';'Sq_Std ';'Sq_Mode';'Sq_Med ';'X      ';'Y      ']);


csvwrite_with_headers(strcat(filename_before,'.csv'),CD45,headers);
csvwrite_with_headers(strcat(filename_after_PE,'.csv'),PE,headers);
csvwrite_with_headers(strcat(filename_after_FITC,'.csv'),FITC,headers);
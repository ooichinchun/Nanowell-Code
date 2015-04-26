clear
clc
format long

filename_before = 'Before 5X_F_CY3';
filename_after_PE = 'After PCR_5X F_CY3';
filename_after_FITC = 'After PCR_5X F_GFP';

% This should be the (x,y) coordinates for the first well in array
CD45_W1 = [12,10];
After_W1 = [10,8];

% This should be the (x,y) coordinates for the 64th well in first array
CD45_W64 = [108,104];
After_W64 = [106,103];

% Location the (x,y) coordinates above are in the first 8x8 well array
% x_vector_index = 1;
% y_vector_index = 1;

% (x,y) coordinates for the first well in the top-right array
CD45_TR = [1250,5];
After_TR = [1249,18];

% (x,y) coordinates for the first well in the bottom-left array
CD45_BL = [19,914];
After_BL = [7,914];

Num_Arrays = [12,9];

CD45 = MeasureImage(filename_before,CD45_W1,CD45_W64,CD45_TR,CD45_BL,Num_Arrays);
PE = MeasureImage(filename_after_PE,After_W1,After_W64,After_TR,After_BL,Num_Arrays);
FITC = MeasureImage(filename_after_FITC,After_W1,After_W64,After_TR,After_BL,Num_Arrays);


headers = cellstr(['O_Mean ';'O_Std  ';'O_75th ';'O_Med  ';'Sq_Mean';'Sq_Std ';'Sq_Mode';'Sq_Med ';'X      ';'Y      ']);


csvwrite_with_headers(strcat(filename_before,'.csv'),CD45,headers);
csvwrite_with_headers(strcat(filename_after_PE,'.csv'),PE,headers);
csvwrite_with_headers(strcat(filename_after_FITC,'.csv'),FITC,headers);
clear
clc
format long

filename_before = 'HEX_Before';
filename_after_PE = 'HEX_After';
filename_after_FITC = 'FAM_After';

% This should be the (x,y) coordinates for the first well in array
CD45_W1 = [128,133];
After_W1 = [121,126];

% This should be the (x,y) coordinates for the 64th well in first array
CD45_W64 = [223,227];
After_W64 = [215,219];

% Location the (x,y) coordinates above are in the first 8x8 well array
% x_vector_index = 1;
% y_vector_index = 1;

% (x,y) coordinates for the first well in the top-right array
CD45_TR = [1253,123];
After_TR = [1245,122];

% (x,y) coordinates for the first well in the bottom-left array
CD45_BL = [131,920];
After_BL = [119,912];

% Number of 8x8 well arrays in the entire image to scan
Num_Arrays = [11,8];

CD45 = MeasureImage(filename_before,CD45_W1,CD45_W64,CD45_TR,CD45_BL,Num_Arrays);
FITC = MeasureImage(filename_after_FITC,After_W1,After_W64,After_TR,After_BL,Num_Arrays);
PE = MeasureImage(filename_after_PE,After_W1,After_W64,After_TR,After_BL,Num_Arrays);


headers = cellstr(['O_Mean ';'O_Std  ';'O_75th ';'O_Med  ';'Sq_Mean';'Sq_Std ';'Sq_Mode';'Sq_Med ';'X      ';'Y      ']);


csvwrite_with_headers(strcat(filename_before,'.csv'),CD45,headers);
csvwrite_with_headers(strcat(filename_after_PE,'.csv'),PE,headers);
csvwrite_with_headers(strcat(filename_after_FITC,'.csv'),FITC,headers);
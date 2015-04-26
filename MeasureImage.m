function [Output] = MeasureImage(filename,W_1,W_64,W_TR,W_BL,Num_Arrays)

format long

I = imread(strcat(filename,'.tif'));
% I2 = imcrop(I, rect) crops the image I. rect is a 
% four-element position vector
% [xmin ymin width height] that specifies the 
% size and position of the crop rectangle.
% I2 = imcrop(I,[75 68 130 112]);
% imshow(I)
% imwrite(I2,'myNewFile.tif');

% This should be the (x,y) coordinates for the first well in array
x_vector = W_1(1,1);
y_vector = W_1(1,2);

% This should be the (x,y) coordinates for the 64th well in first array
x_vector_bot = W_64(1,1);
y_vector_bot = W_64(1,2);

% Location the (x,y) coordinates above are in the first 8x8 well array
%x_vector_index = 1;
%y_vector_index = 1;

% (x,y) coordinates for the first well in the top-right array
x_tr_vector = W_TR(1,1);
y_tr_vector = W_TR(1,2);

% (x,y) coordinates for the first well in the bottom-left array
x_bl_vector = W_BL(1,1);
y_bl_vector = W_BL(1,2);

% Number of 8x8 well arrays in the entire image to scan
arrays_num_x = Num_Arrays(1,1); % 12
arrays_num_y = Num_Arrays(1,2); % 9

% Diameter of well in pixels and length of surrounding square to use in background correction
circleR = 10;
circleR_S = 8;
SquareL = 15;

% Delta_x and Delta_y moving from 1st well to 64th well in 8x8 grid
dx_within_grid = (x_vector_bot - x_vector)/7; 
dy_within_grid = (y_vector_bot - y_vector)/7; 

% Delta_x and Delta_y moving from 1st well in 8x8 grid to 1st well in adjacent 8x8 grid
% Horizontal refers to adjacent grid in x-direction
% Vertical refers to adjacent grid in the y-direction
dx_horizontal_between_grid = (x_tr_vector-x_vector)/(arrays_num_x-1); 
dy_horizontal_between_grid = (y_tr_vector-y_vector)/(arrays_num_x-1); 
dx_vertical_between_grid = (x_bl_vector-x_vector)/(arrays_num_y-1);
dy_vertical_between_grid = (y_bl_vector-y_vector)/(arrays_num_y-1);

count = 0;
num_arrays = arrays_num_x*arrays_num_y*8^2;
circle_mean = zeros(num_arrays,1);
circle_stddev = zeros(num_arrays,1);
circle_75th = zeros(num_arrays,1);
circle_median = zeros(num_arrays,1);
sq_mean = zeros(num_arrays,1);
sq_stddev = zeros(num_arrays,1);
sq_mode = zeros(num_arrays,1);
sq_median = zeros(num_arrays,1);
x_coord = zeros(num_arrays,1);
y_coord = zeros(num_arrays,1);

Num_loops = ceil(circleR/2);
pixels_within_circle = zeros(Num_loops^2,2);

count = 1;
for dx = 0:Num_loops
    for dy = 0:Num_loops
        pixels_within_circle(count,1) = dx;
        pixels_within_circle(count,2) = dy;
        count = count + 1;
    end
end

pixel_dist = pixels_within_circle(:,1).^2 + pixels_within_circle(:,2).^2;
pixel_circle = pixels_within_circle(pixel_dist<((circleR/2)^2),:);
pixels_circle = [pixel_circle; (-1)*pixel_circle(:,1) pixel_circle(:,2); pixel_circle(:,1) (-1)*pixel_circle(:,2); (-1)*pixel_circle];
pixels_circle = unique(pixels_circle,'rows');

pixels_sq = zeros(SquareL^2,2);
count = 1;
for dx = -((SquareL-1)/2):((SquareL-1)/2)
    for dy = -((SquareL-1)/2):((SquareL-1)/2)
        pixels_sq(count,1) = dx;
        pixels_sq(count,2) = dy;
        count = count + 1;
    end
end

pixels_sq = pixels_sq(~ismember(pixels_sq,pixels_circle,'rows'),:);

Num_loops = ceil(circleR_S/2);
pixels_within_circle = zeros(Num_loops^2,2);
count = 1;
for dx = 0:Num_loops
    for dy = 0:Num_loops
        pixels_within_circle(count,1) = dx;
        pixels_within_circle(count,2) = dy;
        count = count + 1;
    end
end

pixel_dist = pixels_within_circle(:,1).^2 + pixels_within_circle(:,2).^2;
pixel_circle = pixels_within_circle(pixel_dist<((circleR_S/2)^2),:);
pixels_circle = [pixel_circle; (-1)*pixel_circle(:,1) pixel_circle(:,2); pixel_circle(:,1) (-1)*pixel_circle(:,2); (-1)*pixel_circle];
pixels_circle = unique(pixels_circle,'rows');

count = 0;
for b=0:(arrays_num_y-1)
  for a=0:(arrays_num_x-1)
      for c = 0:7
          for d = 0:7
              count = count + 1;
              x_start = round(x_vector + a*dx_horizontal_between_grid + b*dx_vertical_between_grid + c*dx_within_grid);
              y_start = round(y_vector + a*dy_horizontal_between_grid + b*dy_vertical_between_grid + d*dy_within_grid);
              rel_circle = [(pixels_circle(:,1)+x_start) (pixels_circle(:,2)+y_start)];
              rel_circle = rel_circle((rel_circle(:,1)>0),:);
              rel_circle = rel_circle((rel_circle(:,2)>0),:);
              rel_sq = [(pixels_sq(:,1)+x_start) (pixels_sq(:,2)+y_start)];
              rel_sq = rel_sq((rel_sq(:,1)>0),:);
              rel_sq = rel_sq((rel_sq(:,2)>0),:);

              idx = sub2ind(size(I), rel_circle(:,2), rel_circle(:,1));

              circle_param = I(idx);
              circle_mean(count) = mean(circle_param);
              circle_std(count) = std(double(circle_param));
              circle_75th(count) = mean(circle_param(and((circle_param>prctile(circle_param,60)),(circle_param<prctile(circle_param,90))),:));
              circle_median(count) = median(circle_param);
              
              idx = sub2ind(size(I), rel_sq(:,2), rel_sq(:,1));
              sq_param = I(idx);
              sq_mean(count) = mean(sq_param);
              sq_std(count) = std(double(sq_param));
              sq_mode(count) = mode(sq_param);
              sq_median(count) = median(sq_param);
              
              x_coord(count) = x_start;
              y_coord(count) = y_start;
          end
      end
  end
end

Output = [circle_mean circle_std' circle_75th circle_median sq_mean sq_std' sq_mode sq_median x_coord y_coord];

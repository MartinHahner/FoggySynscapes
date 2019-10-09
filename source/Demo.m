% Demo of fog simulation pipeline that we used in our ITSC 2019 paper 
% titled Semantic Understanding of Foggy Scenes with Purely Synthetic Data,  
% to create Foggy Synscapes, a foggy version of the original Synscapes dataset. 

clear;

% ------------------------------------------------------------------------------

% Example images. Uncomment whichever image you like to experiment with.
image = '1';
% image = '2';
% image = '3';

% Attenuation coefficient (in inverse meters).
% In case of fog, the value of the attenuation coefficient 
% should be set to 0.003 or higher.
beta = 0.06;

% ------------------------------------------------------------------------------

% Add required paths.

current_script_full_name = mfilename('fullpath');
current_script_directory = fileparts(current_script_full_name);

addpath(fullfile(current_script_directory, 'utilities'));

addpath_relative_to_caller(current_script_full_name,...
    fullfile('Depth_processing'));
addpath_relative_to_caller(current_script_full_name,...
    fullfile('Fog_simulation'));

% ------------------------------------------------------------------------------

% Input the required data.

[parentdir,~,~] = fileparts(current_script_directory);

demo_root_dir = fullfile(parentdir, 'data', 'demo');

img_uint8 = imread(fullfile(demo_root_dir, 'img', 'rgb', ...
    strcat(image, '.png')));
camera_parameters_file = fullfile(demo_root_dir, 'camera', 'camera.json');

% Bring original, clear image to double precision for subsequent
% computations.
clear_image = im2double(img_uint8);

% ------------------------------------------------------------------------------

% Configure result files and directories, and parameters for fog simulation.

results_root_dir = fullfile(parentdir, 'output', 'demo');
foggy_results_dir = 'foggy_img';
depth_results_dir = 'depth_map';
transmittance_results_dir = 'transmittance_map';

suffix = strcat('_beta_', num2str(beta));

% Window size for atmospheric light estimation.
window_size = 15;

% ------------------------------------------------------------------------------

% load depth map.

depth_file = fullfile(demo_root_dir, 'depth_mat', strcat(image, '.mat'));

depth_mat = load(depth_file);

depth_map = im2double(depth_mat.depth);

% Write result to PNG image.
depth_result_filename = strcat(image, '.png');

depth_result_dir = fullfile(results_root_dir, depth_results_dir);

if ~exist(depth_result_dir, 'dir')
    mkdir(depth_result_dir);
end

imwrite(mat2gray(log(log(log(depth_map)))), fullfile(depth_result_dir, ...
    depth_result_filename));

% ------------------------------------------------------------------------------

% compute transmittance map

t = transmission_homogeneous_medium(depth_map, beta, camera_parameters_file);

% ------------------------------------------------------------------------------

% Write result to PNG image.
transmittance_result_filename = strcat(image, suffix, '.png');

transmittance_result_dir = fullfile(results_root_dir,...
    transmittance_results_dir);

if ~exist(transmittance_result_dir, 'dir')
    mkdir(transmittance_result_dir);
end

imwrite(1-t, fullfile(transmittance_result_dir, transmittance_result_filename));

% ------------------------------------------------------------------------------

% Estimation of atmospheric light from the clear-weather image, using the method
% proposed by He et al. in "Single Image Haze Removal Using Dark Channel Prior"
% (IEEE T-PAMI, 2011) with the improvement of Tang et al. in "Investigating
% Haze-relevant Features in a Learning Framework for Image Dehazing" (CVPR,
% 2014).

clear_image_dark_channel = get_dark_channel(clear_image, window_size);
L_atm = estimate_atmospheric_light_rf(clear_image_dark_channel, clear_image);

% ------------------------------------------------------------------------------

% Fog simulation from the clear-weather image and the estimated transmittance
% map and atmospheric light, using the standard optical model for fog and haze
% introduced by Koschmieder in "Theorie der horizontalen Sichtweite" (Beitrage
% zur Physik der freien Atmosphaere, 1924) which assumes homogeneous atmosphere
% and globally constant atmospheric light.

% Compute synthetic foggy image.
I = haze_linear(clear_image, t, L_atm);

% Write result to PNG image.
foggy_result_filename = strcat(image, suffix,'.png');

foggy_result_dir = fullfile(results_root_dir,foggy_results_dir);

if ~exist(foggy_result_dir, 'dir')
    mkdir(foggy_result_dir);
end

imwrite(I, fullfile(foggy_result_dir, foggy_result_filename));

% Display Demo Results
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'name','Demo','numbertitle','off')
subplot(2,2,1), imshow(img_uint8), title('Clear Weather Input')
subplot(2,2,2), imshow(I), title('Foggy Weather Output')
subplot(2,2,3), imshow(mat2gray(log(log(log(depth_map))))), title('Depth Map')
subplot(2,2,4), imshow(1-t), title(['Transmittance Map (beta = ',num2str(beta),')'])


function FoggySynscapes(beta)

% This script can convert Synscapes into Foggy Synscapes 
%
%   INPUTS:
%
%   -beta: Attenuation coefficient (in inverse meters).
%          In case of fog, the value of the attenuation coefficient 
%          should be set to 0.003 or higher.

% ------------------------------------------------------------------------------

% change those paths accordingly

images_root_dir = '/path/to/Synscapes/img/rgb';
results_root_dir = '/path/where/you/want/to/save/Foggy_Synscapes';

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

camera_parameters_file = fullfile('../data/demo/camera/camera.json');

for img_id = 1:25000
    
    image_name = int2str(img_id);
    save_name = pad(image_name, 5, 'left', '0');

    image_uint8 = imread(fullfile(images_root_dir, strcat(image_name, '.png')));

    % Bring original, clear image to double precision for subsequent computations.
    image = im2double(image_uint8);

    % ------------------------------------------------------------------------------

    % Window size for atmospheric light estimation.
    window_size = 15;

    % Configure result files and directories, and parameters for fog simulation.

    foggy_results_dir = strcat('beta_', num2str(beta), '/foggy_img');
    transmittance_results_dir = strcat('beta_', num2str(beta), '/transmittance');

    suffix_foggy = strcat('_beta_', num2str(beta));
    suffix_transmittance = strcat('_beta_', num2str(beta));

    % make sure that the depth (.mat) files are located here
    depth_file = strcat(results_root_dir, '/depth/', image_name, '.mat');

    % load depth map.
    depth_mat = load(depth_file);
    depth_map = im2double(depth_mat.depth);

    % ------------------------------------------------------------------------------

    t = transmission_homogeneous_medium(depth_map, beta, camera_parameters_file);

    % Write result to PNG image.
    transmittance_result_filename = strcat(save_name, suffix_transmittance, '.png');
    transmittance_result_dir = fullfile(results_root_dir, transmittance_results_dir);

    if ~exist(transmittance_result_dir, 'dir')
        mkdir(transmittance_result_dir);
    end

    imwrite(t, fullfile(transmittance_result_dir, transmittance_result_filename));

    % ------------------------------------------------------------------------------

    % Estimation of atmospheric light from the clear-weather image, using the method
    % proposed by He et al. in "Single Image Haze Removal Using Dark Channel Prior"
    % (IEEE T-PAMI, 2011) with the improvement of Tang et al. in "Investigating
    % Haze-relevant Features in a Learning Framework for Image Dehazing" (CVPR,
    % 2014).

    clear_image_dark_channel = get_dark_channel(image, window_size);
    L_atm = estimate_atmospheric_light_rf(clear_image_dark_channel, image);

    % ------------------------------------------------------------------------------

    % Fog simulation from the clear-weather image and the estimated transmittance
    % map and atmospheric light, using the standard optical model for fog and haze
    % introduced by Koschmieder in "Theorie der horizontalen Sichtweite" (Beitrage
    % zur Physik der freien Atmosphaere, 1924) which assumes homogeneous atmosphere
    % and globally constant atmospheric light.

    % Compute partially synthetic foggy image.
    I = haze_linear(image, t, L_atm);

    % Write result to PNG image.
    foggy_result_filename = strcat(save_name, suffix_foggy, '.png');
    foggy_result_dir = fullfile(results_root_dir,foggy_results_dir);

    if ~exist(foggy_result_dir, 'dir')
        mkdir(foggy_result_dir);
    end

    imwrite(I, fullfile(foggy_result_dir, foggy_result_filename));
    
    disp(save_name)

end



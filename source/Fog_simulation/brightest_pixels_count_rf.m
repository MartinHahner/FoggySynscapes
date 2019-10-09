function brightest_pixels_count = brightest_pixels_count_rf(number_of_pixels,...
    brightest_pixels_fraction)

% BRIGHTEST_PIXELS_COUNT
% 
% Counts the number of brightest pixels.

brightest_pixels_count_tmp = floor(brightest_pixels_fraction *...
    number_of_pixels);

brightest_pixels_count = brightest_pixels_count_tmp +...
    mod(brightest_pixels_count_tmp + 1, 2);

end


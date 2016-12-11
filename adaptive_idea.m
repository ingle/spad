load 'censor.mat' I_keep_half I_keep_one_fourth

C_map = func_run_proposed_step1(C,B);
C_map_half = func_run_proposed_step1(C,B,I_keep_half);
C_map_one_fourth = func_run_proposed_step1(C,B,I_keep_one_fourth);

close all
figure(1); imagesc(C_map); colormap gray; title('full data')
figure(2); imagesc(C_map_half); colormap gray; title('half data')
figure(3); imagesc(C_map_one_fourth); colormap gray; title('quarter data')

% now go from 1/4 to 1/2 by getting extra samples around 
% interesting areas in C_map_one_fourth

pkg load image;

C_map_one_fourth_dilated = imdilate(C_map_one_fourth,ones(10));
interesting_regions = C_map_one_fourth_dilated > 0.6;
figure(4); imagesc(interesting_regions); colormap gray; title('int.reg')
I_keep_half_adaptive = I_keep_one_fourth | interesting_regions;
fprintf('half: %d, half_adaptive: %d\n',sum(I_keep_half(:)), sum(I_keep_half_adaptive(:)));

C_map_half_adaptive = func_run_proposed_step1(C,B,I_keep_half_adaptive);
figure(5); imagesc(C_map_half_adaptive); colormap gray; title('half adaptive data');
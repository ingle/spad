clc; warning off all;

if ~exist('C')
    close all
    fprintf('loading data. this will be done only once...\n');    
    spad_file_name = 'data/scene_man_flower_N100';
    
    % frame parameters 
    num_frames = 20;
    load(spad_file_name);
    [nr,nc] = size(D);
    bin_ranges = 0:127;
    % load functions in dir
    addpath(genpath([pwd '/functions']));
    C = zeros(nr,nc);
    T = cell(nr,nc);
    for i=1:nr
        for j=1:nc
            frames = F{i,j};
            dats = D{i,j};
            inds = find(frames<num_frames);
            if(~isempty(inds))
                dats_new = dats(inds);
                C(i,j) = length(dats_new);
                T{i,j} = [T{i,j} dats_new'];
            end
        end
    end
    fprintf('data loaded.\n');
end
if ~exist('B')
    load 'data/data_supp.mat' B
end

load 'data/censor.mat' I_keep_half I_keep_one_fourth
% ... Or, regenerate the subsampling matrices randomly:
% I_keep_half = rand(384)>0.5;
% I_keep_one_fourth = rand(384)<0.25;


C_map = func_run_proposed_step1(C,B);
C_map_half = func_run_proposed_step1(C,B,I_keep_half);
C_map_one_fourth = func_run_proposed_step1(C,B,I_keep_one_fourth);

figure(1); imagesc(C_map); colormap gray; title('full data', 'FontSize', 20)
figure(2); imagesc(C_map_half); colormap gray; title('half data', 'FontSize', 20)
figure(3); imagesc(C_map_one_fourth); colormap gray; title('quarter data', 'FontSize', 20)

% now go from 1/4 to 1/2 by getting extra samples around 
% interesting areas in C_map_one_fourth

pkg load image;

C_map_one_fourth_dilated = imdilate(C_map_one_fourth,ones(10));
interesting_regions = C_map_one_fourth_dilated > 0.6;
figure(4); imagesc(interesting_regions); colormap gray; title('interesting regions', 'FontSize', 20)
I_keep_half_adaptive = I_keep_one_fourth | interesting_regions;
fprintf('half: %d, half_adaptive: %d\n',sum(I_keep_half(:)), sum(I_keep_half_adaptive(:)));

C_map_half_adaptive = func_run_proposed_step1(C,B,I_keep_half_adaptive);
figure(5); imagesc(C_map_half_adaptive); colormap gray; title('half adaptive data', 'FontSize', 20);
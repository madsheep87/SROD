clc
clear all
% Load Dictionary
% addpath('.\KSVD\KSVD');
addpath('GuidedFilter');
load DicNat.mat;

dir_ImgIn = './Input/';
dir_SaliencyMap = './Output/';
imgIn_Names = dir([dir_ImgIn '*' 'jpg']);
sz_Patch = 8;
for i = 1:length(imgIn_Names)
    t0 = clock;
    imgIn_path = [dir_ImgIn imgIn_Names(i).name];
%     GT_path = [dir_GT GT_Names(i).name]; 
    fprintf(strcat('\n','Processing:',imgIn_path,'. '));
    %% Image sparse representation
    img_Org = im2double(imread(imgIn_path));
    [imgOrg_h, imgOrg_w, ch1] = size(img_Org);
    img_In = imresize(img_Org, 200/max(imgOrg_h, imgOrg_w));
    [resize_h, resize_w, ch2] = size(img_In);
    cform = makecform('srgb2lab');img_Lab = applycform(img_In,cform);
    img_Vector = im2Vector(img_Lab, sz_Patch);
    img_SparseNat = DicNat * img_Vector;% filtering output
    %% Sparse residual
    SR_Nat = SparseResidual(img_Vector, img_SparseNat);
    sMap_SRNat = mat2gray(vector2Im(SR_Nat, resize_h, resize_w, sz_Patch));
%     imwrite(imresize(sMap_SRNat,[imgOrg_h, imgOrg_w]),strcat(dir_SaliencyMap,imgIn_Names(i).name),'jpg');
    %% Outlier detection
    sMap_Out = OSOS(img_In,1,500,6);
%     imwrite(imresize(sMap_Out,[imgOrg_h, imgOrg_w]),strcat('./Output/Test/',imgIn_Names(i).name),'jpg');
    %% Fusion
    saliencyMap = mat2gray(guidedfilter(sMap_SRNat, sMap_Out,4,0.04));
    %% Post processing
    % Gaussain smooth
    sgm = min(resize_h, resize_w)*0.04;
    saliencyMap = imfilter(saliencyMap, fspecial('Gaussian',round([sgm,sgm]*4),sgm));
    saliencyMap = mat2gray(imresize(saliencyMap,[imgOrg_h, imgOrg_w]));
    
    % Refine, will improve AUC score, but decrease sAUC score
%     ratio_Refine = 0.25;
%     refine_w = size(saliencyMap,1); refine_h = size(saliencyMap,2);
%     saliencyMap = mat2gray(calculateGuassOptimization(saliencyMap,ratio_Refine,refine_w,refine_h));
    
    imwrite(saliencyMap,strcat(dir_SaliencyMap,imgIn_Names(i).name),'jpg');
    time_elapsed = etime(clock, t0);
    disp(strcat('Time cost:',num2str(time_elapsed),'s.'));
end



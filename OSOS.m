%% March 12, 2015.
function fixationMap = OSOS(img_Org,resize_ratio,sample_size,strel_size)
img_In = im2double(imresize(img_Org,resize_ratio));
[size_w,size_h,c] = size(img_In);
size_img = size_w*size_h;

if c>1 %color image
    %Lab
    cform = makecform('srgb2lab');img_lab = applycform(img_In,cform);
    L = mat2gray(img_lab(:,:,1)); 
    a = mat2gray(img_lab(:,:,2)); 
    b = mat2gray(img_lab(:,:,3));
    feature_Dim = 3; %feature dimension
    feature_In = zeros(size_img,feature_Dim);
    for i=1:size_img
     feature_In(i,:) = [L(i),a(i),b(i)];
    end

else % gray scale image
    I = img_In;
    feature_Dim = 1;
    feature_In = zeros(size_img,feature_Dim);
    for i=1:size_img
        feature_In(i,:) = I(i);
    end
end

%% Detect outliers
samp_Data = datasample(feature_In, sample_size ,'Replace', true);% random sampling
t0 = clock;
D = zeros(1,size_w*size_h);
parfor i=1:size_w*size_h
    D(i) = min(pdist2(feature_In(i,:),samp_Data,'minkowski',1));
end
fixationMap = reshape(D,size_w,size_h);
time_elapsed = etime(clock, t0);
% fprintf(strcat('Time cost:',num2str(time_elapsed),'s.'));

%% dilation, avoid some isolate fixation points fade when smoothing.
if strel_size>=1
    SE = strel('square',strel_size);
    fixationMap = imdilate(fixationMap,SE);
end

%% Fixation map
fixationMap = mat2gray(fixationMap);
end
% Li X, Lu H, Zhang L, et al. Saliency detection via dense and sparse reconstruction.In IEEE Conference on Computer Vision and Pattern Recognition, 2013: 2976-2983
function guassOptimizeResult = calculateGuassOptimization(initialResult,guassSigmaRatio,r,c)
%% Refine the saliency map by the object-biased Gaussian model.
%% Input
%  initialResult: the input saliency map
%  guassSigmaRatio: control the window size
%  r: the row size of the Gaussian template
%  c: the column size of the Gaussian template
%% Output
%  guassOptimizeResult: the refined saliency map

guassianTemplate = calOptimizedGuassTemplate(initialResult,guassSigmaRatio,[r c]);
guassOptimizeResult = guassianTemplate.*initialResult;
guassOptimizeResult = (guassOptimizeResult-min(guassOptimizeResult(:)))/(max(guassOptimizeResult(:))-min(guassOptimizeResult(:)));
%% Compute outlier map here.
function Rarity = Outlier(X,sz_Samp)
feature_In = X';
%% Detect outliers
samp_Data = datasample(feature_In, sz_Samp ,'Replace', true);% random sampling
t0 = clock;
length_X = size(X,2);
Rarity = zeros(1,length_X);
for i=1:length_X
    Rarity(i) = (min(pdist2(feature_In(i,:),samp_Data))).^2;
end
% inv_Rarity = max(Rarity)./Rarity;
time_elapsed = etime(clock, t0);
fprintf(strcat('Time cost:',num2str(time_elapsed),'s.'));
end
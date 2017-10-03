%% Sparse Reconstruction error.
function SR = SparseResidual(Y,DX)
SR = zeros(1,size(Y,2));
for i=1:size(Y,2)
     SR(:,i) = norm(Y(:,i)-DX(:,i),1).^2;
end
end
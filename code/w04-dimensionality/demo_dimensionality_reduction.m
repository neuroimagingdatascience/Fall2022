load demo_dimensionality_reduction.mat
x = clin;
[n,p] = size(x);

[u,s,v] = svd(x,0);

% check sizes of u,s,v

% look at the scree plot
figure; plot(diag(s),'o')

figure; plot(diag(s).^2 / sum(diag(s).^2),'o'); 
ylabel('variance explained')
hold on
hline(1/31)
plot(get(gca,'Xlim'),1/31)
1/31

% check that eigenvectors are uncorrelated

corr(u(:,1),u(:,2))

corr(u)

% plot the component (weights)
figure; barh(v(:,1));
set(gca,'YTick',1:numel(label),'YTickLabel',label);
xlabel('eigenvector weights')

% calculate loadings
vsc = x*v(:,1);
vlo = corr(x,vsc);

figure; barh(vlo);
set(gca,'YTick',1:numel(label),'YTickLabel',label)
xlabel('loadings')

% could also use specialized functions
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(x);

% compare svd and pca versions
corr(v(:,1),COEFF(:,1))
corr(vsc,SCORE(:,1))
figure; plot(EXPLAINED(:,1))

% bootstrap
nboot = 500;
vloboot = zeros(p,nboot);

for ii = 1:nboot
    idx = randi(n,n,1);
    xboot = x(idx,:);   %sample subjects with replacement
    [~,~,vboot] = svd(xboot,0);
    
    [~,vbootp] = procrustes(v,vboot);
    
    vscboot = xboot*vbootp(:,1);
    vloboot(:,ii) = corr(xboot,vscboot);
    fprintf('sample %i done\n',ii)
end

figure; boxplot(vloboot','orientation','horizontal','labels',label); hold on
vline(0)
    
    
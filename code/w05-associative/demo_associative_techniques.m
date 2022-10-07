n = 630;
k = n*(n-1) / 2;
t = 73;

mask = triu(ones(n),1)>0;

x = zeros(t,k);
for ii = 1:t
    temp = squeeze(fc(:,:,ii));
    x(ii,:) = temp(mask);
end

% pca
[u,s,v] = svd(x',0);

rr = zeros(t,1);

for lv = 1:t
    redata = u(:,1:lv) * s(1:lv,1:lv) * v(:,1:lv)';
    redata = redata';
    rr(lv) = corr(x(:),redata(:));
end

plot(rr)

% pls
y = panasx;

ny = size(panasx,2);

R = corr(x,y);
[u,s,v] = svd(R,0);

nperm = 100;

sp = zeros(ny,nperm);
for ii = 1:nperm
    idx = randperm(t);
    xp = x(idx,:);
    Rp = corr(xp,y);
    
    sp(:,ii) = svd(Rp,0);
    
end

s = diag(s);
p = sum(bsxfun(@ge,sp,s),2) / nperm;

% scores
usc = x * u(:,1);
vsc = y * v(:,1);

figure;
scatter(usc,vsc)


% cross-validate
nreps = 100;
score_corr = zeros(nreps,1);

for ii = 1:nreps
    idx = randperm(t);
    xtrain = x(idx(1:54),:);
    xtest = x(idx(55:end),:);
    
    ytrain = y(idx(1:54),:);
    ytest = y(idx(55:end),:);
    
    if sum(sum(ytrain)==0) > 0
        continue
    else
    end
    
    Rtrain = corr(xtrain,ytrain);
    
    [utrain,strain,vtrain] = svd(Rtrain,0);
    usc = xtest * utrain(:,1);
    vsc = ytest * vtrain(:,1);
    
    score_corr(ii) = corr(usc,vsc);
end
    

% loadings
vlo = corr(y,vsc);

figure;
barh(vlo)
set(gca,'YTick',1:13,'YTickLabel',labels)

% u matrix
um = zeros(n,n);
um(mask) = u(:,1);
um = um + um';

figure; imagesc(um)

[~,idx] = sortrows([ci mean(abs(um))'],[1 -2]);

figure; imagesc(um(idx,idx))

figure; plot(usc, 'r'); hold on; plot(vsc,'b')


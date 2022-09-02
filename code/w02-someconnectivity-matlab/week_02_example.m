%% go to directory 
cd('/Users/boris/Documents/1_github/Fall2021/code/w02')
% myfile is preprocessed resting state time series mapped to cortical surface (eg via fmriprep)
myFile = 'ts.mat';      
% mySurf is fsaverage5 surface template
mySurf = 'SM.mat';
% myYeo is yeo-krienen pacellation on cortical surface template
myYeo  = 'yeo.mat'; 
% myMyel is myelin map
myMyel = 'myelin.mat'

load(mySurf); 
load(myFile);
load(myYeo);
load(myMyel); 


%% --   
% 1) build correlation matrix = a functional connectome
r               = corr(ts);
z               = 0.5 * log( (1+r) ./ (1-r) ); 
z(isinf(z))     = 0; 
z(isnan(z))     = 0;
    
% display = looks unstructured
f=figure, 
    imagesc(z,[0 1]), 

%% --     
% 2) sort by communities 
% display parcellations/modules 
f=figure, surf_viewer(yeo, SM,'')

[sy, sindex] = sort(yeo); 
f=figure, 
    imagesc(z(sindex,sindex),[0 1])
 
    
%% -- 
% 3) SCA     
%    
PCC             = 3215; 
VIS             = 2748; 

f=figure;  
    surf_viewer(double(yeo==3),SM,'visual')

rmap = corr(mean(ts(:,yeo==4),2),ts); 

f=figure;  
    surf_viewer(rmap,SM,'FPN', [.2 1])
        colormap(hot);
    
f=figure;  
    surf_viewer(z(VIS,:),SM,'visual', [0 .7])
    colormap(parula);
   
f=figure;  
    surf_viewer(z(PCC,:),SM,'PCC', [0 .7])
    colormap(hot);
    
    



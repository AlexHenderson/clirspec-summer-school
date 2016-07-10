function [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs] = pccva(data,groupmembership,pcs)

% PCCVA Principal Components - Canonical Variates Analysis
% usage:
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs] = pccva(data,groupmembership);
%     [cvloadings,cvscores,cvexplained,cvs,pcloadings,pcscores,pcexplained,pcs] = pccva(data,groupmembership,pcs);
%
% input:
%     data - rows of spectra
%     groupmembership - vector of labels, one per row of data
%     pcs - (optional) number of principal components to use in the CVA
%       calculation. If not supplied then this is calculated at 95% explained
%       variance
% output:
%     cvloadings - canonical variates, directions of most variation in the data
%     cvscores - weighting of each canonical variate
%     cvexplained - percentage explained variation of each canonical variate
%     cvs - number of canonical variates (number of groups - 1)
%     pcloadings - principal component loadings, unique characteristics in the data
%     pcscores - principal component scores, weighting of each pc
%     pcexplained - percentage explained variance of each pc
%     pcs - number of principal components used
%
%   Copyright (c) 2015, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.0 June 2015

%   version 1.0 June 2015 Alex Henderson
%   initial release

%% Perform principal components analyis
[pcloadings, pcscores, pcvariances] = princomp(data, 'econ');
explained_variance = pcvariances / sum(pcvariances);
pcexplained = 100 * explained_variance;
cumulative_explained_variance = cumsum(explained_variance);

%% Determine valid PCs
% Valid PCs determined by the number required to reach 95% explained
% variance, or using the user defined number. 
if (~exist('pcs','var'))
    pcs = find((cumulative_explained_variance > 0.95), 1, 'first');
end

% Only use valid pcs
pcloadings = pcloadings(:,1:pcs);
pcscores = pcscores(:,1:pcs);

%% Determine number of valid canonical variates
% Number of cvs is number-of-groups - 1
% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    uniquegroups = unique(groupmembership, 'rows');
else
    uniquegroups = unique(groupmembership);
end
    
cvs = size(uniquegroups,1) - 1;

if (pcs < cvs)
    error('Not enough valid principal components to discriminate between the groups');
end

%% Perform canonical variates analysis
[eigenvectors,eigenvalues,percent_explained_variation] = cva(pcscores,groupmembership);

%% Generate output by mapping back to the original data
cvloadings = pcloadings * eigenvectors;
cvscores = pcscores * (eigenvectors * diag(eigenvalues));
cvexplained = percent_explained_variation;

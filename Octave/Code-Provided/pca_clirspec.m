function [pcloadings,pcscores,pcexplained] = pca_clirspec(data)

% PCA_CLIRSPEC Principal Components Analysis
% usage:
%     [pcloadings,pcscores,pcexplained] = pca_clirspec(data);
%
% input:
%     data - rows of spectra
% output:
%     pcloadings - principal component loadings, unique characteristics in the data
%     pcscores - principal component scores, weighting of each pc
%     pcexplained - percentage explained variance of each pc
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

%   There are a number of different PCA algorithms and implementations.
%   This function is named pca_clirspec to differentiate it from the other
%   possibilities. The function is essentially a wrapper round the built-in
%   princomp and pca functions, but with outputs labelled for consistency.
%

[pcloadings, pcscores, pcvariances] = princomp(data, 'econ');    
pcexplained = 100 * (pcvariances/sum(pcvariances));

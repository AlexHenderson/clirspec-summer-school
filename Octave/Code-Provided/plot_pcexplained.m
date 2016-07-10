function [figure_handle] = plot_pcexplained(pcexplained, numpcs)

% PLOT_PCEXPLAINED Plots percentage explained variance
% usage:
%     plot_pcexplained(pcexplained);
%     plot_pcexplained(pcexplained, numpcs);
%
% where:
%   pcexplained - the percentage explained variance vector from principal components analysis
%   numpcs - (optional) by default the function plots the first 20 pcs. If
%       'numpcs' is present then this determines the number of principal
%       components displayed
%   figure_handle = the figure identifier used for saving figure to disc
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

window_title = 'Percentage explained variance';
figure_handle = figure('Name',window_title,'NumberTitle','off');

if (exist('numpcs','var'))
    plot(pcexplained(1:numpcs), 'o-');
else
    plot(pcexplained(1:20), 'o-');
end

xlabel('principal component number');
ylabel('percentage explained variance');
title('Percentage explained variance');

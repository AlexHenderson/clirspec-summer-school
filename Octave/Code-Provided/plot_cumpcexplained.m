function [figure_handle] = plot_cumpcexplained(pcexplained, numpcs)

% PLOT_CUMPCEXPLAINED Plots cumulative percentage explained variance
% usage:
%     plot_cumpcexplained(pcexplained);
%     plot_cumpcexplained(pcexplained, numpcs);
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

window_title = 'Cumulative percentage explained variance';
figure_handle = figure('Name',window_title,'NumberTitle','off');

cumpcexplained = cumsum(pcexplained);

if (exist('numpcs','var'))
    plot(cumpcexplained(1:numpcs), 'o-');
else
    plot(cumpcexplained(1:20), 'o-');
end

    % Draw line indicating 95% cumulative explained variance
    axiscolour = 'k';
    hold on;
    limits = axis;
    xmin = limits(1,1);
    xmax = limits(1,2);
    plot([xmin,xmax], [95,95], axiscolour);
    hold off;

xlabel('principal component number');
ylabel('cumulative percentage explained variance');
title('Cumulative percentage explained variance');

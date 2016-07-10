function [figure_handle] = plot_pcloading(pcloadings,pc_number,pcexplained,x_values,x_label,flipx)

% PLOT_PCLOADING Plots a principal component loading of your choice
% usage:
%   plot_pcloading(pcloadings,pc_number,pcexplained,x_values,x_label);
%   plot_pcloading(pcloadings,pc_number,pcexplained,x_values,x_label,flipx);
%
% where:
%   pcloadings - the loadings matrix
%   pc_number - the number of the principal component to plot
%   pcexplained - vector of percentage explained variance
%   x_values - a vector of x_values to plot against
%   x_label - text label for the x axis
%   flipx - (optional) whether the x axis should be increasing (default) or
%      decreasing. Valid values are 1/0, y/n, Y/N with 1/y/Y meaning change
%      axis to decreasing values
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

window_title = ['Loading on PC ', num2str(pc_number)];
figure_handle = figure('Name',window_title,'NumberTitle','off');

datatoplot = pcloadings(:,pc_number);

bar(x_values, datatoplot);
if (exist('flipx','var'))
    switch (flipx)
        case 1 
            set(gca,'XDir','reverse');
        case 'y' 
            set(gca,'XDir','reverse');
        case 'Y' 
            set(gca,'XDir','reverse');
        case 0 
        case 'n' 
        case 'N' 
        otherwise
            warning('value for parameter ''flipx'' not understood, try 1 or 0');
    end
end     

hold on
xlabel(x_label);
ylabel(['loading on PC ', num2str(pc_number), ' (', num2str(pcexplained(pc_number),3), '%)']);
title(['Loading on principal component ', num2str(pc_number)]);
axis tight;
hold off

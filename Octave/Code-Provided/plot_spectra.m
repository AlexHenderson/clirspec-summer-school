function [figure_handle] = plot_spectra(data,x_values,x_label,y_label,flipx)

% PLOT_SPECTRA Plot one or more spectra
% usage:
%     plot_spectra(data,x_values,x_label,y_label);
%     plot_spectra(data,x_values,x_label,y_label,flipx);
%
% where:
%   data - a matrix of spectra (in rows)
%   x_values - a vector of x_values to plot against
%   x_label - text label for the x axis
%   y_label - text label for the y axis
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

figure_handle = figure;
plot(x_values,data);

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

xlabel(x_label);
ylabel(y_label);
axis tight;

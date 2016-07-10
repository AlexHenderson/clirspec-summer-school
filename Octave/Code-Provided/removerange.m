function [reduced_data,reduced_x_values] = removerange(data,x_values,x_low,x_high)

% REMOVERANGE Removes a spectral range from the data
% usage:
%     [reduced_data,reduced_x_values] = removerange(data,x_values,x_low,x_high);
%
% input:
%   data - a matrix of spectra (in rows)
%   x_values - a vector of x_values to plot against
%   x_low - low cutoff for removed range, or '0' if from the beginning of the data
%   x_high - high cutoff for removed range, or 'inf' if to the end of the data
% output:
%     reduced_data - original data without the requested range
%     reduced_x_values - original x_values without the requested range
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

%% Swap low and high values if required
if (x_low > x_high)
    temp = x_low;
    x_low = x_high;
    x_high = temp;
end

%% Calculate the index value of the low value
if (x_low == 0)
   x_low_idx = 1;
else
    [not_required,x_low_idx] = min(abs(x_values - x_low));
end

%% Remove the required range
if (isinf(x_high))
    reduced_data = data(:,x_low_idx:end);
    reduced_x_values = x_values(x_low_idx:end);
else
    [not_required,x_high_idx] = min(abs(x_values - x_high));
    reduced_data = data(:,x_low_idx:x_high_idx);
    reduced_x_values = x_values(x_low_idx:x_high_idx);
end


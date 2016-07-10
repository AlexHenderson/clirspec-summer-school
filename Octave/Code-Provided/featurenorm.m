function fn_data = featurenorm(data,feature,x_values)

% FEATURENORM Feature normalisation
% usage:
%     fn_data = featurenorm(data,feature,x_values);
%     fn_data = featurenorm(data,[feature_low,feature_high],x_values);
%
% input:
%     data - rows of spectra
%     feature - x value, or a range of x values ([low,high]), to normalise
%        across the data set
%     x_values - vector, within which the feature can be found
% output:
%     fn_data - feature normalised version of data
%
%   Where the feature is a single value, this will be set to 1 across the
%   data and other values scaled appropriately. Where feature is a pair of
%   values (a vector of 2 values, low and high), the median of these will
%   be used to calculate the feature intensity. 
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

switch (numel(feature))
    case 1
        % determine the index value of the required feature
        %feature_index = min(abs(xvalues - feature));
        [not_required,feature_index] = min(abs(x_values - feature));

        % intensity of each spectrum at that feature index value
        feature_intensity = data(:,feature_index);

    case 2
        % ensure that the feature range is ascending
        feature = sort(feature);
        
        % determine the index values of the required feature range
        %feature_index_low = min(abs(xvalues - feature(1)));
        [not_required,feature_index_low] = min(abs(x_values - feature(1)));
        %feature_index_high = min(abs(xvalues - feature(2)));
        [not_required,feature_index_high] = min(abs(x_values - feature(2)));
        
        % median intensity of each spectrum in the feature index range
        feature_intensity = median(data(:,feature_index_low:feature_index_high));

    otherwise
        error('parameter ''feature'' should be either a single value or a vector of two values');
end

% adjust the intensity of each spectrum (row) such that the required
% feature has a value of 1. 
fn_data = (data - feature_intensity) + 1;

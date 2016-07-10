function [scaled_data,error_index] = featurescalemaxmed(data,x_values,feature_max,feature_min)

% FEATURESCALEMAXMED Feature scaling, maximum and median
% usage:
%   scaled_data = featurescalemaxmed(data,x_values,feature_max);
%   scaled_data = featurescalemaxmed(data,x_values,feature_max,feature_min);
%
% input:
%   data - rows of spectra
%   x_values - vector, within which the feature(s) can be found
%   feature_max - x value, or a range of x values ([low,high]), that will
%     be rescaled to intensity 1. Where feature_max is a 2-value vector,
%     the MAXIMUM intensity within that spectral range will be used. 
%   feature_min - (optional) x value, or a range of x values ([low,high]),
%     that will be rescaled to intensity 0. Where feature_max is a 2-value
%     vector, the MEDIAN intensity within that spectral range will be used.
%     If not provided then the absolute minimum of each original spectrum
%     will be defined as zero intensity.
% output:
%   scaled_data - feature scaled version of data
%   error_index - a list of the spectra where the minimum intensity is
%     higher than the maximum intensity
%
%   Where the feature_xxx is a single value, this will be set to 1 across
%   the data and other values scaled appropriately. Where feature_xxx is a
%   pair of values (a vector of 2 values, low and high), the MAXIMUM of the
%   feature_max range and the MEDIAN of the feature_min range will be used
%   to calculate the feature intensity. The philosophy here is to allow for
%   the feature_max range to span the expected limits of a peak where we
%   are interested in the maximum intensity in that range, while the
%   feature_min range will span a region of noise.
%
%   Where the minimum is higher than the maximum, the spectrum will be set
%   to a vector of NaN values and the index number of the spectrum reported
%   as a warning.
%
%   Copyright (c) 2015-2016, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.2 January 2016

%   version 1.2 January 2016 Alex Henderson
%   Fixed error when using zero as a feature_min value
%   version 1.1 January 2016 Alex Henderson
%   Fixed error whereby the normalisation wasn't right
%   version 1.0 October 2015 Alex Henderson
%   initial release

%% Get some initial parameters
[numspectra,numdatapoints] = size(data);

%% Deal with the feature_max parameter
switch (numel(feature_max))
    case 1
        % Determine the index value of the required feature
        [not_required,feature_max_index] = min(abs(x_values - feature_max));

        % Intensity of each spectrum at that feature index value
        feature_max_intensity = data(:,feature_max_index);

    case 2
        % Ensure that the feature range is ascending
        feature_max = sort(feature_max);
        
        % Determine the index values of the required feature range
        [not_required,feature_max_index_low] = min(abs(x_values - feature_max(1)));
        [not_required,feature_max_index_high] = min(abs(x_values - feature_max(2)));
        
        % Maximum intensity of each spectrum in the feature index range
        feature_max_intensity = max(data(:,feature_max_index_low:feature_max_index_high),[],2);

    otherwise
        error('parameter ''feature_max'' should be either a single value or a vector of two values');
end

%% Deal with the feature_min parameter
if (exist('feature_min','var'))
    switch (numel(feature_min))
        case 1
            % Determine the index value of the required feature
            [not_required,feature_min_index] = min(abs(x_values - feature_min));

            % Intensity of each spectrum at that feature index value
            feature_min_intensity = data(:,feature_min_index);

        case 2
            % Ensure that the feature range is ascending
            feature_min = sort(feature_min);

            % Determine the index values of the required feature range
            [not_required,feature_min_index_low] = min(abs(x_values - feature_min(1)));
            [not_required,feature_min_index_high] = min(abs(x_values - feature_min(2)));

            % Median intensity of each spectrum in the feature index range
            feature_min_intensity = median(data(:,feature_min_index_low:feature_min_index_high),2);

        otherwise
            error('parameter ''feature_min'' should be either a single value or a vector of two values');
    end
else
    feature_min_intensity = zeros(numspectra,1);
end
    
% Adjust the intensity of each spectrum (row) such that the feature_max
% intensity will be 1 and the feature_min intensity will be 0. All other
% spectral points are scaled accordingly.

feature_max_intensity_mat = repmat(feature_max_intensity,1,numdatapoints);
feature_min_intensity_mat = repmat(feature_min_intensity,1,numdatapoints);

scaled_data = (data - feature_min_intensity_mat) ./ (feature_max_intensity_mat - feature_min_intensity_mat);

%% Manage the situation where the minimum is higher than the maximum
% Set the offending spectra to NaNs and report to the user

error_index = feature_max_intensity - feature_min_intensity;
error_index(error_index > 0) = 0;
error_index(error_index ~= 0) = 1;

numbadspectra = sum(error_index);

if (numbadspectra > 0)
    % Set those spectra to NaN
    NaN_spectra = NaN(numbadspectra,numdatapoints);
    error_spectra = find(error_index);
    scaled_data(error_spectra,:) = NaN_spectra;
    if (sum(error_index) == size(data,1))
        message = 'All spectra have a feature minimum intensity higher than the feature maximum intensity';
    else
        message = 'The following spectra have a feature minimum intensity higher than the feature maximum intensity: ';
        message = [message,mat2str(error_spectra)];
    end
    warning(message);
    error_index = error_spectra;
end

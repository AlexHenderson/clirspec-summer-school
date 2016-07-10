function vn_data = vectornorm(data)

% VECTORNORM Vector normalisation
% usage:
%     vn_data = vectornorm(data);
%
% input:
%     data - rows of spectra
% output:
%     vn_data - vector normalised version of data
%
%   The data is normalised such that the vector length in N-d space (where
%   N is the number of data points in each row) is unity (1).
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

% Calculates the following:
%   1. Squares each variable in 'data'.
%   2. Sums these squares and calculates the square root of the result.
%      This is the 'vector length'.
%   3. Divides each of the original data variables by the vector length.
%   4. Outputs the result to a MATLAB variable

squares = data .^ 2;                % square of each variable ([n,m])
sum_of_squares = sum(squares, 2);   % sum of the squares along the rows ([n,1])

divisor = sqrt(sum_of_squares);     % ([n,1])

divisor(divisor == 0) = 1;          % avoid divide by zero error

% Generate a sparse matrix where the diagonal is of the inverse of the divisor
multiplier = 1 ./ divisor;
multiplierdiag = spdiags(multiplier,0,length(multiplier),length(multiplier));

data = multiplierdiag * data; % divide the data by the vector length ([n,m])

vn_data = data;

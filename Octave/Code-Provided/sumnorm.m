function sn_data = sumnorm(data)

% SUMNORM Sum normalisation
% usage:
%     sn_data = sumnorm(data);
%
% input:
%     data - rows of spectra
% output:
%     sn_data - sum normalised version of data
%
%   The data is normalised such that the sum of each spectrum (row) is
%   unity (1). 
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

divisor = sum(data,2);

divisor(divisor == 0) = 1;  % avoid divide by zero error

% Generate a sparse matrix where the diagonal is of the inverse of the divisor
multiplier = 1 ./ divisor;
multiplierdiag = spdiags(multiplier,0,length(multiplier),length(multiplier));

data = multiplierdiag * data; % divide the data by the vector length ([n,m])

sn_data = data;

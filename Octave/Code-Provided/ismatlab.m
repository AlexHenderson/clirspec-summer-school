function output = ismatlab()

% ISMATLAB Reports whether this function is running on the MATLAB platform
% Version 1.0
%
% Usage: 
%   output = ismatlab();
%
% Returns:  'output' True if this function is running on the MATLAB
%                       platform. False otherwise. 
%
% Both MATLAB and Octave can execute MATLAB code. This function helps to
% identify the current platform. See also ISOCTAVE
%
%   Copyright (c) 2015, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

% Version 1.0  Alex Henderson, June 2015
%   Initial release

output = false;

% Both MATLAB and Octave have a function 'ver'
infostruct = ver();
for i = 1:length(infostruct)
    if (strcmp(infostruct(i).Name, 'MATLAB'))
        output = true;
        return;
    end
end
    
function [names, counts]=countclasses(classlist)

% function: countclasses
%           Counts the number of entries in each class
% version:  1.0
%
% [names, counts]=countclasses(classlist);
%
% where:
%   classlist - a collection of numbers or labels that form groups
%   names - the names of each unique group, either as numbers or labels
%   counts - the number of each group in classlist
%
% The names list and the counts list are matched, that is, the second entry
% in counts is the number of the second entry in names. 
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 1.0 April 2012, initial release

classlist=sortrows(classlist);

% [names, range]=unique(classlist, 'rows', 'first');
% [names, range(:,2)]=unique(classlist, 'rows', 'last');

% Unique rows doesn't work for cell arrays in Octave, so need two versions of the
% code here. 
if (size(classlist,2) > 1)
    [names, range] = unique(classlist, 'rows', 'first');
    [names, range(:,2)] = unique(classlist, 'rows', 'last');
else
    [names, range] = unique(classlist, 'first');
    [names, range(:,2)] = unique(classlist, 'last');
end

counts = (range(:,2) - range(:,1)) + 1;

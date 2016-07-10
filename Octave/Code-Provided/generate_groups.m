function groupmembership = generate_groups(varargin)

% GENERATE_GROUPS Creates a group membership list for categorical variables
% usage:
%   groupmembership = generate_groups(label1,count1,label2,count2,...);
%
% where:
%   Labels, and counts of these labels, are given in pairs. Labels can be
%   numeric or character strings and need not be of a the same length. The
%   label/count pairs should reflect the structure of the data set they
%   will be used to describe
%   Examples:
%       groupmembership = generate_groups('alice',3,'bob',6,'charlie',5);
%       groupmembership = generate_groups(205,3,192,6,227,5);
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

if (rem(nargin,2) == 1)
    error('Group labels and membership counts must be in pairs');
end

groups = reshape(varargin,2,[]);
groups = groups';

numgroups = size(groups,1);

groupmembership = {};
for i = 1:numgroups
    label = num2str(groups{i,1});
    count = groups{i,2};
    groupentries = repmat(label,count,1);
    groupcells = cellstr(groupentries);
    groupmembership = vertcat(groupmembership,groupcells);
end

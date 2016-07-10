function [cm]=confusionmatrix(observed, expected)

% function: confusionmatrix
%           Generates a confusion matrix from the observed and expected data
% version:  1.0
%
% [cm]=confusionmatrix(observed, expected);
%
% where:
%   observed - the group the sample was found to be in (a list of numbers)
%   expected - the group the sample should have been in (a list of numbers)
%   cm       - the confusion matrix
%
% A confusion matrix consists of a table where the columns represent the
% 'truth' and the rows represent the 'observed facts'. 
% For example; say we have 20 samples that should be members of group 1,
% but 5 were observed to be in group 2 then we will have a matrix with '15'
% being in position (1,1) and '5' being in position (2,1). The sum of
% column 1 will add up to 20 (the total expected for group 1). 
%
% The major diagonal (top left to bottom right) contains the number of
% correctly classified samples for each group.
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 1.0 April 2012, initial release

classes=unique(expected);
numuniqueclasses=size(classes,1);

cm=zeros(numuniqueclasses);

results=[observed, expected];

for currentclass=1:numuniqueclasses
%     classresult=results((results(:,2) == classes(currentclass)), :);
    first = char(results(:,2));
    second = char(classes(currentclass));
    classresult=results((first == second), :);
    [classid, counts]=countclasses(classresult(:,1));
    cm(classid,classes(currentclass))=counts;
end

function [distances, nearestgroup, correctlyclassified, confusion]=getdist(traineddata, trainedclassmembership, testdata, testclassmembership)

% function: getdist
%           Calculates the Mahalanobis distance of a collection of test
%           data from a collection of training data
% version:  1.0
%
% [distances, nearestgroup, correctlyclassified, confusion]=getdist(traineddata, trainedclassmembership, testdata, testclassmembership);
%
% where:
%   traineddata - a collection of spectra in rows making up the target
%                 groups
%   trainedclassmembership - a list of the specific class membership of
%                            each trained row as numbers
%   testdata - a collection of spectra in rows for which we want to
%              determine the distances
%   testclassmembership - a list of the specific class membership of each
%                         test row as numbers
%
%   distances - matrix where each row contains the distances of the
%               corresponding test spectrum from each of the groups (cols)
%   nearestgroup - the index number of the group that the test spectrum is
%                  closest to
%   correctlyclassified - whether the test spectrum is correctly classified
%                         (1) or not (0)
%   confusion - confusion matrix of the results
%
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 1.0 April 2012, initial release

% uniquegroups=unique(trainedclassmembership, 'rows');
if (size(trainedclassmembership,2) > 1)
    [uniquetrainedgroups, not_required, groupindex] = unique(trainedclassmembership, 'rows');
else
    [uniquetrainedgroups, not_required, groupindex] = unique(trainedclassmembership);
end

if (size(testclassmembership,2) > 1)
    [uniquetestgroups, not_required, testgroupindex] = unique(testclassmembership, 'rows');
else
    [uniquetestgroups, not_required, testgroupindex] = unique(testclassmembership);
end


distances=zeros(size(testdata,1), size(uniquetrainedgroups,1));

for g = 1:size(uniquetrainedgroups,1)
%     thisgroup=uniquetrainedgroups(g,:);
%     groupdata=traineddata(trainedclassmembership == thisgroup,:);
%     thisgroup = uniquetrainedgroups((groupindex == g),:);
    groupdata = traineddata((groupindex == g),:);
%     groupdata = traineddata((trainedclassmembership == thisgroup),:);
    [r,c] = size(testdata);
    distances(:,g)=mahal(testdata, groupdata);
end

[mindist,nearest]=min(distances, [], 2);
nearestgroup=uniquetrainedgroups(nearest);
% correctlyclassified = (nearestgroup == testclassmembership);
correctlyclassified = (nearest == testgroupindex);

confusion=confusionmatrix(nearestgroup, testclassmembership);

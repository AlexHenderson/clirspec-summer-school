function [folds, foldsclass, foldsoriginalindex]=stratifykfold(data, groupmembership, k)

% function: stratifykfold
%   Stratification of data in a class structure into k disjoint sets
% version:  2.0
%
% [folds, foldsclass, foldsoriginalindex]=stratifykfold(data, groupmembership, k);
%
% where:
%   data - a collection of spectra in rows
%   groupmembership - a list of the specific class membership of each row as
%             numbers or labels
%   k - the number of folds required
%
%   cell arrays of...
%   folds - 1/k of each class put into k groups
%   foldsclass - class membership of the samples in the k groups
%   foldsoriginalindex - the original index number of the data
%
%   Re-samples the data matrix to generate k subsets (k folds) where each
%   group is (roughly) represented equally. 
%   The data in the output is in the same sort order as the input.  
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 1.0 April 2012: Initial release. 
%   version 1.1 April 2012: Added check for minimum class membership per
%   fold. 
%   version 2.0 April 2012: Changed method of allocating the data between
%   the folds to make the proportions more stable. 

% get the index numbers for the data
[datarows, datacols]=size(data);
dataindex=(1:datarows)';

% find the number of unique groupmembership
%uniquegroupmembership=unique(groupmembership, 'rows');
% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    [uniquegroupmembership, not_required, groupindex] = unique(groupmembership, 'rows');
else
    [uniquegroupmembership, not_required, groupindex] = unique(groupmembership);
end
[numgroupmembership,cols]=size(uniquegroupmembership);

% check to see we have enough samples per class to fulfill these k folds
[cnames,ccount]=countclasses(groupmembership);
[smallestclassnumber,smallestclassid]=min(ccount);
smallestclassname=groupmembership(smallestclassid,:);

if k > smallestclassnumber
    if(~ischar(smallestclassname))
        smallestclassname=num2str(smallestclassname);
    end
    error(['Number of folds (k=', num2str(k) , ') is greater than the number in the smallest class: ', smallestclassname, '(', num2str(smallestclassnumber),')']);
end

% make space for the results
folds=cell(k, 1);
foldsclass=cell(k, 1); 
foldsoriginalindex=cell(k, 1);

% For each class we identify the spectra (data rows) that correspond to
% that class and retrieve their index numbers. Next we generate a random
% permutation of these index numbers. Now that the spectra from this class
% are randomly ordered we can simply rotate through each fold in turn and
% place the next (random) spectrum there.
% When the data have been allocated to their fold they are sorted back to
% the original order.
% The folds will have different sizes, but the proportion of each class
% within them should be the same. 

for i=1:numgroupmembership
    % get data indicies for this class
    
%     thisclassmask=ismember(groupmembership, uniquegroupmembership(i,:), 'rows');
    
    % Unique rows doesn't work for cell arrays in Octave, so need two versions of the
    % code here. 
    if (size(groupmembership,2) > 1)
        thisclassmask=ismember(groupmembership, uniquegroupmembership(i,:), 'rows');
    else
        thisclassmask=ismember(groupmembership, uniquegroupmembership(i,:));
    end

    thisclassdataindex=dataindex(thisclassmask,:);
    
    % get some dimensions of this subset of the data
    numsamplesinclass = length(thisclassdataindex);
    
    % randomly reorder the class index numbers
    randindex=randperm(numsamplesinclass);
    thisclassrandindex=thisclassdataindex(randindex);
    
    % for each class, cycle through the folds inserting one spectrum per
    % loop
    loop=0;
    while(loop < length(thisclassrandindex))

        % identify the current fold number
        foldnumber=mod(loop,k)+1;
        % need to increment loop variable since MATLAB is 1-based
        loop=loop+1;
                
        % record the data 
        folds{foldnumber,1} = vertcat(folds{foldnumber,1}, data(thisclassrandindex(loop),:));
        % record the index of the original data 
        foldsoriginalindex{foldnumber,1} = vertcat(foldsoriginalindex{foldnumber,1}, thisclassrandindex(loop));
        % record the class identifier
        foldsclass{foldnumber,1} = vertcat(foldsclass{foldnumber,1}, uniquegroupmembership(i,:));
    end
end

% sort data and index within each fold into original order
for f=1:k
    [foldsoriginalindex{f,1}, index] = sortrows(foldsoriginalindex{f,1});
    folds{f,1} = folds{f,1}(index,:);
end

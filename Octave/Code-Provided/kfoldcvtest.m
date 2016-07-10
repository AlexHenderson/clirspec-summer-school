function [result, distances, confusion, foldinfo, pccvaoutcomes, pccvadata] = kfoldcvtest(data, numfolds, classmembership, classnames, pcs)

% function: kfoldcvtest
%           k-fold cross-validation using PC-CVA
% version:  1.0
%
% [result, distances, confusion, foldinfo, pccvaoutcomes, pccvadata] = kfoldcvtest(data, numfolds, classmembership, classnames, pcs)
%
% where:
%   data - a collection of spectra in rows
%   numfolds - the number of folds to calculate (k)
%   classmembership - a list of the specific class membership of each row as
%                       numbers
%   classnames - a list of the specific class label of each row
%   pcs - the appropriate number of pcs to use. This can be determined
%           using pressrsstest.m
%
%   result - four element row vector (one row per fold): 
%               number correctly classified; 
%               number incorrectly classified; 
%               number of samples in the test set; 
%               percentage correctly classified.
%   distances - Mahalanobis distance of each test spectrum (row) from each
%               group centre (one cell per fold)
%   confusion - confusion matrix. Number correctly classified is on the
%               major diagonal (one cell per fold)
%   foldinfo  - the k-folds of data and associated memberships generated
%               during the test
%   pccvaoutcomes - results from the PC-CVA analysis (one cell per fold)
%   pccvadata - data used to generate the results from the PC-CVA analyis
%               (one cell per fold)
%
%   A plot is generated for the first fold only. 
%
%   DO NOT USE AUTOSCALED DATA (yet). 
%   THE PROJECTION OF TEST DATA INTO THE CVA-SPACE DOESN'T HANDLE IT.
%
%   k-fold cross-validation is sampling without replacement. It can be
%   considered as either a multiple holdout or a coarse leave-one-out
%   cross-validation approach. 
%
%   If we have N spectra we randomly apportion these across k collections
%   (folds), such that no spectrum appears in more than one fold. We now
%   have k collections of spectra. For each collection we take that
%   collection as a test set and pool the remaining collections to form
%   a training set. PC-CVA is then performed and the results noted. Next
%   we move to the second collection and take that as a test set, pooling
%   all other collections as a training set. Once all collections have
%   acted as a test set we have k results and these can then be averaged. 
%
%   This routine uses stratification to generate the folds. There will be
%   an error if a class is not represented in the training or test sets.
%
%   A model is generated using the training data and requested number of
%   principal components followed by canonical variates analysis. The
%   test set is projected into the model and the Mahalanobis distance of
%   each test spectrum from each group centre is calculated. Correct
%   classification is when a test spectrum has the smallest distance to the
%   group it should (a priori) be a member of. Incorrect classification is
%   when it is nearer to a different group. The actual distance isn't
%   considered, only the magnitude of the distance. 
%   This is repeated numfolds times (k). 
%
%   Copyright (c) April 2012, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 

%   version 1.0 April 2012, initial release


[folds, foldsclass, foldsoriginalindex]=stratifykfold(data, classmembership, numfolds);

foldinfo.folds=folds;
foldinfo.foldsclass=foldsclass;
foldinfo.foldsoriginalindex=foldsoriginalindex;

maxclassnum=max(classmembership);

result=zeros(numfolds,2);
distances=cell(numfolds,1);
confusion=zeros(maxclassnum,maxclassnum,numfolds);
pccvaoutcomes=cell(numfolds,1);
pccvadata=cell(numfolds,1);
firstpass=1;

[datarows,datacols]=size(data);

for rep=1:numfolds
    
    % get the test data from this fold
    testset=folds{rep,1};
    testindex=ismember(1:datarows, foldsoriginalindex{rep,1});
    testnames=classnames(testindex,:);
    testmembership=classmembership(testindex,:);
    
    % get the training data as everything that is not in the test set
    trainingindex=~testindex;
    trainingset=data(trainingindex,:);
    trainingnames=classnames(trainingindex,:);
    trainingmembership=classmembership(trainingindex,:);
    
    if (firstpass == 1)
        [repoutcome,repdata]=pcdfa(trainingset, trainingnames, trainingmembership, testset, testnames, pcs, 'kfold', 1);
        firstpass = 0;
    else
        [repoutcome,repdata]=pcdfa(trainingset, trainingnames, trainingmembership, testset, testnames, pcs, 'kfold', 0);
    end
    pccvaoutcomes{rep,1}=repoutcome;
    pccvadata{rep,1}=repdata;
    
    [dist, nearest, correctlyclassified, cm]=getdist(repoutcome.dfascores, trainingmembership, repoutcome.dfatestvars, testmembership);
    distances{rep,1}=dist;
    confusion(:,:,rep)=cm;

    result(rep,1)=sum(correctlyclassified);
    result(rep,2)=sum(~correctlyclassified);
end
result(:,3)=sum(result,2);
result(:,4)= 100 * (result(:,1) ./ result(:,3)); % percentage correctly classified

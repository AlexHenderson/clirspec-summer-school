function [figure_handle] = plot_cvscores(cvscores,cv_x,cv_y,cvexplained,groupmembership, histogram_bar_width)

% PLOT_CVSCORES Plots canonical variate scores of your choice
% usage:
%     plot_cvscores(cvscores,cv_x,cv_y,cvexplained,groupmembership);
%     plot_cvscores(cvscores,cv_x,cv_y,cvexplained,groupmembership,histogram_bar_width);
%
% where:
%   cvscores - the scores matrix from pccva.m
%   cv_number_x - the number of the canonical variate to plot on the x axis
%   cv_number_y - the number of the canonical variate to plot on the y axis
%   cvexplained - vector of percentage explained variation from pccva.m
%   groupmembership - vector of labels, one per row of data
%   histogram_bar_width - (optional, default = 4) the display width of the histogram bars when
%       plotting a two-group scores plot
%   figure_handle = the figure identifier used for saving figure to disc
%
%   If there are only two groups there will only be a single canonical
%   variate. In this case the values of cv_number_x and cv_number_y are
%   ignored and a histogram of the single canonical variate is plotted. 
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

colours = 'bgrcmky';
colours_as_map = [0,0,1; 0,1,0]; % blue, green for single CV histogram
axiscolour = 'k';
decplaces = 3;

if (~exist('histogram_bar_width','var'))
    histogram_bar_width = 4;
end

% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    [uniquegroups, not_required, groupindex] = unique(groupmembership, 'rows');
else
    [uniquegroups, not_required, groupindex] = unique(groupmembership);
end

cvs = size(uniquegroups,1) - 1;

if (cvs > 1)
    
    if (cv_x == cv_y)
        error('Attempting to plot the same data on both x and y axes.');
    end
    
    if ((cv_x > cvs) || (cv_y > cvs))
        error('Attempting to plot a canonical variate that doesn''t exist (higher than number of groups - 1).');
    end
    
    
    window_title = ['Scores on canonical variates ', num2str(cv_x), ' and ', num2str(cv_y)];
    figure_handle = figure('Name',window_title,'NumberTitle','off');

    gscatter(cvscores(:,cv_x), cvscores(:,cv_y), groupmembership, colours, 'o');
    axis tight;

    xlabel(['score on CV ', num2str(cv_x), ' (', num2str(cvexplained(cv_x),decplaces), '%)']);
    ylabel(['score on CV ', num2str(cv_y), ' (', num2str(cvexplained(cv_y),decplaces), '%)']);
    title(['Scores on canonical variates ', num2str(cv_x), ' and ', num2str(cv_y)]);
    if (ismatlab())
      legend('Location','Best');
    else
      legend();
    end      
    
    % Draw lines indicating zero x and y
    hold on;
    limits = axis;
    xmin = limits(1,1);
    xmax = limits(1,2);
    ymin = limits(1,3);
    ymax = limits(1,4);
    plot([0,0], [0,ymax], axiscolour);
    plot([0,0], [0,ymin], axiscolour);
    plot([0,xmax], [0,0], axiscolour);
    plot([0,xmin], [0,0], axiscolour);
    hold off;
    
else
    % Only have one CV to plot, so use a histogram
    % Note that in this case, cvscores should be a vector
    
    window_title = 'Score on canonical variate 1';
    figure('Name',window_title,'NumberTitle','off');

    firstgroup = cvscores(groupindex == 1);
    secondgroup = cvscores(groupindex == 2);
    
    % Add a tiny amount to the upper limit for edges so that the
    % largest value will fall inside the limit rather than creating a
    % large bin to be just inside. Not really sure if this makes any
    % difference since MATLAB is 'prettifying' the output anyway

    minscore = min(cvscores);
    maxscore = max(cvscores);
    extrabucket = (maxscore - minscore) / length(cvscores);
    edges = linspace(minscore, maxscore + extrabucket, length(cvscores));

    [bincounts1] = histc(firstgroup,edges);
    [bincounts2] = histc(secondgroup,edges);
    all_bincounts = [bincounts1,bincounts2];
    bar(edges,all_bincounts,histogram_bar_width,'histc');  
    colormap(colours_as_map);
    axis tight;

    xlabel(['score on CV 1', ' (', num2str(cvexplained(1),decplaces), '%)']);
    ylabel('counts per bin');
    title('Score on canonical variate 1');
    
    if (ismatlab())
      legend(num2str(uniquegroups(1,:)), num2str(uniquegroups(2,:)),'Location','Best');
    else
      legend(num2str(uniquegroups(1,:)), num2str(uniquegroups(2,:)));
    end      

    % Draw lines indicating zero x and y
    hold on;
    limits = axis;
    xmin = limits(1,1);
    xmax = limits(1,2);
    ymax = limits(1,3);
    ymin = limits(1,4);
    plot([0,0], [0,ymax], axiscolour);
    plot([0,0], [0,ymin], axiscolour);
    plot([0,xmax], [0,0], axiscolour);
    plot([0,xmin], [0,0], axiscolour);
    hold off;    
end

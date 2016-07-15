function [figure_handle] = plot_pcscores(pcscores,pc_x,pc_y,pcexplained,groupmembership,fontsize,fontweight)

% PLOT_PCSCORES Plots principal component scores of your choice
% usage:
%     plot_pcscores(pcscores,pc_x,pc_y,pcexplained);
%     plot_pcscores(pcscores,pc_x,pc_y,pcexplained,groupmembership);
%     plot_pcscores(pcscores,pc_x,pc_y,pcexplained,groupmembership,fontsize);
%     plot_pcscores(pcscores,pc_x,pc_y,pcexplained,groupmembership,fontsize,fontweight);
%
% where:
%   pcscores - the scores matrix
%   pc_x - the number of the principal component to plot on the x axis
%   pc_y - the number of the principal component to plot on the y axis
%   pcexplained - vector of percentage explained variance
%   groupmembership - (optional) vector of labels, one per row of data
%   fontsize - (optional) set to change the font size
%   fontweight - (optional) set to change the font weight ('normal'
%   (default) | 'bold')
%   figure_handle = the figure identifier used for saving figure to disc
%
%   Use [] as a placeholder for default values, if later values are
%   specified
%
%   If groupmembership is provided, the scores will be plotted in colours
%   relating to their group
%
%   Copyright (c) 2015, Alex Henderson 
%   Contact email: alex.henderson@manchester.ac.uk
%   Licenced under the GNU General Public License (GPL) version 3
%   http://www.gnu.org/copyleft/gpl.html
%   Other licensing options are available, please contact Alex for details
%   If you use this file in your work, please acknowledge the author(s) in
%   your publications. 
%
%   version 1.1 April 2016

%   version 1.1 April 2016 Alex Henderson
%   Added fontsize and fontweight options
%   version 1.0 June 2015 Alex Henderson
%   initial release

colours = 'bgrcmky';
axiscolour = 'k';
decplaces = 3;

window_title = ['Scores on principal components ', num2str(pc_x), ' and ', num2str(pc_y)];
figure_handle = figure('Name',window_title,'NumberTitle','off');

if (exist('groupmembership','var') && ~isempty(groupmembership))
    gscatter(pcscores(:,pc_x), pcscores(:,pc_y), groupmembership, colours, 'o');
%    gscatter(pcscores(:,pc_x), pcscores(:,pc_y), groupmembership, colours);
else
%    scatter(pcscores(:,pc_x), pcscores(:,pc_y), 'o');
    scatter(pcscores(:,pc_x), pcscores(:,pc_y));
end    

if (exist('fontsize','var') && ~isempty(fontsize))
    if (ismatlab())
      set(gca,'FontSize',fontsize)
    else
        % Not sure if Octave does this, so assume 'yes'
      set(gca,'FontSize',fontsize)
    end      
end    

if (exist('fontweight','var') && ~isempty(fontweight))
    if (ismatlab())
      set(gca,'FontWeight',fontweight)
    else
        % Not sure if Octave does this, so assume 'yes'
      set(gca,'FontWeight',fontweight)
    end      
end    


xlabel(['score on PC ', num2str(pc_x), ' (', num2str(pcexplained(pc_x),decplaces), '%)']);
ylabel(['score on PC ', num2str(pc_y), ' (', num2str(pcexplained(pc_y),decplaces), '%)']);
title(['Scores on principal components ', num2str(pc_x), ' and ', num2str(pc_y)]);

if (exist('groupmembership','var'))
    if (ismatlab())
      legend('Location','Best');
    else
      legend();
    end      
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


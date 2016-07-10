function [figure_handle] = plot_group_spectra(data,x_values,x_label,y_label,groupmembership,requestedgroups,flipx)

% PLOT_GROUP_SPECTRA Plot spectra coloured by group membership 
% usage:
%     plot_group_spectra(data,x_values,x_label,y_label,groupmembership,requestedgroups);
%     plot_group_spectra(data,x_values,x_label,y_label,groupmembership,requestedgroups,flipx);
%
% where:
%   data - a matrix of spectra (in rows)
%   x_values - a vector of x_values to plot against
%   x_label - text label for the x axis
%   y_label - text label for the y axis
%   groupmembership - vector of labels, one per row of data
%   requestedgroups - vector of labels of groups to plot
%   flipx - (optional) whether the x axis should be increasing (default) or
%      decreasing. Valid values are 1/0, y/n, Y/N with 1/y/Y meaning change
%      axis to decreasing values
%   figure_handle = the figure identifier used for saving figure to disc
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

%% Determine number of groups and valid outputs
% Unique rows doesn't work for cell arrays, so need two versions of the
% code here. 
if (size(groupmembership,2) > 1)
    [uniquegroups, not_required, groupindex] = unique(groupmembership, 'rows');
else
    [uniquegroups, not_required, groupindex] = unique(groupmembership);
end

numgroups = size(uniquegroups,1);

requested_group_index = find(ismember(uniquegroups,requestedgroups));
num_requested_groups = length(requested_group_index);

if (num_requested_groups == 0)
    error('No groups matched. ''requestedgroups'' should be a case sensitive match if using character strings.');
end

%% Manage colours
% Define colours and ensure we repeat these if the number of groups is
% larger than the number of colours available
colours = 'bgrcmky';
colours = repmat(colours,1,ceil(numgroups / length(colours)));

%% Define some storage for the legend info
legend_text = {num_requested_groups};
legend_counter = 1;
group_line_handles = [];

%% Plot groups in colour
figure_handle = figure;
hold on;
for g = 1:numgroups
    if (ismember(g,requested_group_index))
        thisgroup = data((groupindex == g),:);
        plot_handles = plot(x_values,thisgroup,colours(g));
        % get the first line from this group to colour the legend entry
        group_line_handles = vertcat(group_line_handles,plot_handles(1));
        
        if (iscell(uniquegroups))
            legend_text{legend_counter} = uniquegroups{g,:};
        else
            legend_text{legend_counter} = num2str(uniquegroups(g,:));
        end
        
        legend_counter = legend_counter + 1;
    end
end
hold off;

%% Reverse the x axis if required
if (exist('flipx','var'))
    switch (flipx)
        case 1 
            set(gca,'XDir','reverse');
        case 'y' 
            set(gca,'XDir','reverse');
        case 'Y' 
            set(gca,'XDir','reverse');
        case 0 
        case 'n' 
        case 'N' 
        otherwise
            warning('value for parameter ''flipx'' not understood, try 1 or 0');
    end
end

%% Add labels and tidy up
xlabel(x_label);
ylabel(y_label);
axis tight;

if (ismatlab())
  legend(group_line_handles,legend_text,'Location','Best');
else
  legend(group_line_handles,legend_text);
end      

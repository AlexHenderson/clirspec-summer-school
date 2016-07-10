% CLIRSPEC Summer School 2015
% Multivariate Analysis Workshop

% Load data
data = load('C:\CLIRSPEC\Summer-School\Octave\Data\utidata.txt');
data = fliplr(data);
wavenumbers = linspace(600, 4000, size(data, 2));
groupmembership = generate_groups('E. coli',20,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',20,'E. coli',48,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',28);

% Show the list of unique group titles/labels
disp(char(unique(groupmembership)));

% Vector normalise data
vn_data = vectornorm(data);

% Principal Compnents Analysis
[pcloadings,pcscores,pcexplained] = pca_clirspec(vn_data);

% Percentage explained variance
fig10 = plot_pcexplained(pcexplained);
fig11 = plot_cumpcexplained(pcexplained);

% Scores plot of 
pc_x = 1;
pc_y = 2;
fig12 = plot_pcscores(pcscores,pc_x,pc_y,pcexplained);
fig13 = plot_pcscores(pcscores,pc_x,pc_y,pcexplained,groupmembership);

pc_number1 = 1;
pc_number2 = 2;
fig14 = plot_pcloading(pcloadings,pc_number1,pcexplained,wavenumbers,'wavenumbers',true);

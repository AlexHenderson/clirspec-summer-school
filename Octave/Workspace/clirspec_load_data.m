% CLIRSPEC Summer School 2015
% Multivariate Analysis Workshop

% Load data
data = load('C:\CLIRSPEC\Summer-School\Octave\Data\utidata.txt');
data = fliplr(data);
wavenumbers = linspace(600, 4000, size(data, 2));
groupmembership = generate_groups('E. coli',20,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',20,'E. coli',48,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',28);

% Show the list of unique group titles/labels
disp(char(unique(groupmembership)));

% Plot raw data
fig1 = plot_spectra(data,wavenumbers,'wavenumbers','absorbance',true);
title('Fig 1. Raw data');


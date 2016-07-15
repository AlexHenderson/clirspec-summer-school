% CLIRSPEC Summer School 2015
% Multivariate Analysis Workshop

% Load data
data = load('C:\CLIRSPEC\clirspec-summer-school\Octave\Data\utidata.txt');
data = fliplr(data);
wavenumbers = linspace(600, 4000, size(data, 2));
groupmembership = generate_groups('E. coli',20,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',20,'E. coli',48,'P. mirabilis',20,'Klebsiella spp.',20,'P. aeruginosa',20,'Enterococcus spp.',28);

% Show the list of unique group titles/labels
disp(char(unique(groupmembership)));

% Plot raw data
fig1 = plot_spectra(data,wavenumbers,'wavenumbers','absorbance',true);
title('Fig 1. Raw data');

% Vector normalise data
vn_data = vectornorm(data);

% Plot vector normalised data
fig2 = plot_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',true);
title('Fig 2. Vector normalised data');

% Plot spectra relating to specific groups
fig3 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,groupmembership,true);
title('Fig 3. Vector normalised data, plotted per group');

% Plot spectra relating to separateb groups
fig4 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,'E. coli',true);
title('Fig 4. Vector normalised E. coli data');

fig5 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,'P. mirabilis',true);
title('Fig 5. Vector normalised P. mirabilis data');

fig6 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,'Klebsiella spp.',true);
title('Fig 6. Vector normalised Klebsiella spp. data');

fig7 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,'P. aeruginosa',true);
title('Fig 7. Vector normalised P. aeruginosa data');

fig8 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,'P. mirabilis',true);
title('Fig 8. Vector normalised P. mirabilis data');

% Example of plotting two groups of spectra
fig9 = plot_group_spectra(vn_data,wavenumbers,'wavenumbers','absorbance',groupmembership,[{'P. mirabilis'};{'E. coli'}],true);
title('Fig 9. Vector normalised P. mirabilis and E. coli data');


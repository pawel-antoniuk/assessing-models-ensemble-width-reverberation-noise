clear
clc
close all

data = load('mae_data_all_merged.mat');

hrtf_names = strtrim(string(data.hrtf_names));
mae_per_hrtf = data.mae_per_hrtf;
std_per_hrtf = data.std_per_hrtf;

f = figure;
f.Position = [700 400 600 400];

hold on;

mae_values = struct2array(mae_per_hrtf);
std_values = struct2array(std_per_hrtf);

x = 1:length(hrtf_names);

fill([x, fliplr(x)], ...
    [mae_values + std_values, ...
    fliplr(mae_values - std_values)], ...
    'r', ...
    'FaceAlpha', 0.1, ...
    'EdgeColor', 'r');

plot(x, mae_values, '-o', ...
    'MarkerSize', 6);

grid
set(gca, 'XTick', 1:length(hrtf_names), ...
    'XTickLabel', hrtf_names, ...
    'TickDir', 'both');

xtickangle(55); 
xlabel('HRTF');
ylabel('Mean Absolute Error');
xlim([1 30])
ytickformat('%g°')
title('Averaged MAE per HRTF Across All SNRs')

ax = gca;
ax.TickLabelInterpreter = 'tex'; 

text(1.025,-0.05,["\color{orange}Artificial", "\color{black}Human"], ...
    'Units', 'normalized', ...
    "Interpreter","tex");

hold off;

exportgraphics(f, 'mae_snr_hrtf3.png', ...
    Resolution=300)

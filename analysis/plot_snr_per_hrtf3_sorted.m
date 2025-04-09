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

[mae_values_sorted, sort_idx] = sort(mae_values);
std_values_sorted = std_values(sort_idx);
hrtf_names_sorted = hrtf_names(sort_idx);

x = 1:length(hrtf_names_sorted);

fill([x, fliplr(x)], ...
    [mae_values_sorted + std_values_sorted, ...
    fliplr(mae_values_sorted - std_values_sorted)], ...
    'r', ...
    'FaceAlpha', 0.1, ...
    'EdgeColor', 'r');

plot(x, mae_values_sorted, '-o', ...
    'MarkerSize', 6);

grid
set(gca, 'XTick', 1:length(hrtf_names_sorted), ...
    'XTickLabel', hrtf_names_sorted, ...
    'TickDir', 'both');

xtickangle(55); 
xlabel('HRTF');
ylabel('Mean Absolute Error');
xlim([1 30])
ytickformat('%g°')
title('Averaged MAE per HRTF Across All SNRs (Sorted by value)')

ax = gca;
ax.TickLabelInterpreter = 'tex'; 

text(1.025,-0.05,["\color{orange}Artificial", "\color{black}Human"], ...
    'Units', 'normalized', ...
    "Interpreter","tex");

hold off;

exportgraphics(f, 'mae_snr_hrtf3_sorted.png', ...
    Resolution=300)

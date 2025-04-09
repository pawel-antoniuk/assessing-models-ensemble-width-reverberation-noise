close all

data = load('mae_data_above0.mat');

snr_values = data.snr_values;
hrtf_names = strtrim(string(data.hrtf_names));
mae_data = data.mae_data;

field_names = fieldnames(mae_data);

f = figure;
f.Position = [700 400 600 400];

hold on;

num_lines = length(snr_values);
cmap = parula(num_lines+2);
% cmap = cmap(2:end,:);

for i = 1:length(field_names)
    mae_values = mae_data.(field_names{i}); 
    snr_label = field_names{i};
    plot(1:length(hrtf_names), mae_values, '-o', ...
        'DisplayName', snr_label, ...
        'Color', cmap(i, :), ...
        'MarkerFaceColor', cmap(i, :), ...
        'MarkerSize', 6);
end

grid
set(gca, 'XTick', 1:length(hrtf_names), ...
    'XTickLabel', hrtf_names, ...
    'TickDir', 'both');

xtickangle(55); 
xlabel('HRTF');
ylabel('Mean Absolute Error');
xlim([0.5 30.5])
ylim([5, 16])
ytickformat('%g°')
title('Influence of SNR on MAE fo Individual HRTFs for SNR > 0')

ax = gca;
ax.TickLabelInterpreter = 'tex';
% ax.XAxis.FontSize = 7.5;
ax.Position = [0.1, ax.Position(2), 0.78, ax.Position(4)];
legend('show', 'Location', 'westoutside');
lgd = legend('show', 'Location', 'eastoutside');
title(lgd, 'SNR [dB]')
legend_position = get(lgd, 'Position');
set(lgd, 'Position', [0.89, 0.22, 0.1, 0.70]); 

text(1.025,-0.05,["\color{orange}Artificial", "\color{black}Human"], ...
    'Units', 'normalized', ...
    "Interpreter","tex");

hold off;

exportgraphics(f, 'mae_snr_hrtf2.png', ...
    Resolution=300)

close all;
clear;

Tgb = readtable('gb.csv');
Tsp = readtable('spatiogram.csv');
Tdp = readtable('deep.csv');

f = figure;
f.Position = [700 400 350 200];

hold on
errorbar(Tgb.db, Tgb.mae, Tgb.std, Tgb.std, 'o-');
errorbar(Tdp.db, Tdp.mae, Tdp.std, Tdp.std, 'o-');
errorbar(Tsp.db, Tsp.mae, Tsp.std, Tsp.std, 'o-');
plot([-10 60], [22.5 22.5])
hold off

ylim([6, 80])
xlabel('SNR in Test Data [dB]')
ylabel('Mean Absoute Error')
ytickformat('%g°')
xtickformat('%.0f')
set(gca, 'XTick', Tgb.db);
legend( ...
    '(1) Auditory Model', ...
    '(2) Neural Network', ...
    '(3) Spatial Spectrogram', ...
    'Baseline MAE', ...
    Location='northeast')
grid on

exportgraphics(f, 'mae_snr_full.png', ...
    Resolution=300)


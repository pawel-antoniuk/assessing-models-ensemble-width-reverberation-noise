close all;
clear;

Tgb = readtable('gb.csv');
Tsp = readtable('spatiogram.csv');
Tdp = readtable('deep.csv');

f = figure;
f.Position = [700 400 350 200];

hold on
errorbar(Tgb.rt, Tgb.mae, Tgb.std, Tgb.std, 'o-');
errorbar(Tdp.rt, Tdp.mae, Tdp.std, Tdp.std, 'o-');
errorbar(Tsp.rt, Tsp.mae, Tsp.std, Tsp.std, 'o-');
plot([0 3], [22.5 22.5])
hold off

ylim([6, 90])
xlabel('RT60 [s]')
ylabel('Mean Absoute Error')
ytickformat('%g°')
set(gca, 'XTick', Tgb.rt);
legend( ...
    '(1) Auditory Model', ...
    '(2) Neural Network', ...
    '(3) Spatial Spectrogram', ...
    'Baseline MAE', ...
    Location='northwest')
grid on

exportgraphics(f, 'mae_rt.png', ...
    Resolution=300)


import dill
import numpy as np
from scipy.io import savemat

filenames = {
    "10": "10ae531bce_003_snr10.pkl",
    "20": "10ae531bce_004_snr100.pkl",
    "30": "10ae531bce_005_snr1000.pkl",
    "40": "10ae531bce_006_snr10000.pkl",
    "50": "10ae531bce_007_snr100000.pkl",
    "60": "10ae531bce_008_snr1000000.pkl"
}

artificial_hrtfs = {2, 6, 10, 11, 12, 17, 18, 21, 22, 25, 26, 27, 28, 29, 30} 
mae_per_hrtf = {}

for snr, filename in filenames.items():
    models = dill.load(open(f'final-snr/{filename}', 'rb'))
    mae_per_hrtf_for_snr = {}

    for model in models:
        actual = model.df_test.EnsembleAcutalWidth
        predicted = model.final_pred
        hrtf_no = model.df_test.AudioFilenames.str.split('_').str[1].str.replace('hrtf', '')
        hrtf_no =  hrtf_no.apply(lambda x: '6' if x == '4' else ('4' if x == '6' else x)) # 4 and 6 are replace (HRTF.csv vs table)
        hrtf_no_fmt = hrtf_no.apply(lambda x: f'\\bf{{{x}}}')
        hrtf_name = model.df_test.AudioFilenames.str.split('_').str[2].str.upper()
        hrtf_full = hrtf_name + ' ' + hrtf_no_fmt
        hrtf_full = hrtf_full.apply(lambda x: f"\\color{{orange}}{x}" if any(num in x for num in [f'\\bf{{{n}}}' for n in artificial_hrtfs]) else x)
        current_mae = np.mean(abs(actual-predicted))
        
        
        for h, a, p in zip(hrtf_full, actual, predicted):
            current_mae = abs(a - p)
            mae_per_hrtf_for_snr.setdefault(h, []).append(current_mae)

    for hrtf, maes in mae_per_hrtf_for_snr.items():
        mae_per_hrtf.setdefault(hrtf, []).append(np.mean(maes))


std_per_hrtf = {k: float(np.std(maes)) for k, maes in mae_per_hrtf.items()}
mae_per_hrtf = {k: float(np.mean(maes)) for k, maes in mae_per_hrtf.items()}

std_per_hrtf = dict(sorted(std_per_hrtf.items(), key=lambda x: int(x[0].replace('\\bf{', '').replace('}', '').replace('*', '').split(' ')[1])))
mae_per_hrtf = dict(sorted(mae_per_hrtf.items(), key=lambda x: int(x[0].replace('\\bf{', '').replace('}', '').replace('*', '').split(' ')[1])))

data_to_save = {
    "hrtf_names": list(mae_per_hrtf.keys()), 
    "mae_per_hrtf": mae_per_hrtf,
    "std_per_hrtf": std_per_hrtf 
}

savemat("mae_data_all_merged.mat", data_to_save)


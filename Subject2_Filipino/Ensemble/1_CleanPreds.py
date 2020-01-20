import pandas as pd
from sklearn.preprocessing import LabelEncoder

dta = pd.read_csv("./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/y1314_AllSubjects.csv")
dta = dta.drop(['overall_mean', 'latitude', 'longitude'], axis = 1)
dta.head()

# Landsat
landsat_pass = pd.read_csv("./clean/Subject2_Filipino/Ensemble/data/LandsatPassPreds.csv")
landsat_pass = landsat_pass.drop(['Unnamed: 0'], axis = 1)
landsat_pass.head()
landsat_pass.shape

landsat_fail = pd.read_csv("./clean/Subject2_Filipino/Ensemble/data/LandsatFailPreds.csv")
landsat_fail = landsat_fail.drop(['Unnamed: 0'], axis = 1)
landsat_fail.head()
landsat_fail.shape

landsat_preds = landsat_pass.append(landsat_fail)
landsat_preds['landsat_class_pred'] = 9
landsat_preds['landsat_class_pred'][landsat_preds['prob_pass'] >= 50] = 0
landsat_preds['landsat_class_pred'][landsat_preds['prob_pass'] < 50] = 1
landsat_preds = pd.merge(landsat_preds, dta, on = 'school_id')

landsat_preds['correct'] = 0
landsat_preds["correct"][(landsat_preds['intervention'] == 0) & (landsat_preds["landsat_class_pred"] == 0)] = 1
landsat_preds["correct"][(landsat_preds['intervention'] == 1) & (landsat_preds["landsat_class_pred"] == 1)] = 1

landsat_preds['landsat_class_pred'].value_counts()
landsat_preds['intervention'].value_counts()
landsat_preds['correct'].value_counts()




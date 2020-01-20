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





Subject3_Math/E1_Math_Landsat/data/
Subject3_Math/E1_Math_Landsat/epochs/
Subject3_Math/E1_Math_Landsat/models/

Subject3_Math/E2_Math_Static/data/
Subject3_Math/E2_Math_Static/epochs/
Subject3_Math/E2_Math_Static/models/

Subject3_Math/E3_Math_StreetView/data/
Subject3_Math/E3_Math_StreetView/epochs/
Subject3_Math/E3_Math_StreetView/models/


Subject4_Science/E1_Sci_Landsat/data/
Subject4_Science/E1_Sci_Landsat/epochs/
Subject4_Science/E1_Sci_Landsat/models/

Subject4_Science/E1_Sci_Static/data/
Subject4_Science/E1_Sci_Static/epochs/
Subject4_Science/E1_Sci_Static/models/

Subject4_Science/E1_Sci_StreetView/data/
Subject4_Science/E1_Sci_StreetView/epochs/
Subject4_Science/E1_Sci_StreetView/models/


Subject5_AP/E1_AP_Landsat/data/
Subject5_AP/E1_AP_Landsat/epochs/
Subject5_AP/E1_AP_Landsat/models/

Subject5_AP/E1_AP_Static/data/
Subject5_AP/E1_AP_Static/epochs/
Subject5_AP/E1_AP_Static/models/

Subject5_AP/E1_AP_StreetView/data/
Subject5_AP/E1_AP_StreetView/epochs/
Subject5_AP/E1_AP_StreetView/models/



import pandas as pd
from sklearn.preprocessing import LabelEncoder


dta = pd.read_csv("./clean/Subject1_English/Ensemble2_English_StaticResNeXt101/data/y1314_English.csv")
dta = dta.drop(['english_mean', 'latitude', 'longitude'], axis = 1)
dta.head()

## Landsat
landsat_pass = pd.read_csv("./clean/AllSubjects/Ensemble/data/LandsatPassPreds.csv")
landsat_pass = landsat_pass.drop(['Unnamed: 0'], axis = 1)
landsat_pass.head()
landsat_pass.shape

landsat_fail = pd.read_csv("./clean/AllSubjects/Ensemble/data/LandsatFailPreds.csv")
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


# Static
static = pd.read_csv("./clean/Subject1_English/Ensemble/data/StaticPreds.csv")
static = static.drop(['Unnamed: 0'], axis = 1)
static.head()

static['static_class_pred'] = 9
static['static_class_pred'][static['prob_pass'] >= 50] = 0
static['static_class_pred'][static['prob_pass'] < 50] = 1
static = pd.merge(static, dta, on = 'school_id')

static['correct'] = 0
static["correct"][(static['intervention'] == 0) & (static["static_class_pred"] == 0)] = 1
static["correct"][(static['intervention'] == 1) & (static["static_class_pred"] == 1)] = 1

static['static_class_pred'].value_counts()
static['intervention'].value_counts()
static['correct'].value_counts()


# Prep for Ensemble
landsat_preds = landsat_preds.drop(['correct', 'prob_pass', 'landsat_class_pred', 'intervention'], axis = 1)
static = static.drop(['correct', 'prob_pass', 'static_class_pred'], axis = 1)

landsat_preds.columns = ['school_id', 'landsat_prob_fail']
static.columns = ['school_id', 'static_prob_fail', 'intervention']

comb = pd.merge(landsat_preds, static, on = 'school_id')
comb.head()
comb.shape




# Merge with geo data
coords = pd.read_csv("./clean/AllSubjects/Ensemble/data/this_one.csv")
coords = coords.drop_duplicates(subset = 'school_id')
coords = coords[coords['school_id'].isin(comb['school_id'].tolist())]
#coords.to_csv("./clean/AllSubjects/Ensemble/data/this_one.csv")
coords = coords[['school_id', 'region', 'province']]
comb = pd.merge(comb, coords, how = "left", on = 'school_id')
comb.head()
comb.shape

discreteCoder_X = LabelEncoder()
comb['region'] = discreteCoder_X.fit_transform(comb['region'])
comb['province'] = discreteCoder_X.fit_transform(comb['province'])

comb.head()



comb.to_csv("./clean/Subject1_English/Ensemble/data/EnsemblePreds.csv", index = False)
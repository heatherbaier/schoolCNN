import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.colors as cm
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.svm import SVR
from sklearn import tree
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.neighbors import KNeighborsRegressor
from sklearn.neural_network import MLPRegressor


# Read in and split data into training and validation sets 
df = pd.read_csv("./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/y1314_AllSubjects.csv")
df = df.drop(['intervention', 'latitude', 'longitude'], axis = 1)
df['overall_mean'] = df['overall_mean'] / 5

dta = pd.read_csv("./clean/AllSubjects/Ensemble/data/EnsemblePreds.csv")
dta = pd.merge(dta, df, on = 'school_id')
dta = dta.drop(['intervention'], axis = 1)
dta.shape
dta.head()

dta = dta.drop(['school_id'], axis = 1)
dta.head()

# Train Test split the data
msk = np.random.rand(len(dta)) < 0.8

train = dta[msk]
test = dta[~msk]

y_train = train.pop("overall_mean")
x_train = train

y_test = test.pop("overall_mean")
x_test = test


svr_regression = SVR(kernel = 'linear', epsilon = 1.0)
svr_regressionFit = svr_regression.fit(x_train, y_train)

DT_regression = tree.DecisionTreeRegressor(random_state = 1693, max_depth = 3)
DT_regressionFit = DT_regression.fit(x_train, y_train)

RF_regression = RandomForestRegressor(n_estimators = 100, random_state = 1693)
RF_regressionFit = RF_regression.fit(x_train, y_train)

neigh = KNeighborsRegressor(n_neighbors=2)
neighFit = neigh.fit(x_train, y_train)

mlp = MLPRegressor()
mlpFit = mlp.fit(x_train, y_train)


rf_MAD = mean_absolute_error(y_test, RF_regressionFit.predict(x_test))
DT_MAD = mean_absolute_error(y_test, DT_regressionFit.predict(x_test))
SVR_MAD = mean_absolute_error(y_test, svr_regressionFit.predict(x_test))
KNN_MAD = mean_absolute_error(y_test, neighFit.predict(x_test))
MLP_MAD = mean_absolute_error(y_test, mlpFit.predict(x_test))


print('Random Forest Tree MAD: ' + str(rf_MAD))
print('Regression Tree MAD: ' + str(DT_MAD))
print('Support Vector Regression MAD ' + str(SVR_MAD))
print('KNN MAD ' + str(KNN_MAD))
print('MLP MAD ' + str(MLP_MAD))






to_pred = dta.drop(['overall_mean'], axis = 1)
preds = RF_regressionFit.predict(to_pred)

dta = pd.read_csv("./clean/AllSubjects/Ensemble/data/EnsemblePreds.csv")
df = pd.read_csv("./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/y1314_AllSubjects.csv")
dta = pd.merge(dta, df, on = 'school_id')

final_df = pd.DataFrame()
final_df['school_id'] = dta['school_id']
final_df['intervention'] = dta['intervention_x']
final_df['actual_mean'] = dta['overall_mean'] / 5
final_df['predicted_mean'] = preds.tolist()
final_df['error'] = abs(final_df['actual_mean'] - final_df['predicted_mean'])

final_df['predicted_class'] = 9
final_df['predicted_class'][final_df['predicted_mean'] >= 27.221] = 0
final_df['predicted_class'][final_df['predicted_mean'] < 27.221] = 1

final_df['correct'] = 0
final_df["correct"][(final_df['intervention'] == 0) & (final_df["predicted_class"] == 0)] = 1
final_df["correct"][(final_df['intervention'] == 1) & (final_df["predicted_class"] == 1)] = 1

final_df.head()

final_df = final_df.drop(['predicted_class', 'correct'], axis = 1)

#final_df.to_csv("./clean/AllSubjects/Ensemble/data/initial_absolute.csv")











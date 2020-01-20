from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.tree import DecisionTreeClassifier
import matplotlib.pyplot as plt
import matplotlib.colors as cm
import seaborn as sns
import pandas as pd
import numpy as np


# Read in and split data into training and validation sets (This is the original CSV from my very first two 
# CNN models. It's a little messy but is the only thing I have downloaded from before CDSW crashed).
dta = pd.read_csv("./clean/AllSubjects/Ensemble/data/EnsemblePreds.csv")
dta = dta.drop(['school_id'], axis = 1)
dta.head()

# Train Test split the data
msk = np.random.rand(len(dta)) < 0.8

train = dta[msk]
test = dta[~msk]

y_train = train.pop("intervention")
x_train = train

y_test = test.pop("intervention")
x_test = test


# {'max_depth': 7, 'n_estimators': 250}
rForest = RandomForestClassifier(n_estimators = 250, max_depth=7).fit(x_train, y_train)
Z = rForest.predict(x_test)
1 - (sum(abs(Z - y_test)) / len(y_test))

# {'leaf_size': 10, 'n_neighbors': 9, 'weights': 'uniform'}
NNeighbors = KNeighborsClassifier(n_neighbors = 9, leaf_size = 10, weights = 'uniform').fit(x_train, y_train)
Z = NNeighbors.predict(x_test)
1 - (sum(abs(Z - y_test)) / len(y_test))






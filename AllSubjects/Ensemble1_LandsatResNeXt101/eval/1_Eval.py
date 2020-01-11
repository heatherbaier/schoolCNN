from __future__ import print_function, division

from torchvision import datasets, models, transforms
from torch.optim import lr_scheduler
from torch.autograd import Variable
from torchsummary import summary
import matplotlib.pyplot as plt
import torch.optim as optim
import torch.nn as nn
from PIL import Image
import pandas as pd
import torchvision
import numpy as np
import pickle
import joblib
import torch
import time
import copy
import PIL
import os


model_ft = joblib.load("./clean/AllSubjects/Ensemble1_LandsatResNeXt101/epochs/LandsatResNeXt101_Epoch1.sav")
directory = "./clean/AllSubjects/Ensemble1_LandsatResNeXt101/data/pass/"
transform = transforms.Compose([
	transforms.Resize(256),
	transforms.CenterCrop(224),
	transforms.ToTensor(),
	transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])




def EvalModel(model, directory, transforms):
	
	df = pd.DataFrame()
	cpass, cfail, ids, class_pred = [], [], [], []
	count = 0
	for filename in os.listdir(directory):
			count += 1
			school_id = filename[0:6]
			ids.append(school_id)
			to_open = directory + filename
			png = Image.open(to_open)
			img_t = transform(png)
			batch_t = torch.unsqueeze(img_t, 0)
			model_ft.eval()
			out = model_ft(batch_t)
			_, index = torch.max(out, 1)
			percentage = torch.nn.functional.softmax(out, dim=1)[0] * 100
#			print(percentage)
			cfail.append(percentage[0].tolist())
			cpass.append(percentage[1].tolist())
			class_pred.append(index[0].tolist())
			print("Predicted " + str(count) + " out of " + str(len(os.listdir(directory))) + " images." )
	df['school_id'] = ids
	df['prob_fail'] = cfail
	df['prob_pass'] = cpass
	df['class_pred'] = class_pred
	df['label'] = 0
	return df



EvalModel(model_ft, directory, transform)




#gitignore

AllSubjects/Ensemble1_LandsatResNeXt101/data/
AllSubjects/Ensemble1_LandsatResNeXt101/epochs/
AllSubjects/Ensemble1_LandsatResNeXt101/models/

AllSubjects/Ensemble2_StaticResNeXt101/data/
AllSubjects/Ensemble2_StaticResNeXt101/epochs/
AllSubjects/Ensemble2_StaticResNeXt101/models/

AllSubjects/Ensemble3_StreetViewResNet152/data/
AllSubjects/Ensemble3_StreetViewResNet152/epochs/
AllSubjects/Ensemble3_StreetViewResNet152/models/






from __future__ import print_function, division

from torchvision import datasets, models, transforms
from imgaug import augmenters as iaa
from sklearn.externals import joblib
from torch.optim import lr_scheduler
import matplotlib.pyplot as plt
import torch.optim as optim
import torch.nn as nn
from PIL import Image
import imgaug as ia
import pandas as pd
import numpy as np
import torchvision
import pickle
import joblib
import torch
import copy
import time
import os

class ImgAugTransform:
  def __init__(self):
    self.aug = iaa.Sequential([
        iaa.Scale((224, 224)),
        iaa.Sometimes(0.25, iaa.GaussianBlur(sigma=(0, 3.0))),
        iaa.Fliplr(0.5),
        iaa.Affine(rotate=(-20, 20), mode='symmetric'),
        iaa.Sometimes(0.25,
                      iaa.OneOf([iaa.Dropout(p=(0, 0.1)),
                                 iaa.CoarseDropout(0.1, size_percent=0.5)])),
        iaa.AddToHueAndSaturation(value=(-10, 10), per_channel=True)
    ])
      
  def __call__(self, img):
    img = np.array(img)
    return self.aug.augment_image(img)


data_transforms = transforms.Compose([
        ImgAugTransform(),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

model_ft = joblib.load("../GoogleStatic_ResNet18.sav")

data = pd.read_csv("./y1314_df.csv")

df = pd.DataFrame()
cfail = []
cpass = []
ids = []
label = []

directory = "./jpg/"

for filename in os.listdir(directory):
    school_id = filename[0:6]
    ids.append(school_id)
    info = data[data['school_id'] == int(school_id)]
    label.append(info.intervention.tolist()[0])
    img = Image.open(directory + filename)
    cnn_input = data_transforms(img).unsqueeze(0)
    model_ft.eval()
    pred = model_ft(cnn_input)
    print(pred) 
    preds = pred.softmax(1).tolist()
    cfail.append(preds[0][0])
    cpass.append(preds[0][1])


df['school_id'] = ids
df['label'] = label
df['pass'] = cpass
df['fail'] = cfail
df['pred'] = 99
df['correct'] = 0

df['pred'][df['pass'] >= .50] = 0
df['pred'][df['pass'] < .50] = 1

df["correct"][(df['label'] == 0) & (df["pred"] == 0)] = 1
df["correct"][(df['label'] == 1) & (df["pred"] == 1)] = 1

print(df.head())
print(df['correct'].value_counts())
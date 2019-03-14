# Setting working directory
import os
os.chdir('C:/Users/Ke Nie/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project')

# Import libraries
# feature extractoring and preprocessing data
#import librosa
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#%matplotlib inline
from PIL import Image
import pathlib
import csv

# Preprocessing
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler

#Keras
import keras
from keras import models
from keras.models import load_model
import warnings
warnings.filterwarnings('ignore')

# HipHopiness
# Load model
model = load_model('model_0.9125.h5')

# read dataframe
data = pd.read_csv('data_folk.csv')

# Dropping unneccesary columns
# data = data.drop(['Column1'], axis=1)

# Scaling the Feature columns
scaler = StandardScaler()
data.iloc[:, 1:-2] = scaler.fit_transform(np.array(data.iloc[:, 1:-2], dtype = float))

# Processing hip-hopiness
predictions = model.predict(data.iloc[:, 1:-2])
for i in range(len(data)):
    data.iloc[i,27] = predictions[i,4]

# Speechiness
# Load model
model_speech = load_model('model_sound_1.0.h5')

# Processing speechiness
predictions_speech = model_speech.predict(data.iloc[:, 1:-2])
for i in range(len(data)):
    data.iloc[i,28] = predictions_speech[i,1]

# Write dataframe to csv
data.to_csv('data_folk_lableprobs.csv', index=False)



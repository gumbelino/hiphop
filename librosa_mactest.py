# Setting working directory
import os
os.chdir('/Users/norzvic/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project')


# Import libraries
import librosa
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#from PIL import Image
#import pathlib
import csv
from sklearn.preprocessing import LabelEncoder, StandardScaler

# Extracting features from Spectrogram
header = 'filename chroma_stft rmse spectral_centroid spectral_bandwidth rolloff zero_crossing_rate'
for i in range(1, 21):
    header += f' mfcc{i}'
header += ' label'
header = header.split()


# Writing data to csv file
file = open('data_test5.csv', 'w', newline='')
with file:
    writer = csv.writer(file)
    writer.writerow(header)
genres = 'blues classical country disco hiphop jazz metal pop reggae rock'.split()
for filename in os.listdir(f'/Users/norzvic/Music/aaa'):
    if filename.endswith('.mp3'):
        songname = f'/Users/norzvic/Music/aaa{filename}'
        y, sr = librosa.load(songname)
        chroma_stft = librosa.feature.chroma_stft(y=y, sr=sr)
        rmse = librosa.feature.rmse(y=y)
        spec_cent = librosa.feature.spectral_centroid(y=y, sr=sr)
        spec_bw = librosa.feature.spectral_bandwidth(y=y, sr=sr)
        rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr)
        zcr = librosa.feature.zero_crossing_rate(y)
        mfcc = librosa.feature.mfcc(y=y, sr=sr)
        to_append = f'{filename} {np.mean(chroma_stft)} {np.mean(rmse)} {np.mean(spec_cent)} {np.mean(spec_bw)} {np.mean(rolloff)} {np.mean(zcr)}'    
        for e in mfcc:
            to_append += f' {np.mean(e)}'
        file = open('data_test5.csv', 'a', newline='')
        with file:
            writer = csv.writer(file)
            writer.writerow(to_append.split())
        continue
    else:
        continue

    

# Analyzing the data in pandas
data = pd.read_csv('data_test5.csv')
data.head()

data.shape


# # Scaling the Feature columns
# scaler = StandardScaler()
# X = scaler.fit_transform(np.array(data.iloc[:, 1:-1], dtype = float))




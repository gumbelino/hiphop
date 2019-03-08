# Setting working directory
import os
os.chdir('/Users/norzvic/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project')

# Import libraries
# feature extractoring and preprocessing data
import librosa
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
#import keras

import warnings
warnings.filterwarnings('ignore')

# Extracting the Spectrogram for every Audio
# cmap = plt.get_cmap('inferno')

# plt.figure(figsize=(10,10))
# sound = 'music speech'.split()
# for g in sound:
#     pathlib.Path(f'img_data/{g}').mkdir(parents=True, exist_ok=True)     
#     for filename in os.listdir(f'C:/Users/Ke Nie/Documents/UCSD/Music censorship/music speech/{g}'):
#         songname = f'C:/Users/Ke Nie/Documents/UCSD/Music censorship/music speech/{g}/{filename}'
#         y, sr = librosa.load(songname, mono=True, duration=30)
#         plt.specgram(y, NFFT=2048, Fs=2, Fc=0, noverlap=128, cmap=cmap, sides='default', mode='default', scale='dB');
#         plt.axis('off');
#         plt.savefig(f'img_data/{g}/{filename[:-3].replace(".", "")}.png')
#         plt.clf()

# Extracting features from Spectrogram
header = 'filename chroma_stft rmse spectral_centroid spectral_bandwidth rolloff zero_crossing_rate'
for i in range(1, 21):
    header += f' mfcc{i}'
header += ' label'
header = header.split()


# Writing data to csv file
file = open('data_sound.csv', 'w', newline='')
with file:
    writer = csv.writer(file)
    writer.writerow(header)
sound = 'music speech'.split()
for s in sound:
    for filename in os.listdir(f'/Users/norzvic/Music/music_speech/{s}'):
        if filename.endswith('.au'):
            songname = f'/Users/norzvic/Music/music_speech/{s}/{filename}'
            y, sr = librosa.load(songname, mono=True, duration=30)
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
            to_append += f' {s}'
            file = open('data_sound.csv', 'a', newline='')
            with file:
                writer = csv.writer(file)
                writer.writerow(to_append.split())
            continue
        else:
            continue

# Analyzing the data in pandas
# data = pd.read_csv('data_sound.csv')
# data.head()

# data.shape


# # Dropping unneccesary columns
# data = data.drop(['filename'],axis=1)


# # Encoding the Labels
# genre_list = data.iloc[:, -1]
# encoder = LabelEncoder()
# y = encoder.fit_transform(genre_list)


# # Scaling the Feature columns
# scaler = StandardScaler()
# X = scaler.fit_transform(np.array(data.iloc[:, :-1], dtype = float))


# # Dividing data into training and Testing set
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
# len(y_train)
# len(y_test)
# X_train[10]


# # Classification with Keras
# # Building our Network
# from keras import models
# from keras import layers

# model = models.Sequential()
# model.add(layers.Dense(256, activation='relu', input_shape=(X_train.shape[1],)))

# model.add(layers.Dense(128, activation='relu'))

# model.add(layers.Dense(64, activation='relu'))

# model.add(layers.Dense(10, activation='softmax'))

# model.compile(optimizer='adam',
#               loss='sparse_categorical_crossentropy',
#               metrics=['accuracy'])

# history = model.fit(X_train,
#                     y_train,
#                     epochs=20,
#                     batch_size=128)



# test_loss, test_acc = model.evaluate(X_test,y_test)
# print('test_acc: ',test_acc)


# # Validating our approach
# x_val = X_train[:200]
# partial_x_train = X_train[200:]

# y_val = y_train[:200]
# partial_y_train = y_train[200:]

# model = models.Sequential()
# model.add(layers.Dense(512, activation='relu', input_shape=(X_train.shape[1],)))
# model.add(layers.Dense(256, activation='relu'))
# model.add(layers.Dense(128, activation='relu'))
# model.add(layers.Dense(64, activation='relu'))
# model.add(layers.Dense(10, activation='softmax'))

# model.compile(optimizer='adam',
#               loss='sparse_categorical_crossentropy',
#               metrics=['accuracy'])

# model.fit(partial_x_train,
#           partial_y_train,
#           epochs=50,
#           batch_size=512,
#           validation_data=(x_val, y_val))
# results = model.evaluate(X_test, y_test)

# results

# # model.save('C:/Users/Ke Nie/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project/model_0.705.h5')
# model.save('C:/Users/Ke Nie/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project/model_0.9125.h5')

# # Load model: model = model.load()

# # Predictions on Test Data
# predictions = model.predict(X_test)
# predictions[0].shape
# np.sum(predictions[0])
# np.argmax(predictions[0])



# # Test my own data


# # file = open('data_test4.csv', 'w', newline='')
# # with file:
# #     writer = csv.writer(file)
# #     writer.writerow(header)
# # for filename in os.listdir(f'C:/Users/Ke Nie/Dropbox/JiMi Project/for librosa'):
# #     if filename.endswith('.mp3'):
# #         songname = f'C:/Users/Ke Nie/Dropbox/JiMi Project/for librosa/{filename}'
# #         y, sr = librosa.load(songname, mono=True, duration=30)
# #         chroma_stft = librosa.feature.chroma_stft(y=y, sr=sr)
# #         rmse = librosa.feature.rmse(y=y)
# #         spec_cent = librosa.feature.spectral_centroid(y=y, sr=sr)
# #         spec_bw = librosa.feature.spectral_bandwidth(y=y, sr=sr)
# #         rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr)
# #         zcr = librosa.feature.zero_crossing_rate(y)
# #         mfcc = librosa.feature.mfcc(y=y, sr=sr)
# #         to_append = f'{filename} {np.mean(chroma_stft)} {np.mean(rmse)} {np.mean(spec_cent)} {np.mean(spec_bw)} {np.mean(rolloff)} {np.mean(zcr)}'    
# #         for e in mfcc:
# #             to_append += f' {np.mean(e)}'
# #         file = open('data_test4.csv', 'a', newline='')
# #         with file:
# #             writer = csv.writer(file)
# #             writer.writerow(to_append.split())
# #         continue
# #     else:
# #         continue

# # Analyzing the data in pandas
# data4 = pd.read_csv('data_test4.csv')
# data4.head()

# data4.shape

# # # Dropping unneccesary columns
# # data2 = data2.drop(['filename'],axis=1)


# # Scaling the Feature columns
# scaler = StandardScaler()
# X2 = scaler.fit_transform(np.array(data2.iloc[:, 1:-1], dtype = float))



# # Predictions on Test Data
# predictions2 = model.predict(X2)
# predictions2[0].shape
# np.sum(predictions2[0])
# np.argmax(predictions2[0])



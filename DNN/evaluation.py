import torch
import numpy as np
import torch.nn.functional as Fun  
from collections import Counter
import pandas as pd
from sklearn import datasets
from sklearn.model_selection import train_test_split  
from torch.utils.data import DataLoader, TensorDataset
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import roc_curve,auc, roc_auc_score
import matplotlib.pyplot as plt

x_data = pd.read_csv('Data.csv')
y_label = pd.read_csv('Labels.csv')

min_max_scaler = MinMaxScaler()
min_max_scaler.fit(x_data)   
x_input = min_max_scaler.transform(x_data)
# print(x_input.shape)
# print('x input:',type(x_input))

x_array = x_input
y_array = y_label.values.astype(np.int64).reshape(-1) 

print(x_array[0:10,:])
print(y_array[0:10])

x_data = torch.from_numpy(x_array).float()
y_label = torch.from_numpy(y_array).long()

out = model(x_data)  # Using the trained model
prediction_prob = torch.nn.functional.softmax(out, dim=1)  

fpr, tpr, thresholds = roc_curve(y_label, prediction_prob[:, 1].detach().numpy())  
auc = roc_auc_score(y_label, prediction_prob[:, 1].detach().numpy())  

plt.figure(figsize=(4.2, 4))  

plt.plot(fpr, tpr, label='ROC curve (AUC = {:.2f})'.format(auc), color='#B5907E')
plt.plot([0, 1], [0, 1], linestyle='--', lw =2, color='r', label='Random guess')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC)')
plt.legend()
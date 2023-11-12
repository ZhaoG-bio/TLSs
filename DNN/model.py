import torch
import numpy as np
import torch.nn.functional as Fun  #导入pytorch的神经网络模块
from collections import Counter
import pandas as pd
from sklearn.model_selection import train_test_split  #用于数据切割
from torch.utils.data import DataLoader, TensorDataset
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import roc_curve,auc
import  matplotlib.pyplot as plt

class Net(torch.nn.Module):  
    def __init__(self, n_feature, n_hidden, n_hidden2, n_hidden3, n_output):     
        
        super(Net, self).__init__()     
        self.hidden = torch.nn.Linear(n_feature, n_hidden)   
        self.hidden2 = torch.nn.Linear(n_hidden, n_hidden2) 
        self.hidden3 = torch.nn.Linear(n_hidden2, n_hidden3)    
        
        self.out = torch.nn.Linear(n_hidden3, n_output)   
    
    
    def forward(self, x):
        x = Fun.relu(self.hidden(x))  
        x = Fun.relu(self.hidden2(x)) 
        x = Fun.relu(self.hidden3(x)) 
        x = self.out(x)               
        return x                      
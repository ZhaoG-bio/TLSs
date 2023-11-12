# parameters
epochs = 500  
lr = 0.05     
batch_size = 10

net = Net(n_feature=4, n_hidden = 8,n_hidden2 = 8, n_hidden3 = 8, n_output = 2)  
optimizer = torch.optim.SGD(net.parameters(), lr = lr)  
loss_func = torch.nn.CrossEntropyLoss()  
import numpy as np
import networkx as nx

def adj_corr(x1, x2):
    x1 = x1.flatten()
    x2 = x2.flatten()
    cor = np.corrcoef(x1, x2)[0, 1]
    return cor

def link_density(A):
    links = np.sum(A)
    N = A[0].size
    nd = links / (N^2)
    return nd

def global_clustering(A):
    CC = 0
    N = A[0].size
    for i in range(N):
        C_i = 0
        k_i = sum(A)[i]
        for j in range(N):
            for q in range(N):
                C_i = C_i + A[i,j] * A[j,q] * A[q,i] / k_i / (k_i - 1)
        CC = CC + C_i
    CC = CC / N
    return CC

def cpl(G):
    l_ij = 0
    N = G.number_of_nodes()
    for i in range(N):
        for j in range(N):
            if i != j:
                l_ij = l_ij + (len(nx.shortest_path(G, source=i, target=j)) -  1)
    
    cpl_out = l_ij / N / (N - 1)
    return cpl_out

def morans_i(X,A):
    Ax = []
    N = A[0].size
    for i in range(N):
        Ax.append(np.dot(A[i],X))
    mu = np.sum(Ax)/np.sum(A)
    top = 0
    bot = 0
    for i in range(N):
        for j in range(N):
            top = top + A[i,j] * (X[i] - mu) * (X[j] - mu)
        bot = bot + (X[i] - mu) * (X[i] - mu)
    out = N * top / np.sum(A) / bot
    return out
        
        

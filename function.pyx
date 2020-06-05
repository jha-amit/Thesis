# -*- coding: utf-8 -*-
"""
Created on Thu May 21 17:44:09 2020

@author: amit jha
"""

import numpy as np
cimport numpy as np

DTYPE = np.int
FTYPE= np.float

def node_val(Hash, C, int K):
    cdef int L=int(K/2+1)

    cdef Py_ssize_t n = Hash.shape[0]
    cdef Py_ssize_t k = Hash.shape[1]

    # array_1.shape is now a C array, no it's not possible
    # to compare it simply by using == without a for-loop.
    # To be able to compare it to array_2.shape easily,
    # we convert them both to Python tuples.
    #assert Hash.shape == Node_val.shape)

    Node_val = np.ones((n, k), dtype=FTYPE)*np.inf
    node_val[0,:]=[0,0,0]
    
    cdef int l1, l2, ip, jp, j, i1, i2, j1, j2, lp
    cdef float Cijk
    cdef Py_ssize_t v1, v2

    for v1 in range(0,n-1):
            j1=Hash[v1,0]+1
            if j2!=j1:
                j2=j1
                        
                if j2<=K/2:
                    lp=int(1/2*(j2*(j2+1)))+lp      
                    l1=lp+1
                    l2=int(1/2*(j2+1)*(j2+2))+lp
              
                
                else:
                    lp=int(1/2*(K-j2+2)*(K-j2+3))+lp
                    #print(lp)
                    l1=lp+1
                    l2=int(1/2*(K-j2+1)*(K-j2+2))+lp
            
            #print(l1,l2)
            
            for v2 in range((l1-1),l2):
                j=Hash[v2,0]
                #is there an edge from v1 to v2, namely
                #determine if an edge exist to j-level vertex v2
                 #from the previous(j-1)-level vertex v1
                  #at least the vertices are at the right j-levels
                    #get the j coordinate of vertex v2
                    #potentially there is an edge, but need to inevstigate further
                    #namely, check if it is
                    #too early/late to differentiate the paths OR
                    #the vertices are far apart (i-distance is at least 2)
                if (j < 2 or j > K-2 or \
                    abs(Hash[v2,1]-Hash[v2,2]) >= 2) and \
                    (abs(Hash[v2,1]-Hash[v1,1]) <=  1) and \
                    (abs(Hash[v2,2]-Hash[v1,2]) <=  1):
                    #in this case, add the edge
                    #determine its (cumulative) cost first
                    i1 = Hash[v2,1]
                    i2 = Hash[v2,2]
                    #get cost of visiting (i1,j)
                    ip = int(1/2*(j-i1))
                    jp = int(1/2*(j+i1))
                    #print(ip,jp)
                    Cijk = C[ip][jp]
                    #add cost of visiting (i2,j)
                    ip = int(1/2*(j-i2))
                    jp = int(1/2*(j+i2))
                    Cijk = Cijk+C[ip][jp]
                    #print(Cijk,Node_val[v1,0])   
                    if (Node_val[v2,0]>(Cijk+Node_val[v1,0])):           
                        Node_val[v2,:]=[Cijk+Node_val[v1,0],v1,v2]

    return Node_val
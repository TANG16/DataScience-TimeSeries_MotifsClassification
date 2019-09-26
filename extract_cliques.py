import pandas as pd
import networkx as nx
import numpy as np


def getNetworkGraph(data):
    A = []
    for i in data:
        A.append(list(data[i]))
    A = np.matrix(A)
    G = nx.from_numpy_matrix(A)
    return G


def getMotifNumForEachAxis(motifNum):
    motifNumber = []
    for i in motifNum:
        motifNumber.append(int(motifNum[i]))
    return motifNumber


def getCliques(G, motifNumber):
    y = list(nx.find_cliques(G))
    temp = y[:]
    print len(y)
    for i in y:
        print i
        if (len(i) < 3) or (len(i) > 5):
            temp.remove(i)
    y = temp[:]
    for i in y:
        cx = 0
        cy = 0
        cz = 0
        for j in i:
            if j < motifNumber[0] and cx == 0:
                cx = cx+1
            if j >= motifNumber[0] and j < motifNumber[0]+motifNumber[1] and cy == 0:
                cy = cy+1
            if j >= motifNumber[0]+motifNumber[1] and cz == 0:
                cz = cz+1
        if (cx + cy + cz) < 3:
            temp.remove(i)
    return temp


if __name__ == '__main__':
    dataForRunning = pd.read_excel("adjacency_graph_running.xls", header=None)
    motifNumForEachAxisRunning = pd.read_excel("SignalMotifsNum_running.xls", header=None)
    dataForClimbingDown = pd.read_excel("adjacency_graph_climbingdown.xls", header=None)
    motifNumForEachAxisClimbingDown = pd.read_excel("SignalMotifsNum_climbingdown.xls", header=None)

    runningGraph = getNetworkGraph(dataForRunning)
    climbingDownGraph = getNetworkGraph(dataForClimbingDown)
    numMotifRunning = getMotifNumForEachAxis(motifNumForEachAxisRunning)
    numMotifClimbingDown = getMotifNumForEachAxis(motifNumForEachAxisClimbingDown)

    runningCliques = getCliques(runningGraph, numMotifRunning)
    climbingDownCliques = getCliques(climbingDownGraph, numMotifClimbingDown)

    print runningCliques
    print climbingDownCliques

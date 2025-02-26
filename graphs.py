import pandas 
import numpy 
import matplotlib.pyplot as mpl
import argparse
import seaborn
from scipy.cluster import hierarchy 
import networkx

from enum import Enum

class Graph(Enum):
    heatmap=1
    kmeans=2
    dendrite=3


parser = argparse.ArgumentParser(prog='Latency Graphs',
                                 description="Visualize latency data",
                                 epilog="choose a graph type, and send data in")

# TODO: add more args as needed
parser.add_argument("filename",help="data file")
parser.add_argument("-g","--graph",help="graph type [heatmap, kmeans, dendrites]")
parser.add_argument("-t","--title",help="graph title")
#parser.add_argument("")



# TODO: add missing args errors



def read_file(fname:str):
    """
    Read csv, and output local and globals df's
    """
    _df = pandas.read_csv(fname)
    _globals = _df[_df.stat == "g"]
    _locals = _df[_df.stat == "l"]
    
    return _globals, _locals

def clean(input_data):

    output_data = input_data

    return output_data


def dendrite():
    """
    Make a dendrite diagram from peter's description    
    """

    # TODO: find a lib that will do this for us or implement

    pass

def kmeans(k,input_data):
    """
    generate k-means from data points, also return notion of how well they fit
    
    """
    # TODO: find a lib that will do this for us or implement
    
    return k


def heatmap(input_data):
    """
    generate a heatmap to visualize latency data
        
      t1 t2 t3 t4 
   t1 xX xx xx xX 
   t2 xx xx xx XX
   t3 XX Xx xx xX
   t4 xx xx xx XX

    """
    _data = input_data.pivot(index="t1",
                             columns="t2",
                             values="min").fillna(0)
    _f, ax = mpl.subplots(figsize=(9, 6))
    ax.set_title(f"{args.title}")
    g = seaborn.heatmap(_data, ax=ax,fmt="d", xticklabels=True, yticklabels=True)
    g.set_xticklabels(ax.get_xticklabels(), rotation=0)
    g.invert_yaxis()
    mpl.show()
    pass

if __name__ == "__main__":
    
    args = parser.parse_args()
    graph = args.graph

    globals_df, locals_df = read_file(args.filename)

    if int(graph) == Graph.heatmap.value:
        heatmap(locals_df)
    elif graph == Graph.kmeans.value:
        pass
    elif graph == Graph.dendrite.value:
        pass

    pass


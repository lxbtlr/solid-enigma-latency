import pandas 
import numpy 
import matplotlib.pyplot as mpl
import argparse
import seaborn
import datetime as dt
from scipy.cluster import hierarchy 
# import networkx

from enum import Enum


stamp = dt.datetime.today().strftime("%Y.%m.%d-%H.%M-")


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
parser.add_argument("-n","--numa",help="# numa nodes (default=1)", default=None)
#parser.add_argument("")



# TODO: add missing args errors

def rf(fname:str):
    """
    Read csv, and output local and globals df's
    """
    _df = pandas.read_csv(fname)
    print(_df)
    return _df


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

def p2p_means(df):
    return df.groupby([df.columns[0], df.columns[1]])[df.columns[3]].mean().reset_index() 


def heatmap(input_data):
    """
    generate a heatmap to visualize latency data
        
      t1 t2 t3 t4 
   t1 xX xx xx xX 
   t2 xx xx xx XX
   t3 XX Xx xx xX
   t4 xx xx xx XX

    """
    
    num_threads = input_data["thread_2"].max()+1
    print(num_threads)
    ticks_offset = 1
    
    # NOTE: adjust the tick offsets if there are more than 32 threads
    if num_threads > 32:
        ticks_offset = num_threads // 8

    print(ticks_offset, args.numa)
    _data = input_data.pivot(index=input_data.columns[0],
                             columns=input_data.columns[1],
                             values=input_data.columns[2]).fillna(0)

    _f, ax = mpl.subplots(figsize=(10, 10))
    ax.set_title(f"{args.title}" + f"(NUMA:{args.numa})" if args.numa is not None else "" )
    
    interval = num_threads
    if args.numa is not None: 
        interval = num_threads // int(args.numa)   #44 ## FIXME: this should be using usr args 
    print(f"Numa={args.numa}\tInterval={interval}")
        
    g = seaborn.heatmap(_data, ax=ax,fmt=".1f", xticklabels=True, yticklabels=True,
                        square=True, vmax=1600)
                        #annot=numpy.round(_data, 1),
                        #annot_kws={"size": 4, "color": "white"})
    g.set_xticklabels([i if c%ticks_offset==0 else " " for c,i in enumerate(ax.get_xticklabels()) ], rotation=0)
    g.set_yticklabels([i if c%ticks_offset==0 else " " for c,i in enumerate(ax.get_xticklabels()) ], rotation=0)
    g.invert_yaxis()

    for i in range(interval, _data.shape[0], interval):
        ax.axhline(i, color='white', lw=1.5)
    for j in range(interval, _data.shape[1], interval):
        ax.axvline(j, color='white', lw=1.5)
    # Label each region
    num_rows = _data.shape[0]
    num_cols = _data.shape[1]

    for row_start in range(0, num_rows, interval):
        for col_start in range(0, num_cols, interval):
            row_end = min(row_start + interval, num_rows)
            col_end = min(col_start + interval, num_cols)
            center_y = (row_start + row_end) / 2
            center_x = (col_start + col_end) / 2
            label = "{},{}".format(row_start // interval, col_start // interval)
            ax.text(center_x, center_y, label, color='white', ha='center', va='center',
                    fontsize=10, weight='bold', bbox=dict(facecolor='black', alpha=0.5, boxstyle='round,pad=0.3'))




    mpl.savefig("imgs/"+stamp+ args.title + ".pdf", dpi=300)
    mpl.show()
    pass

if __name__ == "__main__":
    
    args = parser.parse_args()
    graph = args.graph

    #globals_df, locals_df = read_file(args.filename)
    
    data = rf(args.filename)

    avgs_data = p2p_means(data)
    max_thread = avgs_data["thread_1"].max()
    sockets= 4
    cores = 44
    avgs_data["thread_1"] = ((avgs_data["thread_1"]%sockets) * cores) +(avgs_data["thread_1"]//sockets) 
    avgs_data["thread_2"] = ((avgs_data["thread_2"]%sockets) * cores) +(avgs_data["thread_2"]//sockets) 
    avgs_data["time"] = avgs_data["time"]


    print(avgs_data)
    if int(graph) == Graph.heatmap.value:
        heatmap(avgs_data)
    elif graph == Graph.kmeans.value:
        pass
    elif graph == Graph.dendrite.value:
        pass

    pass


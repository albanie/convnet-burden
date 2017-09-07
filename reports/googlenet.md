### Report for googlenet
Model params 51 MB 

Estimates for a single full pass of model at input size 224 x 224: 

* Memory required for features: 26 MB 
* Flops: 2 GFLOPs 

Estimates are given below of the burden of computing the `icp9_out` features in the network for different input sizes using a batch size of 128: 

| input size | feature size | feature memory | flops | 
|------------|--------------|----------------|-------| 
| 112 x 112 | 3 x 3 x 1024 | 805 MB | 50 GFLOPs |
| 224 x 224 | 7 x 7 x 1024 | 3 GB | 205 GFLOPs |
| 336 x 336 | 10 x 10 x 1024 | 7 GB | 457 GFLOPs |
| 448 x 448 | 14 x 14 x 1024 | 13 GB | 819 GFLOPs |
| 560 x 560 | 17 x 17 x 1024 | 20 GB | 1 TFLOPs |
| 672 x 672 | 21 x 21 x 1024 | 29 GB | 2 TFLOPs |

A rough outline of where in the network memory is allocated to parameters and features and where the greatest computational cost lies is shown below.  The x-axis does not show labels (it becomes hard to read for networks containing hundreds of layers) - it should be interpreted as depicting increasing depth from left to right.  The goal is simply to give some idea of the overall profile of the model: 

![googlenet profile](figs/googlenet.png)

### Report for mcn-mobilenet
Model params 16 MB 

Estimates for a single full pass of model at input size 224 x 224: 

* Memory required for features: 38 MB 
* Flops: 579 MFLOPs 

Estimates are given below of the burden of computing the `fc7` features in the network for different input sizes using a batch size of 128: 

| input size | feature size | feature memory | flops | 
|------------|--------------|----------------|-------| 
| 224 x 224 | 1 x 1 x 1000 | 5 GB | 74 GFLOPs |
| 336 x 336 | 1 x 1 x 1000 | 11 GB | 169 GFLOPs |
| 448 x 448 | 1 x 1 x 1000 | 19 GB | 296 GFLOPs |
| 560 x 560 | 1 x 1 x 1000 | 30 GB | 466 GFLOPs |
| 672 x 672 | 1 x 1 x 1000 | 43 GB | 666 GFLOPs |

A rough outline of where in the network memory is allocated to parameters and features and where the greatest computational cost lies is shown below.  The x-axis does not show labels (it becomes hard to read for networks containing hundreds of layers) - it should be interpreted as depicting increasing depth from left to right.  The goal is simply to give some idea of the overall profile of the model: 

![mcn-mobilenet profile](figs/mcn-mobilenet.png)

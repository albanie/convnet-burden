### Report for resnet18
Model params 45 MB 

Estimates for a single full pass of model at input size 224 x 224: 

* Memory required for features: 23 MB 
* Flops: 2 GFLOPs 

Estimates are given below of the burden of computing the `features_7_1_id_relu` features in the network for different input sizes using a batch size of 128: 

| input size | feature size | feature memory | flops | 
|------------|--------------|----------------|-------| 
| 112 x 112 | 4 x 4 x 512 | 734 MB | 62 GFLOPs |
| 224 x 224 | 7 x 7 x 512 | 3 GB | 233 GFLOPs |
| 336 x 336 | 11 x 11 x 512 | 6 GB | 536 GFLOPs |
| 448 x 448 | 14 x 14 x 512 | 11 GB | 932 GFLOPs |
| 560 x 560 | 18 x 18 x 512 | 18 GB | 1 TFLOPs |
| 672 x 672 | 21 x 21 x 512 | 25 GB | 2 TFLOPs |

A rough outline of where in the network memory is allocated to parameters and features and where the greatest computational cost lies is shown below.  The x-axis does not show labels (it becomes hard to read for networks containing hundreds of layers) - it should be interpreted as depicting increasing depth from left to right.  The goal is simply to give some idea of the overall profile of the model: 

![resnet18 profile](figs/resnet18.png)

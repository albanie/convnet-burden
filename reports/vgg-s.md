### Report for vgg-s
Model params 393 MB 
Estimates for a single full pass of model at input size 224 x 224: 

* Memory required for features: 12 MB 
* Flops: 3 GFLOPS 

Estimates are given below of the burden of computing the `pool5` features in the network for different input sizes: 

| input size | feature size | feature memory | flops | 
 | 112 x 112 | 3 x 3 x 512 | 348 MB | 58 GFLOPS |
 | 224 x 224 | 6 x 6 x 512 | 2 GB | 327 GFLOPS |
 | 336 x 336 | 9 x 9 x 512 | 4 GB | 768 GFLOPS |
 | 448 x 448 | 12 x 12 x 512 | 6 GB | 1 TFLOPS |
 | 560 x 560 | 15 x 15 x 512 | 10 GB | 2 TFLOPS |
 | 672 x 672 | 18 x 18 x 512 | 15 GB | 3 TFLOPS |

A rough outline of where in the network memory is allocated to parameters and features and where the greatest computational cost lies is shown below.  The x-axis does not show labels (it becomes hard to read with the networks containing hundreds of layers) - it should be interpreted as depicting increasing depth from left to right.  The goal is to give some idea of the overall profile of the model: 
![vgg-s profile](figs/vgg-s.png)

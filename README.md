convnet-burden
---

Computational burden estimates of memory consumption and FLOPS for convolutional neural networks.    

### Image Classification Architectures

The numbers below are given for single element batches.  

| model                  | params | feature memory |      flops |
|------------------------|--------|----------------|------------|
| alexnet                | 233 MB | 7 MB           | 727 MFLOPS |
| vgg-verydeep-16        | 528 MB | 14 MB          | 16 GFLOPS  |
| vgg-verydeep-19        | 548 MB | 28 MB          | 20 GFLOPS  |
| vgg-verydeep-16-atrous | 82 MB  | 14 MB          | 16 GFLOPS  |
| resnet-101             | 170 MB | 68 MB          | 8 GFLOPS   |
| resnet-50              | 98 MB  | 51 MB          | 4 GFLOPS   |
| resnet-152             | 230 MB | 92 MB          | 11 GFLOPS  |
| resnext-50-32x4d       | 96 MB  | 31 MB          | 4 GFLOPS   |
| resnext-101-32x4d      | 169 MB | 75 MB          | 8 GFLOPS   |
| resnext-101-64x4d      | 319 MB | 126 MB         | 16 GFLOPS  |
| squeezenet-1-0         | 5 MB   | 8 MB           | 837 MFLOPS |
| squeezenet-1-1         | 5 MB   | 6 MB           | 360 MFLOPS |
| vgg-f                  | 232 MB | 2 MB           | 727 MFLOPS |
| vgg-m                  | 393 MB | 11 MB          | 2 GFLOPS   |
| vgg-s                  | 393 MB | 28 MB          | 3 GFLOPS   |
| vgg-m-2048             | 353 MB | 11 MB          | 2 GFLOPS   |
| vgg-m-1024             | 333 MB | 11 MB          | 2 GFLOPS   |
| vgg-m-128              | 315 MB | 11 MB          | 2 GFLOPS   |

See [here]() for more a detailed breakdown of feature extraction costs at different input image/batch sizes if needed.

### Notes and Assumptions

The numbers for each architecture should be reasonably framework agnostic. It is assumed that all weights and activations are stored as floats (with 4 bytes per datum).  Fused multiply-adds are counted as single operations.

The numbers should be considered to be rough approximations -  modern hardware makes it very difficult to accurately count operations (and even if you could, pipelining etc. means that it is not necessarily a good estimate of inference time).   

The tool for computing the estimates is implemented as a module for the autonn wrapper of matconvnet and is included in this [repo](core/burden.m), so feel free to take a look for extra details.

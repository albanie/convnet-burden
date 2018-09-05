convnet-burden
---

Estimates of memory consumption and FLOP counts for various convolutional neural networks.


### Image Classification Architectures

The numbers below are given for single element batches. 

| model | input size | param mem | feat. mem | flops | src | performance |
|-------|------------|--------------|----------------|-------|-----|-------------|
| [alexnet](reports/alexnet.md) | 227 x 227 | 233 MB | 3 MB | 727 MFLOPs | MCN | 41.80 / 19.20 |
| [caffenet](reports/caffenet.md) | 224 x 224 | 233 MB | 3 MB | 724 MFLOPs | MCN | 42.60 / 19.70 |
| [squeezenet1-0](reports/squeezenet1-0.md) | 224 x 224 | 5 MB | 30 MB | 837 MFLOPs | PT | 41.90 / 19.58 |
| [squeezenet1-1](reports/squeezenet1-1.md) | 224 x 224 | 5 MB | 17 MB | 360 MFLOPs | PT | 41.81 / 19.38 |
| [vgg-f](reports/vgg-f.md) | 224 x 224 | 232 MB | 4 MB | 727 MFLOPs | MCN | 41.40 / 19.10 |
| [vgg-m](reports/vgg-m.md) | 224 x 224 | 393 MB | 12 MB | 2 GFLOPs | MCN | 36.90 / 15.50 |
| [vgg-s](reports/vgg-s.md) | 224 x 224 | 393 MB | 12 MB | 3 GFLOPs | MCN | 37.00 / 15.80 |
| [vgg-m-2048](reports/vgg-m-2048.md) | 224 x 224 | 353 MB | 12 MB | 2 GFLOPs | MCN | 37.10 / 15.80 |
| [vgg-m-1024](reports/vgg-m-1024.md) | 224 x 224 | 333 MB | 12 MB | 2 GFLOPs | MCN | 37.80 / 16.10 |
| [vgg-m-128](reports/vgg-m-128.md) | 224 x 224 | 315 MB | 12 MB | 2 GFLOPs | MCN | 40.80 / 18.40 |
| [vgg-vd-16-atrous](reports/vgg-vd-16-atrous.md) | 224 x 224 | 82 MB | 58 MB | 16 GFLOPs | N/A | - / -  |
| [vgg-vd-16](reports/vgg-vd-16.md) | 224 x 224 | 528 MB | 58 MB | 16 GFLOPs | MCN | 28.50 / 9.90 |
| [vgg-vd-19](reports/vgg-vd-19.md) | 224 x 224 | 548 MB | 63 MB | 20 GFLOPs | MCN | 28.70 / 9.90 |
| [googlenet](reports/googlenet.md) | 224 x 224 | 51 MB | 26 MB | 2 GFLOPs | MCN | 34.20 / 12.90 |
| [resnet18](reports/resnet18.md) | 224 x 224 | 45 MB | 23 MB | 2 GFLOPs | PT | 30.24 / 10.92 |
| [resnet34](reports/resnet34.md) | 224 x 224 | 83 MB | 35 MB | 4 GFLOPs | PT | 26.70 / 8.58 |
| [resnet-50](reports/resnet-50.md) | 224 x 224 | 98 MB | 103 MB | 4 GFLOPs | MCN | 24.60 / 7.70 |
| [resnet-101](reports/resnet-101.md) | 224 x 224 | 170 MB | 155 MB | 8 GFLOPs | MCN | 23.40 / 7.00 |
| [resnet-152](reports/resnet-152.md) | 224 x 224 | 230 MB | 219 MB | 11 GFLOPs | MCN | 23.00 / 6.70 |
| [resnext-50-32x4d](reports/resnext-50-32x4d.md) | 224 x 224 | 96 MB | 132 MB | 4 GFLOPs | L1 | 22.60 / 6.49 |
| [resnext-101-32x4d](reports/resnext-101-32x4d.md) | 224 x 224 | 169 MB | 197 MB | 8 GFLOPs | L1 | 21.55 / 5.93 |
| [resnext-101-64x4d](reports/resnext-101-64x4d.md) | 224 x 224 | 319 MB | 273 MB | 16 GFLOPs | PT | 20.81 / 5.66 |
| [inception-v3](reports/inception-v3.md) | 299 x 299 | 91 MB | 89 MB | 6 GFLOPs | PT | 22.55 / 6.44 |
| [SE-ResNet-50](reports/SE-ResNet-50.md) | 224 x 224 | 107 MB | 103 MB | 4 GFLOPs | SE | 22.37 / 6.36 |
| [SE-ResNet-101](reports/SE-ResNet-101.md) | 224 x 224 | 189 MB | 155 MB | 8 GFLOPs | SE | 21.75 / 5.72 |
| [SE-ResNet-152](reports/SE-ResNet-152.md) | 224 x 224 | 255 MB | 220 MB | 11 GFLOPs | SE | 21.34 / 5.54 |
| [SE-ResNeXt-50-32x4d](reports/SE-ResNeXt-50-32x4d.md) | 224 x 224 | 105 MB | 132 MB | 4 GFLOPs | SE | 20.97 / 5.54 |
| [SE-ResNeXt-101-32x4d](reports/SE-ResNeXt-101-32x4d.md) | 224 x 224 | 187 MB | 197 MB | 8 GFLOPs | SE | 19.81 / 4.96 |
| [SENet](reports/SENet.md) | 224 x 224 | 440 MB | 347 MB | 21 GFLOPs | SE | 18.68 / 4.47 |
| [SE-BN-Inception](reports/SE-BN-Inception.md) | 224 x 224 | 46 MB | 43 MB | 2 GFLOPs | SE | 23.62 / 7.04 |
| [densenet121](reports/densenet121.md) | 224 x 224 | 31 MB | 126 MB | 3 GFLOPs | PT | 25.35 / 7.83 |
| [densenet161](reports/densenet161.md) | 224 x 224 | 110 MB | 235 MB | 8 GFLOPs | PT | 22.35 / 6.20 |
| [densenet169](reports/densenet169.md) | 224 x 224 | 55 MB | 152 MB | 3 GFLOPs | PT | 24.00 / 7.00 |
| [densenet201](reports/densenet201.md) | 224 x 224 | 77 MB | 196 MB | 4 GFLOPs | PT | 22.80 / 6.43 |
| [mcn-mobilenet](reports/mcn-mobilenet.md) | 224 x 224 | 16 MB | 38 MB | 579 MFLOPs | AU | 29.40 / 45.00 |
| [mcn-mobilenet-v2](reports/mcn-mobilenet-v2.md) | 224 x 224 | 14 MB | 69 MB | 446 MFLOPs | AU | 29.40 / - |


Click on the model name for a more detailed breakdown of feature extraction costs at different input image/batch sizes if needed.  The performance numbers are reported as `top-1 error/top-5 error` on the 2012 ILSVRC validation data.  The `src` column indicates the source of the benchmark scores using the following abberviations:

* [MCN](http://www.vlfeat.org/matconvnet/pretrained/) - scores obtained from the matconvnet website.
* [PT](http://pytorch.org/docs/master/torchvision/models.html) - scores obtained from the PyTorch torchvision module.
* [L1](https://github.com/albanie/mcnPyTorch/blob/master/benchmarks/cnn_imagenet_pt_mcn.m) - evaluated locally (follow link to view benchmark code).
* AU - numbers reported by the paper authors.


These numbers provide an estimate of performance, but note that there may be small differences between the evaluation scripts from different sources.

**References:**

* [alexnet](http://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks) - *Krizhevsky, Alex, Ilya Sutskever, and Geoffrey E. Hinton. "Imagenet classification with deep convolutional neural networks." Advances in neural information processing systems. 2012.*  
* [squeezenet](https://arxiv.org/abs/1602.07360) - *Iandola, Forrest N., et al. "SqueezeNet: AlexNet-level accuracy with 50x fewer parameters and< 0.5 MB model size." arXiv preprint arXiv:1602.07360 (2016).*
* [vgg-m](https://arxiv.org/abs/1405.3531) -  *Chatfield, Ken, et al. "Return of the devil in the details: Delving deep into convolutional nets." arXiv preprint arXiv:1405.3531 (2014).*
* [vgg-vd-16/vgg-vd-19](https://arxiv.org/abs/1409.1556) -  *Simonyan, Karen, and Andrew Zisserman. "Very deep convolutional networks for large-scale image recognition." arXiv preprint arXiv:1409.1556 (2014).*
* [vgg-vd-16-reduced](https://arxiv.org/abs/1506.04579) - *Liu, Wei, Andrew Rabinovich, and Alexander C. Berg. "Parsenet: Looking wider to see better." arXiv preprint arXiv:1506.04579 (2015)*
* [googlenet](http://www.cv-foundation.org/openaccess/content_cvpr_2015/html/Szegedy_Going_Deeper_With_2015_CVPR_paper.html) - *Szegedy, Christian, et al. "Going deeper with convolutions." Proceedings of the IEEE conference on computer vision and pattern recognition. 2015.*
* [inception](https://arxiv.org/abs/1512.00567) - *Szegedy, Christian, et al. "Rethinking the inception architecture for computer vision." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2016.*
* [resnet](https://arxiv.org/abs/1512.03385) - *He, Kaiming, et al. "Deep residual learning for image recognition." Proceedings of the IEEE conference on computer vision and pattern recognition. 2016.*
* [resnext](https://arxiv.org/abs/1611.05431) - *Xie, Saining, et al. "Aggregated residual transformations for deep neural networks." arXiv preprint arXiv:1611.05431 (2016).*
* [SENets](https://arxiv.org/abs/1709.01507) - *Jie Hu, Li Shen and Gang Sun. "Squeeze-and-Excitation Networks." arXiv preprint arXiv:1709.01507 (2017).*
* [Densenet](https://arxiv.org/abs/1608.06993) - *Huang, Gao, et al. "Densely connected convolutional networks." CVPR, (2017).*

### Object Detection Architectures

| model | input size | param memory | feature memory | flops |
|-------|------------|--------------|----------------|-------|
| [rfcn-res50-pascal](reports/rfcn-res50-pascal.md) | 600 x 850 | 122 MB | 1 GB | 79 GFLOPS|
| [rfcn-res101-pascal](reports/rfcn-res101-pascal.md) | 600 x 850 | 194 MB | 2 GB | 117 GFLOPS|
| [ssd-pascal-vggvd-300](reports/ssd-pascal-vggvd-300.md) | 300 x 300 | 100 MB | 116 MB | 31 GFLOPS|
| [ssd-pascal-vggvd-512](reports/ssd-pascal-vggvd-512.md) | 512 x 512 | 104 MB | 337 MB | 91 GFLOPS|
| [ssd-pascal-mobilenet-ft](reports/ssd-pascal-mobilenet-ft.md) | 300 x 300 | 22 MB | 37 MB | 1 GFLOPs|
| [faster-rcnn-vggvd-pascal](reports/faster-rcnn-vggvd-pascal.md) | 600 x 850 | 523 MB | 600 MB | 172 GFLOPS|

The input sizes used are "typical" for each of the architectures listed, but can be varied.  *Anchor/priorbox* generation and *roi/psroi*-pooling are not included in flop estimates.  The *ssd-pascal-mobilenet-ft* detector uses the MobileNet feature extractor (the model used here was imported from the architecture made available by [chuanqi305](https://github.com/chuanqi305/MobileNet-SSD)).

**References:**

* [faster-rcnn](http://papers.nips.cc/paper/5638-faster-r-cnn-towards-real-time-object-detection-with-region-proposal-networks) - *Ren, Shaoqing, et al. "Faster R-CNN: Towards real-time object detection with region proposal networks." Advances in neural information processing systems. 2015..*  
* [r-fcn](https://arxiv.org/abs/1605.06409) - *Li, Yi, Kaiming He, and Jian Sun. "R-fcn: Object detection via region-based fully convolutional networks." Advances in Neural Information Processing Systems. 2016.*
* [ssd](https://link.springer.com/chapter/10.1007%2F978-3-319-46448-0_2) - *Liu, Wei, et al. "Ssd: Single shot multibox detector." European conference on computer vision. Springer, Cham, 2016.*
* [mobilenets](https://arxiv.org/abs/1704.04861) - *Howard, Andrew G., Menglong Zhu, Bo Chen, Dmitry Kalenichenko, Weijun Wang, Tobias Weyand, Marco Andreetto, and Hartwig Adam. "Mobilenets: Efficient convolutional neural networks for mobile vision applications." arXiv preprint arXiv:1704.04861 (2017).*


### Semantic Segmentation Architectures

| model | input size | param memory | feature memory | flops |
|-------|------------|--------------|----------------|-------|
| [pascal-fcn32s](reports/pascal-fcn32s.md) | 384 x 384 | 519 MB | 423 MB | 125 GFLOPS|
| [pascal-fcn16s](reports/pascal-fcn16s.md) | 384 x 384 | 514 MB | 424 MB | 125 GFLOPS|
| [pascal-fcn8s](reports/pascal-fcn8s.md) | 384 x 384 | 513 MB | 426 MB | 125 GFLOPS|
| [deeplab-vggvd-v2](reports/deeplab-vggvd-v2.md) | 513 x 513 | 144 MB | 755 MB | 202 GFLOPs|
| [deeplab-res101-v2](reports/deeplab-res101-v2.md) | 513 x 513 | 505 MB | 4 GB | 346 GFLOPs|

In this case, the input sizes are those which are typically taken as input crops during training.  The *deeplab-res101-v2* model uses multi-scale input, with scales `x1, x0.75, x0.5` (computed relative to the given input size).

**References:**

* [pascal-fcn](http://www.cv-foundation.org/openaccess/content_cvpr_2015/html/Long_Fully_Convolutional_Networks_2015_CVPR_paper.html) - *Long, Jonathan, Evan Shelhamer, and Trevor Darrell. "Fully convolutional networks for semantic segmentation." Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition. 2015..*
* [deeplab](https://arxiv.org/abs/1606.00915) - *DeepLab: Semantic Image Segmentation with Deep Convolutional Nets, Atrous Convolution, and Fully Connected CRFs
Liang-Chieh Chen^, George Papandreou^, Iasonas Kokkinos, Kevin Murphy, and Alan L. Yuille (^equal contribution)
Transactions on Pattern Analysis and Machine Intelligence (TPAMI)*

### Keypoint Detection Architectures

| model | input size | param memory | feature memory | flops |
|-------|------------|--------------|----------------|-------|
| [multipose-mpi](reports/multipose-mpi.md) | 368 x 368 | 196 MB | 245 MB | 134 GFLOPS|
| [multipose-coco](reports/multipose-coco.md) | 368 x 368 | 200 MB | 246 MB | 136 GFLOPS|

**References:**

* [multipose](https://arxiv.org/abs/1611.08050) - *Cao, Zhe, et al. "Realtime multi-person 2d pose estimation using part affinity fields." arXiv preprint arXiv:1611.08050 (2016)..*


<h3>Notes and Assumptions</h3>


The numbers for each architecture should be reasonably framework agnostic. It is assumed that all weights and activations are stored as floats (with 4 bytes per datum) and that all relus are performed in-place.  Fused multiply-adds are counted as single operations.

The numbers should be considered to be rough approximations -  modern hardware makes it very difficult to accurately count operations (and even if you could, pipelining etc. means that it is not necessarily a good estimate of inference time).

The tool for computing the estimates is implemented as a module for the [autonn](https://github.com/vlfeat/autonn) wrapper of matconvnet and is included in this [repo](core/burden.m), so feel free to take a look for extra details.  This module can be installed with the `vl_contrib` package manager (it has two dependencies which can be installed in a similar manner: [autonn](https://github.com/vlfeat/autonn) and [mcnExtraLayers](https://github.com/albanie/mcnExtraLayers)). Matconvnet versions of all of the models can be obtained from either [here](http://www.vlfeat.org/matconvnet/pretrained/) or [here](http://www.robots.ox.ac.uk/~albanie/mcn-models.html).

For further reading on the topic, the 2017 ICLR submission [An analysis of deep neural network models for practical applications](https://openreview.net/pdf?id=Bygq-H9eg) is interesting.  If you find any issues, or would like to add additional models, add an issue/PR.

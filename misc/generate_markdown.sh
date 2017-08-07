#!/bin/bash
# generate_markdown.sh generates a set of markdown tables
# for more a readable summary of convnet computational costs
#
# --------------------------------------------------------
# convnet-burden
# Licensed under The MIT License [see LICENSE.md for details]
# Copyright (C) 2017 Samuel Albanie 
# --------------------------------------------------------
add_links="false"

function gen_table() {
# generate markdown table summaries 

    res=`cat $1 | grep "MD::" | cut -f 1 -d ' ' --complement`
    echo "$res"

    # clean up dataset prefixes
    res=$(echo "$res" | sed "s/imagenet-//g")

    # update model names
    res=$(echo "$res" | sed "s/vgg-verydeep-\([0-9+]\)/vgg-vd-\1/g")
    res=$(echo "$res" | sed "s/vgg-\([a-z+]\)/vgg-\1/g")
    res=$(echo "$res" | sed "s/ssd-mcn-pascal-vggvd-\([0-9+]\)/ssd-pascal-\1/g")
    res=$(echo "$res" | sed "s/resnet-\([0-9+]\)/resnet-\1/g")
    res="${res/matconvnet-alex/alexnet}"
    res="${res/caffe-ref/caffenet}"

    # clean up suffixes and mcn notation
    res=$(echo "$res" | sed "s/_/-/g")
    res=$(echo "$res" | sed "s/-dag//g") 
    res=$(echo "$res" | sed "s/-pt-mcn//g") 

    # add links to download models
    if [ "$add_links" = "true" ] ; then
        mcn_home="(http://www.vlfeat.org/matconvnet/pretrained/)"
        imported="(http://www.robots.ox.ac.uk/~albanie/models.html)"
        res=$(echo "$res" | awk '{$2="\\["$2"\\]" ; print}')
        res=$(echo "$res" | sed 's/\\/ /g') 
        res="${res//]/]$mcn_home}"
        echo "$res"
    else
        echo "$res"
    fi
}

# point this out the dir containiing outputs of the compute_burdens.m script
LOGDIR="${HOME}/coding/libs/matconvnets/contrib-matconvnet/data/burden"

declare -a tasks=("cls" "det" "seg" "key")
for sfx in "${tasks[@]}"
do
   echo ""
   echo "task: ${sfx}"
   echo ""
   echo "| model | input size | param memory | feature memory | flops | "
   echo "|-------|------------|--------------|----------------|-------|"
   gen_table "${LOGDIR}/log-${sfx}.txt"
done

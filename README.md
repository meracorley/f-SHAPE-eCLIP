#Download eCLIP reads from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE149767
#Process and map reads with the eclip pipeline, available at https://github.com/yeolab/eclip
#Requires hg19 STAR reference as in https://github.com/YeoLab/eclip/tree/master/example/inputs/hg19chr19kbp550_starindex
#Requires hg19 STAR repetive element annotations as in https://github.com/YeoLab/eclip/tree/master/example/inputs/hg113seqs_repbase_starindex
#specify where required files/annotations are and run eCLIP pipeline with:
/bin/bash single_end_clip.yaml
#eCLIP pipeline outputs bed files of binding sites and bam files of mapped IP reads.

#Count mutation rates in these bam files with:
python counMutationsBam.py -h
#Outputs (.coverage files) to /coverage folders within folder for each sample.

#Generate fSHAPE reactivity profiles for any region or transcript (expressed as BED regions) with python bedReactivities.py -h

#DEPENDENCIES:
Bedtools
Samtools
Python libraries: numpy, pybedtools

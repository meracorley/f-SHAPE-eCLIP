#Pipeline branch of f-SHAPE-eCLIP. 

# This repo contains definition files for steps to be appended to the main eCLIP workflow:
1. Count mutation rates in these bam files with:
```bash
python counMutationsBam.py -h  # (Outputs (.coverage files) to /coverage folders within folder for each sample.)
```
2. Generate (f)SHAPE reactivity profiles for any region or transcript (expressed as BED regions) with:
```bash
python bedReactivities.py -h
```

### Installation/Steps to process your files (in progress):

1. Download eCLIP reads from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE149767

2. Install the required workflow and runner software as required by the core eCLIP pipeline: https://github.com/yeolab/eclip

3. In addition to the cwl files for the eCLIP pipeline, export the cwl files in this module are also visible/accessible as executables.

4. Run "wf_fshape_singleend"  # TODO

### eCLIP dependencies:
- cwltool
- docker

### f-SHAPE pipeline-specific Dependencies (already included with eCLIP):
- bedtools
- samtools,
- Python libraries: numpy, pybedtools

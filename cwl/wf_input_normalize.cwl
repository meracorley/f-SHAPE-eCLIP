#!/usr/bin/env cwltool

### Input normalization script for eCLIP/eCLIP-related datasets.

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement


inputs:

  ip_bam:
    type: File
  input_bam:
    type: File
  peaks:
    type: File
  chrom_sizes:
    type: File
  species: 
    type: string
  blacklist_file: 
    type: File
    
    
outputs:

  output_normed_bed:
    type: File
    outputSource: step_input_normalize_peaks/inputnormedBed
  output_normed_bed_full:
    type: File
    outputSource: step_input_normalize_peaks/inputnormedBedfull
  output_compressed_bed:
    type: File
    outputSource: step_compress_peaks/output_bed
  output_sorted_bed:
    type: File
    outputSource: step_sort_bed/sorted_bed
  output_blacklist_removed_bed:
    type: File
    outputSource: step_blacklist_remove/output_blacklist_removed_bed
  output_narrowpeak:
    type: File
    outputSource: step_bed_to_narrowpeak/output_narrowpeak
  output_fixed_bed:
    type: File
    outputSource: step_fix_bed_for_bigbed_conversion/output_fixed_bed
  output_bigbed:
    type: File
    outputSource: step_bed_to_bigbed/output_bigbed
  output_entropynum:
    type: File
    outputSource: step_calculate_entropy/output_entropynum
  output_sig_peaks:
    type: File
    outputSource: step_sigpeaks/output_bed

steps:

  step_ip_mapped_readnum:
    run: samtools-mappedreadnum.cwl
    in:
      input: ip_bam
      readswithoutbits:
        default: 4
      count:
        default: true
      output_name:
        default: ip_mapped_readnum.txt
    out: [output]

  step_input_mapped_readnum:
    run: samtools-mappedreadnum.cwl
    in:
      input: input_bam
      readswithoutbits:
        default: 4
      count:
        default: true
      output_name:
        default: input_mapped_readnum.txt
    out: [output]

  step_input_normalize_peaks:
    run: overlap_peakfi_with_bam_PE.cwl
    in:
      clipBamFile: ip_bam
      inputBamFile: input_bam
      peakFile: peaks
      clipReadnum: step_ip_mapped_readnum/output
      inputReadnum: step_input_mapped_readnum/output
    out: [
      inputnormedBed,
      inputnormedBedfull
    ]

  step_compress_peaks:
    run: peakscompress.cwl
    in:
      input_bed: step_input_normalize_peaks/inputnormedBed
    out: [output_bed]
  
  step_sort_bed:
    run: sort-bed.cwl
    in:
      unsorted_bed: step_compress_peaks/output_bed
    out: [sorted_bed]
    
  step_blacklist_remove:
    run: blacklist-remove.cwl
    in:
      input_bed: step_sort_bed/sorted_bed
      blacklist_file: blacklist_file
    out: [output_blacklist_removed_bed]
    
  step_bed_to_narrowpeak:
    run: bed_to_narrowpeak.cwl
    in:
      input_bed: step_blacklist_remove/output_blacklist_removed_bed
      species: species
    out: [output_narrowpeak]
    
  step_fix_bed_for_bigbed_conversion:
    run: fix_bed_for_bigbed_conversion.cwl
    in:
      input_bed: step_blacklist_remove/output_blacklist_removed_bed
    out: [output_fixed_bed]
    
  step_bed_to_bigbed:
    run: bed_to_bigbed.cwl
    in:
      input_bed: step_fix_bed_for_bigbed_conversion/output_fixed_bed
      chrom_sizes: chrom_sizes
    out: [output_bigbed]

  step_calculate_entropy:
    run: calculate_entropy.cwl
    in:
      full: step_input_normalize_peaks/inputnormedBedfull
      ip_mapped: step_ip_mapped_readnum/output
      input_mapped: step_input_mapped_readnum/output
    out: [output_entropynum]

  step_sigpeaks:
    run: filter_sigpeaks.cwl
    in: 
      peaks: step_blacklist_remove/output_blacklist_removed_bed
    out: 
      [output_bed]
      
doc: |
  This workflow performs input normalization

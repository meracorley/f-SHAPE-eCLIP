#!/usr/bin/env cwltool

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:

  dataset:
    type: string

  speciesGenomeDir:
    type: Directory

  repeatElementGenomeDir:
    type: Directory

  species:
    type: string

  chrom_sizes:
    type: File

  sample:
    type:
      # array of 3, one (treated) IP, one (untreated) IP, one Input
      type: array
      items:
        type: record
        fields:
          read1:
            type: File
          adapters:
            type: File
          name:
            type: string
            
  blacklist_file:
    type: File
    
    
outputs:


  ### Demultiplexed outputs ###


  output_ip_b1_demuxed_fastq_r1:
    type: File
    outputSource: step_ip_untreated_alignment/b1_demuxed_fastq_r1

  output_input_b1_demuxed_fastq_r1:
    type: File
    outputSource: step_input_alignment/b1_demuxed_fastq_r1


  ### Trimmed outputs ###


  output_ip_b1_trimx1_fastq:
    type: File[]
    outputSource: step_ip_untreated_alignment/b1_trimx1_fastq
  output_ip_b1_trimx1_metrics:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx1_metrics
  output_ip_b1_trimx1_fastqc_report:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx1_fastqc_report
  output_ip_b1_trimx1_fastqc_stats:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx1_fastqc_stats
  output_ip_b1_trimx2_fastq:
    type: File[]
    outputSource: step_ip_untreated_alignment/b1_trimx2_fastq
  output_ip_b1_trimx2_metrics:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx2_metrics
  output_ip_b1_trimx2_fastqc_report:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx2_fastqc_report
  output_ip_b1_trimx2_fastqc_stats:
    type: File
    outputSource: step_ip_untreated_alignment/b1_trimx2_fastqc_stats
    
  output_input_b1_trimx1_fastq:
    type: File[]
    outputSource: step_input_alignment/b1_trimx1_fastq
  output_input_b1_trimx1_metrics:
    type: File
    outputSource: step_input_alignment/b1_trimx1_metrics
  output_input_b1_trimx1_fastqc_report:
    type: File
    outputSource: step_input_alignment/b1_trimx1_fastqc_report
  output_input_b1_trimx1_fastqc_stats:
    type: File
    outputSource: step_input_alignment/b1_trimx1_fastqc_stats
  output_input_b1_trimx2_fastq:
    type: File[]
    outputSource: step_input_alignment/b1_trimx2_fastq
  output_input_b1_trimx2_metrics:
    type: File
    outputSource: step_input_alignment/b1_trimx2_metrics
  output_input_b1_trimx2_fastqc_report:
    type: File
    outputSource: step_input_alignment/b1_trimx2_fastqc_report
  output_input_b1_trimx2_fastqc_stats:
    type: File
    outputSource: step_input_alignment/b1_trimx2_fastqc_stats


  ### Repeat mapping outputs ###


  output_ip_b1_maprepeats_mapped_to_genome:
    type: File
    outputSource: step_ip_untreated_alignment/b1_maprepeats_mapped_to_genome
  output_ip_b1_maprepeats_stats:
    type: File
    outputSource: step_ip_untreated_alignment/b1_maprepeats_stats
  output_ip_b1_maprepeats_star_settings:
    type: File
    outputSource: step_ip_untreated_alignment/b1_maprepeats_star_settings
  output_ip_b1_sorted_unmapped_fastq:
    type: File
    outputSource: step_ip_untreated_alignment/b1_sorted_unmapped_fastq

  output_input_b1_maprepeats_mapped_to_genome:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_mapped_to_genome
  output_input_b1_maprepeats_stats:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_stats
  output_input_b1_maprepeats_star_settings:
    type: File
    outputSource: step_input_alignment/b1_maprepeats_star_settings
  output_input_b1_sorted_unmapped_fastq:
    type: File
    outputSource: step_input_alignment/b1_sorted_unmapped_fastq


  ### Genomic mapping outputs ###


  output_ip_b1_mapgenome_mapped_to_genome:
    type: File
    outputSource: step_ip_untreated_alignment/b1_mapgenome_mapped_to_genome
  output_ip_b1_mapgenome_stats:
    type: File
    outputSource: step_ip_untreated_alignment/b1_mapgenome_stats
  output_ip_b1_mapgenome_star_settings:
    type: File
    outputSource: step_ip_untreated_alignment/b1_mapgenome_star_settings

  output_input_b1_mapgenome_mapped_to_genome:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_mapped_to_genome
  output_input_b1_mapgenome_stats:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_stats
  output_input_b1_mapgenome_star_settings:
    type: File
    outputSource: step_input_alignment/b1_mapgenome_star_settings


  ### Duplicate removal outputs ###


  output_ip_b1_pre_rmdup_sorted_bam:
    type: File
    outputSource: step_ip_untreated_alignment/b1_output_pre_rmdup_sorted_bam
  output_ip_b1_barcodecollapsese_metrics:
    type: File
    outputSource: step_ip_untreated_alignment/b1_output_barcodecollapsese_metrics
  output_ip_b1_rmdup_sorted_bam:
    type: File
    outputSource: step_ip_untreated_alignment/b1_output_rmdup_sorted_bam

  output_input_b1_pre_rmdup_sorted_bam:
    type: File
    outputSource: step_input_alignment/b1_output_pre_rmdup_sorted_bam
  output_input_b1_barcodecollapsese_metrics:
    type: File
    outputSource: step_input_alignment/b1_output_barcodecollapsese_metrics
  output_input_b1_rmdup_sorted_bam:
    type: File
    outputSource: step_input_alignment/b1_output_rmdup_sorted_bam


  ### Bigwig files ###


  output_ip_pos_bw:
    type: File
    outputSource: step_ip_untreated_alignment/output_pos_bw
  output_ip_neg_bw:
    type: File
    outputSource: step_ip_untreated_alignment/output_neg_bw

  output_input_pos_bw:
    type: File
    outputSource: step_input_alignment/output_pos_bw
  output_input_neg_bw:
    type: File
    outputSource: step_input_alignment/output_neg_bw


  ### Peak outputs (treated) ###

  output_treated_clipper_bed:
    type: File
    outputSource: step_clipper_treated/output_bed
    
  output_treated_inputnormed_peaks:
    type: File
    outputSource: step_inputnorm_treated/output_normed_bed
  output_treated_compressed_peaks:
    type: File
    outputSource: step_inputnorm_treated/output_compressed_bed
  
  output_treated_blacklist_removed_bed:
    type: File
    outputSource: step_inputnorm_treated/output_blacklist_removed_bed
  output_treated_narrowpeak:
    type: File
    outputSource: step_inputnorm_treated/output_narrowpeak
  output_treated_fixed_bed:
    type: File
    outputSource: step_inputnorm_treated/output_fixed_bed
  output_treated_bigbed:
    type: File
    outputSource: step_inputnorm_treated/output_bigbed
  output_treated_entropynum:
    type: File
    outputSource: step_inputnorm_treated/output_entropynum
  output_treated_sigpeaks:
    type: File
    outputSource: step_inputnorm_treated/output_sig_peaks

  ### Peak outputs (untreated) ###

  output_untreated_clipper_bed:
    type: File
    outputSource: step_clipper_untreated/output_bed
    
  output_untreated_inputnormed_peaks:
    type: File
    outputSource: step_inputnorm_untreated/output_normed_bed
  output_untreated_compressed_peaks:
    type: File
    outputSource: step_inputnorm_untreated/output_compressed_bed
  
  output_untreated_blacklist_removed_bed:
    type: File
    outputSource: step_inputnorm_untreated/output_blacklist_removed_bed
  output_untreated_narrowpeak:
    type: File
    outputSource: step_inputnorm_untreated/output_narrowpeak
  output_untreated_fixed_bed:
    type: File
    outputSource: step_inputnorm_untreated/output_fixed_bed
  output_untreated_bigbed:
    type: File
    outputSource: step_inputnorm_untreated/output_bigbed
  output_untreated_entropynum:
    type: File
    outputSource: step_inputnorm_untreated/output_entropynum
  output_untreated_sigpeaks:
    type: File
    outputSource: step_inputnorm_untreated/output_sig_peaks

  ### fSHAPE ###
  
  output_count_mutations_treated:
    type: Directory
    outputSource: 
      step_count_mutations_treated/outputDataPath
  output_count_mutations_untreated:
    type: Directory
    outputSource: 
      step_count_mutations_untreated/outputDataPath
  output_count_mutations_input:
    type: Directory
    outputSource: 
      step_count_mutations_input/outputDataPath
      
steps:

###########################################################################
# Upstream
###########################################################################

  step_ip_treated_alignment:
    run: wf_clipseqcore_se_1barcode.cwl
    in:
      read:
        source: sample
        valueFrom: |
          ${
            return self[0];
          }
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
    out: [
      b1_demuxed_fastq_r1,
      b1_trimx1_fastq,
      b1_trimx1_metrics,
      b1_trimx1_fastqc_report,
      b1_trimx1_fastqc_stats,
      b1_trimx2_fastq,
      b1_trimx2_metrics,
      b1_trimx2_fastqc_report,
      b1_trimx2_fastqc_stats,
      b1_maprepeats_mapped_to_genome,
      b1_maprepeats_stats,
      b1_maprepeats_star_settings,
      b1_sorted_unmapped_fastq,
      b1_mapgenome_mapped_to_genome,
      b1_mapgenome_stats,
      b1_mapgenome_star_settings,
      b1_output_pre_rmdup_sorted_bam,
      b1_output_barcodecollapsese_metrics,
      b1_output_rmdup_sorted_bam,
      output_pos_bw,
      output_neg_bw
    ]
    
  step_ip_untreated_alignment:
    run: wf_clipseqcore_se_1barcode.cwl
    in:
      read:
        source: sample
        valueFrom: |
          ${
            return self[1];
          }
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
    out: [
      b1_demuxed_fastq_r1,
      b1_trimx1_fastq,
      b1_trimx1_metrics,
      b1_trimx1_fastqc_report,
      b1_trimx1_fastqc_stats,
      b1_trimx2_fastq,
      b1_trimx2_metrics,
      b1_trimx2_fastqc_report,
      b1_trimx2_fastqc_stats,
      b1_maprepeats_mapped_to_genome,
      b1_maprepeats_stats,
      b1_maprepeats_star_settings,
      b1_sorted_unmapped_fastq,
      b1_mapgenome_mapped_to_genome,
      b1_mapgenome_stats,
      b1_mapgenome_star_settings,
      b1_output_pre_rmdup_sorted_bam,
      b1_output_barcodecollapsese_metrics,
      b1_output_rmdup_sorted_bam,
      output_pos_bw,
      output_neg_bw
    ]
    
  step_input_alignment:
    run: wf_clipseqcore_se_1barcode.cwl
    in:
      read:
        source: sample
        valueFrom: |
          ${
            return self[2];
          }
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
    out: [
      b1_demuxed_fastq_r1,
      b1_trimx1_fastq,
      b1_trimx1_metrics,
      b1_trimx1_fastqc_report,
      b1_trimx1_fastqc_stats,
      b1_trimx2_fastq,
      b1_trimx2_metrics,
      b1_trimx2_fastqc_report,
      b1_trimx2_fastqc_stats,
      b1_maprepeats_mapped_to_genome,
      b1_maprepeats_stats,
      b1_maprepeats_star_settings,
      b1_sorted_unmapped_fastq,
      b1_mapgenome_mapped_to_genome,
      b1_mapgenome_stats,
      b1_mapgenome_star_settings,
      b1_output_pre_rmdup_sorted_bam,
      b1_output_barcodecollapsese_metrics,
      b1_output_rmdup_sorted_bam,
      output_pos_bw,
      output_neg_bw
    ]

  step_clipper_treated:
    run: clipper.cwl
    in:
      species: species
      bam: step_ip_treated_alignment/b1_output_rmdup_sorted_bam
      outfile:
        default: ""
    out:
      [output_bed]
  
  step_clipper_untreated:
    run: clipper.cwl
    in:
      species: species
      bam: step_ip_untreated_alignment/b1_output_rmdup_sorted_bam
      outfile:
        default: ""
    out:
      [output_bed]
      
###########################################################################
# Downstream (Call peaks)
###########################################################################

  step_inputnorm_treated:
    run: wf_input_normalize.cwl
    in:
      ip_bam: step_ip_treated_alignment/b1_output_rmdup_sorted_bam
      input_bam: step_input_alignment/b1_output_rmdup_sorted_bam
      peaks: step_clipper_treated/output_bed
      chrom_sizes: chrom_sizes
      species: species
      blacklist_file: blacklist_file
    out: [
      output_normed_bed,
      output_normed_bed_full,
      output_compressed_bed,
      output_sorted_bed,
      output_blacklist_removed_bed,
      output_narrowpeak,
      output_fixed_bed,
      output_bigbed,
      output_entropynum,
      output_sig_peaks
    ]

  step_inputnorm_untreated:
    run: wf_input_normalize.cwl
    in:
      ip_bam: step_ip_untreated_alignment/b1_output_rmdup_sorted_bam
      input_bam: step_input_alignment/b1_output_rmdup_sorted_bam
      peaks: step_clipper_untreated/output_bed
      chrom_sizes: chrom_sizes
      species: species
      blacklist_file: blacklist_file
    out: [
      output_normed_bed,
      output_normed_bed_full,
      output_compressed_bed,
      output_sorted_bed,
      output_blacklist_removed_bed,
      output_narrowpeak,
      output_fixed_bed,
      output_bigbed,
      output_entropynum,
      output_sig_peaks
    ]
    

###########################################################################
# Downstream (f-SHAPE eCLIP)
###########################################################################

  step_count_mutations_treated:
    run: countMutationsBam.cwl
    in:
      clipBamFile: step_ip_treated_alignment/b1_output_rmdup_sorted_bam
    out: 
      - outputDataPath
      
  step_count_mutations_untreated:
    run: countMutationsBam.cwl
    in:
      clipBamFile: step_ip_untreated_alignment/b1_output_rmdup_sorted_bam
    out: 
      - outputDataPath

  step_count_mutations_input:
    run: countMutationsBam.cwl
    in:
      clipBamFile: step_input_alignment/b1_output_rmdup_sorted_bam
    out: 
      - outputDataPath

#!/usr/bin/env cwltool

doc: |
  The "main" workflow. Takes fastq files generated using the seCLIP protocol 
  (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5991800/) and outputs 
  candidate RBP binding regions (peaks). 

  runs:
    wf_get_peaks_se.cwl through scatter across multiple samples.

cwlVersion: v1.0
class: Workflow

requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement

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

  samples:
    type:
      type: array  # array of two replicates
      items:
        type: array  # array of one (treated), one (untreated), one (input)
        items:
          type: record
          fields:
            read1:
              type: File
            name:
              type: string
            adapters:
              type: File

  blacklist_file: 
    type: File
  
  gtfdb:
    type: File
  
  genome_fasta:
    type: File
    
outputs:


  ### DEMULTIPLEXED READ OUTPUTS ###

  output_ip_b1_demuxed_fastq_r1:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_demuxed_fastq_r1

  output_input_b1_demuxed_fastq_r1:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_demuxed_fastq_r1


  ### TRIMMED ROUND1 OUTPUTS ###

  output_ip_b1_trimx1_fastq:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: step_get_peaks/output_ip_b1_trimx1_fastq
  output_ip_b1_trimx1_metrics:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx1_metrics

  output_input_b1_trimx1_fastq:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: step_get_peaks/output_input_b1_trimx1_fastq
  output_input_b1_trimx1_metrics:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx1_metrics


  ### FASTQC ROUND1 OUTPUTS ###
  
  output_ip_b1_trimx1_fastqc_report:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx1_fastqc_report
  output_ip_b1_trimx1_fastqc_stats:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx1_fastqc_stats
  output_input_b1_trimx1_fastqc_report:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx1_fastqc_report
  output_input_b1_trimx1_fastqc_stats:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx1_fastqc_stats


  ### TRIMMED ROUND2 OUTPUTS ###

  output_ip_b1_trimx2_fastq:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: step_get_peaks/output_ip_b1_trimx2_fastq
  output_ip_b1_trimx2_metrics:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx2_metrics
  
  output_input_b1_trimx2_fastq:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: step_get_peaks/output_input_b1_trimx2_fastq
  output_input_b1_trimx2_metrics:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx2_metrics


  ### FASTQC ROUND2 OUTPUTS ###
  
  output_ip_b1_trimx2_fastqc_report:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx2_fastqc_report
  output_ip_b1_trimx2_fastqc_stats:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_trimx2_fastqc_stats

  output_input_b1_trimx2_fastqc_report:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx2_fastqc_report
  output_input_b1_trimx2_fastqc_stats:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_trimx2_fastqc_stats
    
    
  ### REPEAT MAPPING OUTPUTS ###
  
  output_ip_b1_maprepeats_mapped_to_genome:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_maprepeats_mapped_to_genome
  output_ip_b1_maprepeats_stats:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_maprepeats_stats
  output_ip_b1_maprepeats_star_settings:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_maprepeats_star_settings
  output_ip_b1_sorted_unmapped_fastq:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_sorted_unmapped_fastq

  output_input_b1_maprepeats_mapped_to_genome:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_maprepeats_mapped_to_genome
  output_input_b1_maprepeats_stats:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_maprepeats_stats
  output_input_b1_maprepeats_star_settings:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_maprepeats_star_settings
  output_input_b1_sorted_unmapped_fastq:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_sorted_unmapped_fastq


  ### GENOME MAPPING OUTPUTS ###

  output_ip_b1_mapgenome_mapped_to_genome:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_mapgenome_mapped_to_genome
  output_ip_b1_mapgenome_stats:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_mapgenome_stats
  output_ip_b1_mapgenome_star_settings:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_mapgenome_star_settings

  output_input_b1_mapgenome_mapped_to_genome:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_mapgenome_mapped_to_genome
  output_input_b1_mapgenome_stats:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_mapgenome_stats
  output_input_b1_mapgenome_star_settings:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_mapgenome_star_settings


  ### DUPLICATE REMOVAL OUTPUTS ###

  output_ip_b1_pre_rmdup_sorted_bam:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_pre_rmdup_sorted_bam
  output_ip_b1_barcodecollapsese_metrics:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_barcodecollapsese_metrics
  output_ip_b1_rmdup_sorted_bam:
    type: File[]
    outputSource: step_get_peaks/output_ip_b1_rmdup_sorted_bam

  output_input_b1_pre_rmdup_sorted_bam:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_pre_rmdup_sorted_bam
  output_input_b1_barcodecollapsese_metrics:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_barcodecollapsese_metrics
  output_input_b1_rmdup_sorted_bam:
    type: File[]
    outputSource: step_get_peaks/output_input_b1_rmdup_sorted_bam


  ### BIGWIG FILES ###

  output_ip_pos_bw:
    type: File[]
    outputSource: step_get_peaks/output_ip_pos_bw
  output_ip_neg_bw:
    type: File[]
    outputSource: step_get_peaks/output_ip_neg_bw
  output_input_pos_bw:
    type: File[]
    outputSource: step_get_peaks/output_input_pos_bw
  output_input_neg_bw:
    type: File[]
    outputSource: step_get_peaks/output_input_neg_bw


  ### PEAK OUTPUTS (treated) ###

  output_treated_clipper_bed:
    type: File[]
    outputSource: step_get_peaks/output_treated_clipper_bed
  output_treated_inputnormed_peaks:
    type: File[]
    outputSource: step_get_peaks/output_treated_inputnormed_peaks
  output_treated_compressed_peaks:
    type: File[]
    outputSource: step_get_peaks/output_treated_compressed_peaks
  output_treated_blacklist_removed_bed:
    type: File[]
    outputSource: step_get_peaks/output_treated_blacklist_removed_bed
  output_treated_narrowpeak:
    type: File[]
    outputSource: step_get_peaks/output_treated_narrowpeak
  output_treated_fixed_bed:
    type: File[]
    outputSource: step_get_peaks/output_treated_fixed_bed
  output_treated_bigbed:
    type: File[]
    outputSource: step_get_peaks/output_treated_bigbed
  output_treated_entropynum:
    type: File[]
    outputSource: step_get_peaks/output_treated_entropynum
  output_treated_sigpeaks:
    type: File[]
    outputSource: step_get_peaks/output_treated_sigpeaks


  ### PEAK OUTPUTS (untreated) ###

  output_untreated_clipper_bed:
    type: File[]
    outputSource: step_get_peaks/output_untreated_clipper_bed
  output_untreated_inputnormed_peaks:
    type: File[]
    outputSource: step_get_peaks/output_untreated_inputnormed_peaks
  output_untreated_compressed_peaks:
    type: File[]
    outputSource: step_get_peaks/output_untreated_compressed_peaks
  output_untreated_blacklist_removed_bed:
    type: File[]
    outputSource: step_get_peaks/output_untreated_blacklist_removed_bed
  output_untreated_narrowpeak:
    type: File[]
    outputSource: step_get_peaks/output_untreated_narrowpeak
  output_untreated_fixed_bed:
    type: File[]
    outputSource: step_get_peaks/output_untreated_fixed_bed
  output_untreated_bigbed:
    type: File[]
    outputSource: step_get_peaks/output_untreated_bigbed
  output_untreated_entropynum:
    type: File[]
    outputSource: step_get_peaks/output_untreated_entropynum
  output_untreated_sigpeaks:
    type: File[]
    outputSource: step_get_peaks/output_untreated_sigpeaks


  ### fSHAPE OUTPUTS ###
  
  output_count_mutations_treated:
    type: Directory[]
    outputSource: step_get_peaks/output_count_mutations_treated
  output_count_mutations_untreated:
    type: Directory[]
    outputSource: step_get_peaks/output_count_mutations_untreated
  output_count_mutations_input:
    type: Directory[]
    outputSource: step_get_peaks/output_count_mutations_input
  output_annotated_treated_sigpeaks:
    type: File[]
    outputSource: step_annotate_treated/output_file
  output_annotated_untreated_sigpeaks:
    type: File[]
    outputSource: step_annotate_untreated/output_file
  output_coords:
    type: File
    outputSource: step_sig_gene_coords/coords_bed
  output_maps:
    type: File[]
    outputSource: step_bedReactivities/output_maps
  output_bedgraphs:
    type: File[]
    outputSource: step_bedReactivities/output_bedgraphs
  output_merged_bedgraphs:
    type: File[]
    outputSource: step_merge/merged_bedgraph
  output_bigwigs:
    type: File[]
    outputSource: step_bedGraphToBigWig/bw

steps:

  step_get_peaks:
    run: wf_get_peaks_se_fshape.cwl
    scatter: sample
    in:
      dataset: dataset
      speciesGenomeDir: speciesGenomeDir
      repeatElementGenomeDir: repeatElementGenomeDir
      species: species
      chrom_sizes: chrom_sizes
      sample: samples
      blacklist_file: blacklist_file
    out: [
      output_ip_b1_demuxed_fastq_r1,
      output_input_b1_demuxed_fastq_r1,
      output_ip_b1_trimx1_fastq,
      output_ip_b1_trimx1_metrics,
      output_ip_b1_trimx1_fastqc_report,
      output_ip_b1_trimx1_fastqc_stats,
      output_input_b1_trimx1_fastq,
      output_input_b1_trimx1_metrics,
      output_input_b1_trimx1_fastqc_report,
      output_input_b1_trimx1_fastqc_stats,
      output_ip_b1_trimx2_fastq,
      output_ip_b1_trimx2_metrics,
      output_ip_b1_trimx2_fastqc_report,
      output_ip_b1_trimx2_fastqc_stats,
      output_input_b1_trimx2_fastq,
      output_input_b1_trimx2_metrics,
      output_input_b1_trimx2_fastqc_report,
      output_input_b1_trimx2_fastqc_stats,
      output_ip_b1_maprepeats_mapped_to_genome,
      output_ip_b1_maprepeats_stats,
      output_ip_b1_maprepeats_star_settings,
      output_ip_b1_sorted_unmapped_fastq,
      output_input_b1_maprepeats_mapped_to_genome,
      output_input_b1_maprepeats_stats,
      output_input_b1_maprepeats_star_settings,
      output_input_b1_sorted_unmapped_fastq,
      output_ip_b1_mapgenome_mapped_to_genome,
      output_ip_b1_mapgenome_stats,
      output_ip_b1_mapgenome_star_settings,
      output_ip_b1_pre_rmdup_sorted_bam,
      output_ip_b1_barcodecollapsese_metrics,
      output_ip_b1_rmdup_sorted_bam,
      output_input_b1_mapgenome_mapped_to_genome,
      output_input_b1_mapgenome_stats,
      output_input_b1_mapgenome_star_settings,
      output_input_b1_pre_rmdup_sorted_bam,
      output_input_b1_barcodecollapsese_metrics,
      output_input_b1_rmdup_sorted_bam,
      output_ip_pos_bw,
      output_ip_neg_bw,
      output_input_pos_bw,
      output_input_neg_bw,
      output_untreated_clipper_bed,
      output_untreated_inputnormed_peaks,
      output_untreated_compressed_peaks,
      output_untreated_blacklist_removed_bed,
      output_untreated_narrowpeak,
      output_untreated_fixed_bed,
      output_untreated_bigbed,
      output_untreated_entropynum,
      output_untreated_sigpeaks,
      output_treated_clipper_bed,
      output_treated_inputnormed_peaks,
      output_treated_compressed_peaks,
      output_treated_blacklist_removed_bed,
      output_treated_narrowpeak,
      output_treated_fixed_bed,
      output_treated_bigbed,
      output_treated_entropynum,
      output_treated_sigpeaks,
      output_count_mutations_treated,
      output_count_mutations_untreated,
      output_count_mutations_input
    ]

  step_annotate_treated:
    run: annotator.cwl
    scatter: input
    in:
      gtfdb: gtfdb
      species: species
      input: step_get_peaks/output_treated_sigpeaks
    out:
      [output_file]
      
  step_annotate_untreated:
    run: annotator.cwl
    scatter: input
    in:
      gtfdb: gtfdb
      species: species
      input: step_get_peaks/output_untreated_sigpeaks
    out:
      [output_file]
      
  step_sig_gene_coords:
    run: gene_coords.cwl
    in:
      gtfdb: gtfdb
      peaks: 
        source: [
          step_annotate_treated/output_file,
          step_annotate_untreated/output_file
        ]
        linkMerge: merge_flattened
    out: [coords_bed]
  
  step_bedReactivities:
    run: bedReactivities.cwl
    in: 
      hist: step_sig_gene_coords/coords_bed
      genome: genome_fasta
      treated_input: step_get_peaks/output_count_mutations_treated
      untreated_input: step_get_peaks/output_count_mutations_untreated
      output_prefix: dataset
    out: [output_maps, output_bedgraphs]
  
  step_bedgraph:
    run: sort-bedGraph.cwl
    scatter: unsorted_bedgraph
    in:
      unsorted_bedgraph: step_bedReactivities/output_bedgraphs
    out: [sorted_bedgraph]
  
  step_merge:
    run: bedtools-merge.cwl
    scatter: input_bedgraph
    in:
      input_bedgraph: step_bedgraph/sorted_bedgraph
    out: [merged_bedgraph]
      
  step_bedGraphToBigWig:
    run: bedGraphToBigWig.cwl
    scatter: bedgraph
    in:
      bedgraph: step_merge/merged_bedgraph
      chromsizes: chrom_sizes
    out: [bw]
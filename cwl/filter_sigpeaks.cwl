#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints: 
  - class: DockerRequirement
    dockerPull: brianyee/fshape:347dd60
    
baseCommand: [filter_peaks.py]

inputs:

  peaks:
    type: File
    inputBinding:
      position: 0
      prefix: --peaks
    doc: "input-normalized peaks without filtering (-log10p and l2fc in cols 4 and 5 respectively)"
  
  l10p:
    type: float
    default: 3.0
    inputBinding: 
      position: 1
      prefix: --l10p
      
  l2fc:
    type: float
    default: 3.0
    inputBinding: 
      position: 1
      prefix: --l2fc
      
  outfile:
    type: string
    default: ""
    inputBinding:
      position: 10
      prefix: --output_peaks
      valueFrom: |
        ${
          if (inputs.outfile == "") {
            return inputs.peaks.nameroot + ".sig.bed";
          }
          else {
            return inputs.outfile;
          }
        }

outputs:

  output_bed:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.outfile == "") {
            return inputs.peaks.nameroot + ".sig.bed";
          }
          else {
            return inputs.outfile;
          }
        }

doc: |
  Simple script to filter significant peaks
  usage: filter_peaks.py [-h] --peaks PEAKS [--output_peaks OUTPUT_PEAKS]
                       [--l10p L10P] [--l2fc L2FC]
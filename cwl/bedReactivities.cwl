#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 8000

hints: 
  - class: DockerRequirement
    dockerPull: brianyee/fshape:347dd60

baseCommand: [bedReactivities.py]

inputs:
    
  # IP BAM file
  hist:
    type: File
    inputBinding:
      position: 1
      prefix: -i
  genome:
    type: File
    inputBinding:
      position: 2
      prefix: -g
  treated_input:
    type:
      type: array
      items: Directory
      inputBinding:
        prefix: -a
        separate: false
  untreated_input:
    type:
      type: array
      items: Directory
      inputBinding:
        prefix: -b
        separate: false
  output_prefix:
    type: string
    inputBinding:
      position: 5
      prefix: -o

outputs:

  output_maps:
    type: File[]
    outputBinding:
      glob: "*.map"
  output_bedgraphs:
    type: File[]
    outputBinding:
      glob: "*.bedgraph"

doc: |
  This tool wraps bedReactivities.py
    Usage: bedReactivities.py -h

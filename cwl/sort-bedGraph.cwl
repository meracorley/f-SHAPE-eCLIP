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
    dockerPull: brianyee/bedtools:2.27.1
    
baseCommand: [sort]

arguments: [
  "-k1,1",
  "-k2,2n"
  ]

inputs:

  unsorted_bedgraph:
    type: File
    inputBinding:
      position: 1

stdout: $(inputs.unsorted_bedgraph.nameroot).sorted.bedGraph

outputs:

  sorted_bedgraph:
    type: File
    outputBinding:
      glob: $(inputs.unsorted_bedgraph.nameroot).sorted.bedGraph

doc: |
  This tool wraps unix sort to sort a bedGraph file.
  
  Usage: sort -k1,1 -k2,2n unsorted.bedGraph > sorted.bedGraph

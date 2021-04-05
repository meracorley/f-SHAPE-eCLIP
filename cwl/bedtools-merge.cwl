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
    
baseCommand: [bedtools, merge]

arguments: ["-d", "-1", "-c", "4", "-o", "mean"]

inputs:

  input_bedgraph:
    type: File
    inputBinding:
      position: 1
      prefix: -i
    label: ""

stdout: $(inputs.input_bedgraph.nameroot).merged.bedGraph

outputs:

  merged_bedgraph:
    type: File
    outputBinding:
      glob: $(inputs.input_bedgraph.nameroot).merged.bedGraph

doc: |
  bedtools merge -d -1 -c 4 -o mean -i SLBP.pos.strand.sorted.bedgraph > SLBP.pos.strand.sorted.merged.bedgraph

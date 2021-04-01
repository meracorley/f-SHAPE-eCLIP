#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 8000
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.bedgraph)
        writable: true

hints:
  - class: DockerRequirement
    dockerPull: brianyee/makebigwigfiles:0.0.3

baseCommand: [bedGraphToBigWig]

inputs:

  bedgraph:
     type: File
     inputBinding:
       position: 1

  chromsizes:
    type: File
    inputBinding:
      position: 2

  bigwig:
    default: ""
    type: string
    inputBinding:
      position: 3
      valueFrom: |
        ${
          if (inputs.bigwig == "") {
            return inputs.bedgraph.nameroot + ".bigWig";
          }
          else {
            return inputs.bigwig;
          }
        }
        
outputs:

  bw:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.bigwig == "") {
            return inputs.bedgraph.nameroot + ".bigWig";
          }
          else {
            return inputs.bigwig;
          }
        }

doc: |
  Creates bigwig files from bedgraph files (bedGraphToBigWig)
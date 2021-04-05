#!/usr/bin/env cwltool

cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement

hints: 
  - class: DockerRequirement
    dockerPull: brianyee/fshape:347dd60
    
baseCommand: [gene_coords.py]

inputs:

  peaks:
    type: File[]?
    inputBinding:
      position: 1
      prefix: --annotated_peaks
    label: "input BED6 file"
    doc: "input unannotated BED6 file"

  output:
    type: string
    default: ""
    inputBinding:
      position: 2
      prefix: --output
      valueFrom: |
        ${
          if (inputs.output == "") {
            return "coords.txt";
          }
          else {
            return inputs.output;
          }
        }
    label: "output tsv file"
    doc: "annotated tabbed file"

  gtfdb:
    type: File
    inputBinding:
      position: 3
      prefix: --gtfdb

outputs:

  coords_bed:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.output == "") {
            return "coords.txt";
          }
          else {
            return inputs.output;
          }
        }
    label: "output"
    doc: "File containing output gene coordinates"



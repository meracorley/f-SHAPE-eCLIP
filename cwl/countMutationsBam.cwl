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
      - entry: $(inputs.clipBamFile)
        writable: true
        
# hints: 
#   - class: DockerRequirement
#     dockerPull: brianyee/fshape-eclip:0.0.1
    
baseCommand: [countMutationsBam.py]

inputs:

  # IP BAM file
  clipBamFile:
    type: File
    inputBinding:
      position: 1
      prefix: --bamfile

  dataPath:
    type: string
    default: ""
    inputBinding:
      position: 2
      prefix: --data_path
      valueFrom: |
        ${
          if (inputs.dataPath == "") {
            return inputs.clipBamFile.nameroot;
          }
          else {
            return inputs.dataPath;
          }
        }

outputs:

  outputDataPath:
    type: Directory
    outputBinding:
      glob: |
        ${
          if (inputs.dataPath == "") {
            return inputs.clipBamFile.nameroot + "/coverage";
          }
          else {
            return inputs.dataPath + "/coverage";
          }
        }
        
doc: |
  This tool wraps countMutationsBam.py
    Usage: countMutationsBam.py --bamfile BAM --data_path DATAPATH

#!/usr/bin/env cwltool

class: CommandLineTool

cwlVersion: v1.0

hints: 
  - class: DockerRequirement
    dockerPull: brianyee/fshape:347dd60
    
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: $(inputs.newname)
        entry: $(inputs.srcdir)
        writable: true

baseCommand: "true"

inputs:
  srcdir: Directory
  newname: string

outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.newname)

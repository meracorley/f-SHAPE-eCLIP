#!/usr/bin/env python

import os
import re
import subprocess
import sys
import getopt
from argparse import ArgumentParser
from argparse import RawDescriptionHelpFormatter

def usage():
    print('''python countMutationsBam.py -p dataset [...]
        Options:
        -h, --help

        REQUIRED
        -p, --probing   Specify probing dataset: SLBPdms | SLBPnai | SLBPfSHAPE
        
        -d, --output_path        output_path to .bam files generated from eCLIP pipeline. Default: "."
        ''')
    
#Count mutations in maP read data. output .cov file
#containing total read count at each base; output .mut file
#containing mutation counts at each base
#INPUT should be a coord sorted MDtag file, which is a derivative of a sam file
def countMutationsRead(startAt,qualstring,MDtag,mutArray,covArray,strand):
    #read: [chrom,strand,pos,quals,MDtag]
    #mutArray will hold mutation counts at each pos in given segment of genome
    #posInArray tells me where in array I am with given read
    #but requires another variable to say where in genome mutArray starts
    #Based on how frequently read are mutated at the 5'end (and sometimes 3')
    #I should clip the 5'ends of + read, -3 ends of - reads################
    if strand=="+":
        trim5 = 5
        trim3 = len(qualstring)-1
    elif strand=="-":
        trim5 = 1
        trim3 = len(qualstring)-5
    #trim5 and trim3 tells me how many bases to ignore counting at each end of the given read
    item = re.compile(r"[0-9]+|\^[A-Z]+|[A-Z]") #split MD tag into sections
    delItem = re.compile(r"\^[A-Z]+")
    #originalStarAt = startAt
    #originalMutLen = len(mutArray)
    splitMD = item.findall(MDtag)
    #ex: will split "0A0C30^A50C0" into ['0', 'A', '0', 'C', '30', '^A', '50', 'C', '0']
    deletions = delItem.findall(MDtag)
    sumDel = 0
    for d in deletions: #need to consider deletions in read as num bp that need to be added to mutArray
        sumDel += len(d)-1
    posInRead = 0
    #add zeros to mutArray and covArray as needed for read's length
    toAdd = max(0,len(qualstring)+sumDel - (len(mutArray)-startAt))
    for i in range(0,toAdd):
        mutArray.append(0)
        covArray.append(0)
    for unit in splitMD:
        if unit.isalpha():
            if ord(qualstring[posInRead])>40 and posInRead>=trim5 and posInRead<trim3:
                mutArray[startAt]+=1
                covArray[startAt]+=1
            posInRead+=1
            startAt+=1
        elif unit.isdigit():
            matches = int(unit)
            for i in range(0,matches):
                #if startAt==len(covArray): #debugging
                #    print(originalStarAt, originalMutLen, toAdd)
                #    print(qualstring,MDtag)
                if posInRead>=trim5 and posInRead<trim3:
                    covArray[startAt]+=1
                startAt+=1
                posInRead+=1
        else: #unit is a deletion of the form ^[A-Z]+
            if len(unit)==2 and ord(qualstring[posInRead])>40 and posInRead>=trim5 and posInRead<trim3: #is ^N, a single deletion
                mutArray[startAt]+=1
                covArray[startAt]+=1
            startAt+=len(unit)-1 #increment genome pos not read pos for deletion
            #not counting deletions as coverage otherwise...
    return mutArray,covArray

def write_to_file(outputfile,mutarray,covarray,threshold=0): #write counts to file, but only for positions with counts>0
    outfile1 = open(outputDir+"/"+mutChrom[strand]+strand+".cov",'a')
    outfile2 = open(outputDir+"/"+mutChrom[strand]+strand+".mut",'a')
    thisarray = mutArray[strand]
    for i in range(0,len(mutarray)):
        if covarray[i] > threshold:
            outfile1.write(mutChrom[strand]+"\t"+str(i+mutStart[strand])+"\t"+str(covArray[strand][i])+"\n")
        outfile2.write(mutChrom[strand]+"\t"+str(i+mutStart[strand])+"\t"+str(thisarray[i])+"\n")
    outfile1.close()
    outfile2.close()

def outputMutations(mdtagfile,outputDir): #no header in samfile
    #now go through reads
    #mdtag file should be sorted
    #MDtagfile format is: chrom(0) strand(1) pos(2) quals(3) MDtag(4)
    strandDict = {'+':0,'-':1}
    file = open(mdtagfile,'r')
    #allLines = file.read().splitlines()
    #read through one line at a time is best
    line = file.readline()
    covArray = {'+':[],'-':[]}
    mutArray = {'+':[],'-':[]} #have to keep + and - strand mutation counts separate
    mutStart = {'+':0,'-':0}
    mutChrom = {'+':'none','-':'none'}
    while line:
        #if line[0]=="@":
        #    line = file.readline()
        #    continue
        thisline = line.rstrip('\n').split()
        #print(thisline)
        quals = thisline[3]
        strand = thisline[1] #strandDict[thisline[1]]
        chrom = thisline[0]
        pos = int(thisline[2]) #mdtag genomepos is 0-based
        MDtag = thisline[4]
        #split cigar string on 'N'
        thisread = [chrom,strand,pos,quals,MDtag]
        mutStop = mutStart[strand]+len(mutArray[strand]) 
        if pos >= mutStop or chrom!=mutChrom[strand]:
            strand_str = ".pos" if strand == '+' else ".neg"
            #current read falls outside of current mut/cov tracking array.
            #write current mutArray/covArray to appropriate file and create new array.
            outfile1 = open(outputDir+"/"+mutChrom[strand]+strand_str+".cov",'a')
            outfile2 = open(outputDir+"/"+mutChrom[strand]+strand_str+".mut",'a')
            thisarray = mutArray[strand]
            for i in range(0,len(thisarray)):
                if covArray[strand][i] > 0:
                    outfile1.write(mutChrom[strand]+"\t"+str(i+mutStart[strand])+"\t"+str(covArray[strand][i])+"\n")
                if thisarray[i] > 0:
                    outfile2.write(mutChrom[strand]+"\t"+str(i+mutStart[strand])+"\t"+str(thisarray[i])+"\n")
            outfile1.close()
            outfile2.close()
            mutArray[strand] = []
            covArray[strand] = []
            mutStart[strand] = pos
            mutChrom[strand] = chrom
        #add this read's coverage and mutation counts of covArray and mutArray
        #start at position pos - mutStart, appending to arrays as necessary
        startAt = pos - mutStart[strand]
        thismut, thiscov  = countMutationsRead(startAt,quals,MDtag,mutArray[strand],covArray[strand],strand)
        #Dont need to return thismut, thiscov...They get modified in memory
        line = file.readline()
    file.close()

    
def splitRead(read,cigar): #For reads with N in them
    #read is of format: [chrom,strand,pos,quals,MDtag]
    #Returns split reads in format: [[read1],[read2]]
    #Need: M+I+S+=+X occuring before any N to get qualsPos: qualPosSum
    #Numbers before M+D+N+=+X gives genome pos after N: gPosSum
    #Numbers M+D(-1)+=+X before N is the amount of MD tag I need: MDtagSum
    #example CIGARstring: "32M1026N5M"
    #example MDtag: 0A0G29T5
    #How to split MDtag? Add up int(numbers) and len(letters) (del-1) until
    #When splitting cigar, sum up without I or N separately as info for MDtag
    #May have to "split" number
    splitN = cigar.split('N')
    readItem = re.compile(r"[0-9]+[M|I|S|=|X]")
    refItem = re.compile(r"[0-9]+[M|D|N|=|X]")
    mdItem = re.compile(r"[0-9]+[M|D|=|X]")
    number = re.compile(r"([0-9]+)")
    allreads = []
    remainingMDtag = read[-1]
    qualStart = 0
    refStart = read[2]
    for i in range(0,len(splitN)-1): #for each cigar piece split by N
        thisread = read[0:2]
        thisread.append(refStart)
        spliceWithN = splitN[i]+'N' #ex: 32M1026 -> 32M1026N
        
        readSum = 0
        splitCigarString = readItem.findall(splitN[i])
        cigarList = [number.split(x)[1:] for x in splitCigarString]
        for unit in cigarList: #looks like [['32', 'M']]
            readSum+=int(unit[0])
        thisQuals = read[-2][qualStart:qualStart+readSum]
        thisread.append(thisQuals)
        qualStart +=readSum
        
        refSum = 0
        splitWithN = splitN[i]+'N' #ex: 32M1026 -> 32M1026N
        splitCigarString = refItem.findall(splitWithN)
        cigarList = [number.split(x)[1:] for x in splitCigarString]
        #print(cigarList)
        for unit in cigarList: #looks like [['32', 'M'],['1026','N']]
            refSum+=int(unit[0]) 
        refStart+=refSum
        
        mdSum = 0
        splitCigarString = mdItem.findall(splitN[i])
        cigarList = [number.split(x)[1:] for x in splitCigarString]
        for unit in cigarList: #looks like [['32', 'M']]
            mdSum+=int(unit[0]) #sum of matches/mismatches and deletions occuring before N
        item = re.compile(r"[0-9]+|\^[A-Z]+|[A-Z]") #split MD tag into sections
        splitMD = item.findall(remainingMDtag)
        fulfilledSum = False
        thisMDtag = ""
        counter = 0
        while not fulfilledSum:
        #ex: will split "0A0C30^A50C0" into ['0', 'A', '0', 'C', '30', '^A', '50', 'C', '0']
            if splitMD[counter].isalpha():
                mdSum-=1
                thisMDtag+=splitMD[counter]
                fulfilledSum = (mdSum==0)
                if fulfilledSum:
                    remainingMDtag = ""
            elif splitMD[counter].isdigit():
                numBp = int(splitMD[counter])
                sumUsed = min(mdSum,numBp)
                remainder = max(0,numBp-mdSum)
                mdSum-=sumUsed
                thisMDtag+=str(sumUsed)
                fulfilledSum = (mdSum==0)
                if fulfilledSum:
                    remainingMDtag = str(remainder) #extra 0s in mdtag could be a prob, maybe not for me  
                
            else: #item is a deletion, ex: ^A
                #Im assuming a deletion can't span an Ntype splice..that wouldnt make sense
                mdSum-=len(splitMD[counter])-1
                thisMDtag+=splitMD[counter]
                fulfilledSum = (mdSum==0)
                if fulfilledSum:
                    remainingMDtag = ""
            counter+=1
        thisread.append(thisMDtag)    
        for i in range(counter,len(splitMD)):
            remainingMDtag+= splitMD[i]
            
        allreads.append(thisread)   
    #build read for last splice read
    lastread = read[0:2]
    lastread.append(refStart)
    lastread.append(read[-2][qualStart:])
    lastread.append(remainingMDtag)
    
    allreads.append(lastread)
    return allreads

#Go through reads and split up spliced reads into two reads
#(basically splitting up mdtag and sequence)
#Need to output to a new file, which needs to be sorted by chrom
def splitReads(samfile,outputName):
    strandDict = {'0':'+','16':'-','4':"unmapped"}
    outfile = open(outputName,'w')
    file = open(samfile,'r')
    #allLines = file.read().splitlines()
    #read through one line at a time is best
    line = file.readline()
    while line:
        #if line[0]=="@":
        #    line = file.readline()
        #    continue
        thisline = line.rstrip('\n').split()
        #print(thisline)
        quals = thisline[10]
        strand = strandDict[thisline[1]]
        if strand=="unmapped":
            line = file.readline()
            continue
        chrom = thisline[2]
        pos = int(thisline[3])-1 #SAM is 1-based, changing to 0-based
        MDtag = thisline[16].split(':')[-1] #MD tags look like: MD:Z:25G35T1
        cigar = thisline[5] #Need: M+I-D occuring before any N to get quals 
        #ignore I and D to get pos
        item = re.compile(r"[0-9]+[M|I|D|S|N|=|X]")
        number = re.compile(r"([0-9]+)")
        #split cigar string on 'N'
        thisread = [chrom,strand,pos,quals,MDtag]
        if 'N' in cigar: #if cigar has no N in it, this will assess to 0
            splitread = splitRead(thisread,cigar) #returns [[read1],[read2],[read3],etc]
            for read in splitread:
                outfile.write(read[0]+"\t"+read[1]+"\t"+str(read[2])+"\t"+read[3]+"\t"+read[4]+"\n")
        else:
            outfile.write(chrom+"\t"+strand+"\t"+str(pos)+"\t"+quals+"\t"+MDtag+"\n")
        line = file.readline()
    file.close()
    outfile.close()
    
def countMutationsBamMain(bam_file, output_path):
    
    prefix = os.path.basename(os.path.splitext(bam_file)[0])
    coverage_outputs = os.path.join(output_path, 'coverage')
    sam_file = os.path.join(output_path, prefix + '.sam')
    mdtag_file = os.path.join(output_path, prefix + '.mdtag')
    mdtag_sorted_file = os.path.join(output_path, prefix + '.so.mdtag')

    print("Outputs in {}".format(coverage_outputs))
    subprocess.check_call('mkdir -p {}'.format(coverage_outputs), shell=True)  #   'mkdir '+name, shell=True)
    
    #convert bam to sam (no header)
    print("Converting from {} to {}".format(bam_file, sam_file))
    subprocess.check_call('samtools view {} > {}'.format(bam_file, sam_file), shell=True)  # 'samtools view '+ infile+' > '+sam_file, shell=True)

    #split up spliced reads in sam and get .mdtag format
    print("Splitting reads from {} to {}".format(sam_file, mdtag_file))
    splitReads(sam_file, mdtag_file)
    
    print("Sorting {} to {}".format(mdtag_file, mdtag_sorted_file))
    subprocess.check_call('sort -k 1,1 -k 3,3n ' + mdtag_file + ' > ' + mdtag_sorted_file, shell=True)
    #sort .mdtag files to .so.mdtag with sort -k 1,1 -k 3,3n
    #new infile is .so.mdtag
    
    # subprocess.call('rm '+outDir+'/*.mut', shell=True) #First remove all the .cov and .mut files in outDir (b/c they get appended to)
    # subprocess.call('rm '+outDir+'/*.cov', shell=True)
    outputMutations(mdtag_sorted_file, coverage_outputs)
    # subprocess.call('rm '+outDir+'/none*', shell=True)

def bam2sam(bam, sam):
    """
    Converts BAM file to SAM file.
    """
    try:
        subprocess.call('samtools view '+ bam+' > '+sam,shell=True)
    except Exception as e:
        return 1
    return 0

def countMutationsBam(bamFile, outDir):
    samFile = os.path.splitext(bamFile)[0] + '.sam'
    sortedSamFile = os.path.splitext(bamFile)[0] + '.sorted.sam'
    
    bam2sam(bamFile, samFile)
    outputMutations(samFile,outDir)

if __name__ == "__main__":
    parser = ArgumentParser(
        description='''python countMutationsBam.py -p dataset [...]
        Options:
        -h, --help

        REQUIRED
        -b, --bamfile         bam file (UMI-collapsed eCLIP BAM file (*.rmDupSo.bam))
        
        -d, --output_path        output_path for outputs.
        '''
    )
    parser.add_argument(
        "--bamfile",
        "-b",
        help="bamfile",
        required=True
    )
    parser.add_argument(
        "--data_path",
        "-d",
        help="data_path to .bam files generated from eCLIP pipeline.",
        required=True
    )
    args = parser.parse_args()
    bam_file = args.bamfile
    output_path = args.data_path

    countMutationsBamMain(bam_file, output_path)

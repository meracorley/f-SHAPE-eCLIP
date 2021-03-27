#!/usr/bin/env python

import pandas as pd
import argparse
import os
import gffutils

def gene_id_to_coords(db):
    """
    Returns a dictionary containing a gene_id:name translation
    Note: may be different if the 'gene_id' or 'gene_name' 
    keys are not in the source GTF file
    (taken from gscripts.region_helpers)
    """
    genes = db.features_of_type('gene')
    coords = {}
    for gene in genes:
        gene_id = gene.attributes['gene_id'][0] if type(gene.attributes['gene_id']) == list else gene.attributes['gene_id']
        try:
            coords[gene_id] = [
                gene.chrom,
                gene.start,
                gene.end,
                gene.strand
            ]
        except KeyError:
            print(gene.attributes.keys())
            print("Warning. Key not found for {}".format(gene))
            return 1
    return coords
    
def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--annotated_peaks",
        required=True,
        nargs="+"
    )
    parser.add_argument(
        "--output",
        required=False,
        default=None
    )
    parser.add_argument(
        "--gtfdb",
        required=True
    )
    args = parser.parse_args()
    peaks_files = args.annotated_peaks
    output_file = args.output if args.output is not None else "coords.txt"
    db_file = args.gtfdb
    
    genes = set()
    names = [
        'chrom','start','end','l10p','l2fc','strand', 
        'geneid', 'genename', 'region', 'annotation'
    ]
    for peaks_file in peaks_files:
        with open(peaks_file, 'r') as p:
            for line in p:
                gene_list = line.split('\t')[6].split(',')  # if a region was annotated for multiple genes (ie. 'ENSG00000062822.8,ENSG00000142539.9,ENSG00000062822.8')
                for gene in gene_list:
                    genes.add(gene)
    DATABASE = gffutils.FeatureDB(db_file)
    coords = gene_id_to_coords(DATABASE)
    try:
        genes.remove('intergenic')  # removes intergenic
    except KeyError:  # no intergenic peaks exist. That's good!
        pass
    with open(output_file, 'w') as o:
        for gene in genes:
            chrom, start, end, strand = coords[gene]
            o.write(
                "{}\t{}\t{}\t{}\t{}\t{}\n".format(
                    chrom, start, end, gene, '0', strand
                )
            )
if __name__ == "__main__":
    main()

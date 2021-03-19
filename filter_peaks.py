#!/usr/bin/env python

import pandas as pd
import argparse
import os

def filter_peaks(peaks, nlog10p, l2fc):
    """
    Calculates significance
    """
    return peaks[(peaks['l10p']>=nlog10p) & (peaks['l2fc']>=l2fc)]
    
def main():
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--peaks",
        required=True,
    )
    parser.add_argument(
        "--output_peaks",
        required=False,
        default=None
    )
    parser.add_argument(
        "--l10p",
        required=False,
        default=3.0
    )
    parser.add_argument(
        "--l2fc",
        required=False,
        default=3.0
    )
    args = parser.parse_args()
    l10p = args.l10p
    l2fc = args.l2fc
    peaks_file = args.peaks
    output_file = args.output_peaks if args.output_peaks is not None else os.path.splitext(peaks_file)[0] + ".sig{}.{}.bed".format(l10p, l2fc)
    
    names = ['chrom','start','end','l10p','l2fc','strand']
    peaks = pd.read_csv(peaks_file, names=names, sep='\t')
    filtered_peaks = filter_peaks(peaks=peaks, nlog10p=l10p, l2fc=l2fc)
    filtered_peaks.to_csv(
        output_file, sep='\t', index=False, header=False
    )

if __name__ == "__main__":
    main()

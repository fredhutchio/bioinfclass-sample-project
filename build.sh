#!/bin/bash

# Sane error handling settings
set -euf -o pipefail


# Specify output directory, and name input data
outdir="output"
metadata="data/sfv.csv"
inseqs="data/sfv.fasta"


# Basic metadata stats
# --------------------

# Compute number of sequences per species
seqs_per_species="$outdir/seqs_per_species.csv"
csvuniq -zc species $metadata > $seqs_per_species

# Compute number of sequences per specimen
seqs_per_specimen="$outdir/seqs_per_specimen.csv"
csvuniq -zc specimen,species,location $metadata > $seqs_per_specimen

# Use those results to compute number of specimens per species
specs_per_species="$outdir/specs_per_species.csv"
csvuniq -zc species $seqs_per_specimen > $specs_per_species

# Also use them to compute number of specimens per species and location
specs_per_species_location="$outdir/specs_per_species_location.csv"
csvuniq -zc species,location $seqs_per_specimen > $specs_per_species_location


# Sequence analysis
# -----------------

# Alignment
alignment="$outdir/alignment.fasta"
muscle -maxiters 2 -in $inseqs -out $alignment

# Phylognetic tree
tree="$outdir/tree.nw"
FastTree -seed 1234 -nt $alignment > $tree

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


# Location comparison
# -------------------

# We'd like to compare the viruses from each of these locations, so we're going to split the data for each one
# and run analyses separately, then recombine later.
exit

# Get array of locations
locations=($(csvuniq -c location $metadata | tail -n +2))

# For each location...
for location in ${locations[*]}
do
  # Create a location outdir, if it doesn't already exist
  loc_outdir="$outdir/$location"
  mkdir -p $loc_outdir

  # Create a subset of the metadata for just that location
  loc_metadata="$loc_outdir/metadata.csv"
  csvgrep -c location -m $location $metadata > $loc_metadata

  # Create a list of sequences sampled from that location
  loc_sequences="$loc_outdir/sequences"
  csvcut -c sequence $loc_metadata > $loc_sequences

  # Do something interesting with each location's sequences, etc
  # ...
    loc_spec_count="$loc_outdir/seqcount"
    wc -l $loc_sequences > $loc_spec_count
done

# Do something interesting with the things done for each location
loc_spec_counts="$outdir/location_specimen_counts.txt"
find $outdir -name seqcount | xargs cat > $loc_spec_counts
# ...


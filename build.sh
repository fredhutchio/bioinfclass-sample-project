#!/bin/bash

# Sane error handling settings
set -euf -o pipefail

# Compute number of sequences per species
csvuniq -zc species data/sfv.csv > output/seqs_per_species.csv

# Compute number of sequences per specimen
csvuniq -zc specimen,species,location data/sfv.csv > output/seqs_per_specimen.csv

# Use those results to count specimens per species
csvuniq -zc species output/seqs_per_specimen.csv > output/specs_per_species.csv

# Also use them to count specimens by species and location
csvuniq -zc species,location output/seqs_per_specimen.csv > output/specs_per_species_location.csv


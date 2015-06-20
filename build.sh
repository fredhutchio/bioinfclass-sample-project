#!/bin/bash

# Sane error handling settings
set -euf -o pipefail

# Compute number of sequences per species
csvuniq -zc species data/sfv.csv > output/seqs_per_species.csv


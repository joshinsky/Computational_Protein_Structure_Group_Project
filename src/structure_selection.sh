#!/bin/bash

#########################
## structure_selection ##
#########################

# Working directory: src

# Set up directories
mkdir ../structure_selection
cd ../structure_selection

# Activate conda environment with necessary tools (PDBminer)
/home/ctools/anaconda3-2024.10-1/bin/conda init
conda activate /home/ctools/protein_structure_course

# Run PDBminer to search for structures of our protein of interest.
nohup PDBminer -u Q13188 -n 2 -f csv &
nohup: ignoring input and appending output to 'nohup.out'

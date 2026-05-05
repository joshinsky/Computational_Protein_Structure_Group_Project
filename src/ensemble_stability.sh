#!/bin/bash

################################
## Stability on ensemble mode ##
################################

# Assumes script is run from src/

# Set-up directories
mkdir -p ../ensemble_stability
cd ../ensemble_stability

# Copy required files
cp ../data/template_files/* .
cp ../MD/mutatex/self-scan/clusters1-3.pdb .

# Activate environment
conda activate /home/ctools/protein_structure_course/

# Create position list 
echo -e "RA20\nRA36\nEA29\nLA35\nDA51\nPA26" > poslist.txt

# Run mutatex in ensemble mode
nohup mutatex clusters1-3.pdb \
  -p 3 \
  -x /home/ctools/foldx/foldx \
  -m mutation_list.txt \
  -f suite5 \
  -R repair_runfile_template.txt \
  -M mutate_runfile_template.txt \
  -q poslist.txt \
  -c -L -l -v -a \
  > mutatex.log 2>&1 &

# Chainize
cp /home/projects/22117_protein_structure/lecture7/group0/src/mutatex/ensemble_mode/chainize.py .
python chainize.py clusters1-3.pdb > clusters1-3_A.pdb

# Generate CSV
ddg2excel \
  -p clusters1-3_A.pdb \
  -l mutation_list.txt \
  -q poslist.txt \
  -d results/mutation_ddgs/final_averages/ \
  -F csv

# Generate heatmap
ddg2heatmap \
  -p clusters1-3_A.pdb \
  -l mutation_list.txt \
  -q poslist.txt \
  -d results/mutation_ddgs/final_averages/


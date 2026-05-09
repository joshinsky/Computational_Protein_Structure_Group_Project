#!/bin/bash

##########################################################
# Calculating Free Energy for Local Interactions (s252633)
##########################################################

# Working directory: src

# Set up directories
mkdir ../local_interaction
cd ../local_interaction

# Activate conda environment
conda activate /home/ctools/protein_structure_course

# Prepare poslist.txt, which lists all target residue identifiers

# Run MutateX to calculate the ddG values for the mutations listed in mutation_list.txt
nohup mutatex ../data/B_structure_selection/stk3_dimer.pdb -p 2 -m ../data/foldxsuite5_templates/mutation_list.txt \
  -x /home/ctools/foldx/foldx -f suite5 -R ../data/foldxsuite5_templates/repair_runfile_template.txt \
  -M ../data/foldxsuite5_templates/mutate_runfile_template.txt -q ../data/C_stability_assessment/poslist.txt -L -l -v -C  none \
  -B  -I ../data/foldxsuite5_templates/interface_runfile_template.txt &

# Summarize MutateX results and convert to CSV format 
ddg2excel -p ../data/B_structure_selection/stk3_dimer.pdb -l ../data/foldxsuite5_templates/mutation_list.txt \
  -q ../data/C_stability_assessment/poslist.txt -d results/interface_ddgs/final_averages/A-B/ -F csv

# Generate a heatmap of  ddG values
ddg2heatmap -p ../data/B_structure_selection/stk3_dimer.pdb -l ../data/foldxsuite5_templates/mutation_list.txt \
  -q ../data/C_stability_assessment/poslist.txt -d results/interface_ddgs/final_averages/A-B/

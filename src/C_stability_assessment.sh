#!/bin/bash

##########################
## Stability assessment ##
##########################

# Working directory: src

# Set up directories
mkdir ../stability_assessment
cd ../stability_assessment

# Activate conda environment with necessary tools (naccess, mutatex)
conda activate /home/ctools/protein_structure_course

# Calculate the atomic accessible area with Naccess
naccess ../data/B_structure_selection/AF-Q13188-F1-model_v6.pdb

# Run MutateX to calculate the ddG values for the mutations listed in mutation_list.txt
nohup mutatex ../data/B_structure_selection/AF-Q13188-F1-model_v6.pdb -p 1 -m ../data/foldxsuite5_templates/mutation_list.txt \
    -x /home/ctools/foldx/foldx -f suite5 -R ../data/foldxsuite5_templates/repair_runfile_template.txt \
    -M ../data/foldxsuite5_templates/mutate_runfile_template.txt -q ../data/C_stability_assessment/poslist.txt -L -l -v -C none &

# Summarize MutateX results and convert to CSV format
ddg2excel -p ../data/B_structure_selection/AF-Q13188-F1-model_v6.pdb -l ../data/foldxsuite5_templates/mutation_list.txt \
    -q ../data/C_stability_assessment/poslist.txt -d results/mutation_ddgs/AF-Q13188-F1-model_v6_model0_checked_Repair -F csv

# Generate a heatmap of the ddG values
ddg2heatmap -p ../data/B_structure_selection/AF-Q13188-F1-model_v6.pdb -l ../data/foldxsuite5_templates/mutation_list.txt \
    -q ../data/C_stability_assessment/poslist.txt -d results/mutation_ddgs/final_averages/
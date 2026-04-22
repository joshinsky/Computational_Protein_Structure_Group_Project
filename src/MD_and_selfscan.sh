#!/bin/bash

######################
## MD and self-scan ##
######################

# cd is src

# set-up directories
mkdir ../MD
mkdir ../MD/pdbs
mkdir ../MD/mutatex
mkdir ../MD/mutatex/"self-scan"

# download molecular trajectories
mkdir ../data/atlas_data
cd ../data/atlas_data
wget https://www.dsimb.inserm.fr/ATLAS/database/ATLAS/4hkd_B/4hkd_B_analysis.zip
unzip 4hkd_B_analysis.zip

# convert third replicate's trajectories to pdb and compute main-chain RMSD matrix
cd ../../MD/pdbs
gmx trjconv -f ../../data/atlas_data/4hkd_B_R3.xtc -s ../../data/atlas_data/4hkd_B_R3.tpr -o 4hkd_B_R3.pdb -fit rot+trans # select 5 and 1 in interactive menu
gmx_mpi rms -f ../../data/atlas_data/4hkd_B_R3.xtc -s ../../data/atlas_data/4hkd_B_R3.tpr -o rmsd.xvg -m rmsd_matrix.xpm  # select 5 and 5

# trajectory clustering and visualisation
gmx_mpi cluster -f ../../data/atlas_data/4hkd_B_R3.xtc -s ../../data/atlas_data/4hkd_B_R3.tpr -dm rmsd_matrix.xpm -o rmsd_clust.xpm -g cluster.log -sz clust_size.xvg -cl clusters.pdb -clid clust_id.xvg -method gromos -cutoff 0.497  # select 5 and 1 in interactive menu
python ../../src/plot_clusters.py -n 6

# isolate the first three clusters
cat clusters.pdb | grep -n TITLE				# find out on which line cluster 4 starts
cat clusters.pdb | head -2670 > clusters1-3.pdb	# use that line as cutoff

# move and create necessary files for self-scan
mv clusters1-3.pdb ../mutatex/"self-scan"
cd ../mutatex/"self-scan"
echo -e "RA20\nPA26\nEA29\nRA30\nEA34\nLA35\nRA36\nRA38\nYA39\nTA40\nAA41\nPA45\nDA48\nAA49\nDA51\nKA53" > poslist.txt

# perform self-scan
conda activate /home/ctools/protein_structure_course/
nohup mutatex clusters1-3.pdb -p 3 -x /home/ctools/foldx/foldx -m mutation_list.txt -f suite5 -R repair_runfile_template.txt -M mutate_runfile_template.txt -q poslist.txt  -c -L -l -v -s -a &
tail -f nohup.out

# view results
cd results_selfmutation/mutation_ddgs
cat clusters1-3_model*_checked_Repair/selfmutation_energies.dat
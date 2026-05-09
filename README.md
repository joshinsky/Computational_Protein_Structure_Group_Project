# Computational Protein Structure Project -  Group 13

This repository contains the data and source code required to reproduce the results reported in "Computational Characterization of STK3 SARAH-Domain: Elucidating the Structural Basis of Hippo Pathway Dysregulation in Cancer". The project focuses on the structural analysis, pathogenicity prediction, and stability assessment of STK3 variants.

## Repository structure

### `data/`
* **A_variant_selection**: Data from ClinVar and COSMIC databases. Includes pathogenicity predictions via AlphaMissense and the final 20 SARAH domain variants (`variants_only_SARAH.txt`).
* **B_structure_selection**: Protein structures used in the study, including the AlphaFold model for STK3 (`AF-Q13188-F1-model_v6.pdb`) and the STK3-RASSF5 complex dimer (`stk3_dimer.pdb`).
* **C_stability_assessment**: Contains `poslist.txt`, the position list used for both stability (Step C) and local interaction (Step D) analyses.
* **E_variant_selection_ensemble**: The core results folder. Includes:
    * `mutatex_stability_results.csv` & `mutatex_binding_results.csv`: $\Delta\Delta G$ results from the ddg2excel tool.
    * `demask_scores.txt`: Scores from DeMask.
    * `variants_with_all_results.txt`: The consolidated master table used for variant selection for stability assessment in ensemble mode.
* **foldxsuite5_templates**: Configuration templates and mutation lists required for the FoldX/MutateX pipeline (Steps C–G). The configuration templates were sourced from [MutateX repository](https://github.com/ELELAB/mutatex).

### `src/`
This directory contains the processing pipeline. The files are prefixed alphabetically (`A` through `G`) to reflect the sequential stages of the project.

> [!IMPORTANT]  
> **Note on `.sh` files:** The Shell scripts are intended as **command logs** rather than automated execution scripts. They document the exact parameters and sequences used during the analysis.

* `A_variant_processing.R`: Initial filtering and processing of database variants.
* `E_variant_selection_ensemble.R`: Logic for merging scores and selecting final candidates.
* `F_plot_clusters.py`: Visualization script for clustering results.

library("tidyverse")

### Working directory: src

### Read variants with pathogenicity scores
variant_data <- read_delim("../data/E_variant_selection_ensemble/variants_only_SARAH.txt", delim = "\t") 

variant_data <- variant_data |>
  separate_wider_position(Mutation,
                          widths = c(WT = 1, Pos = 3, Mut = 1)) |>
  mutate(Pos = as.numeric(Pos)) |>
  rename(Pathogenicity_score = "pathogenicity score",
         Pathogenicity_class = "pathogenicity class")


### Read stability assessment results
mutatex_stability_data <- read_csv("../data/E_variant_selection_ensemble/mutatex_stability_results.csv")

mutatex_stability_data <- mutatex_stability_data |> 
  pivot_longer(cols = !c(`WT residue type`, `chain ID`, `Residue #`),
               names_to = "Mut",
               values_to = "Stability") |>
  select(!`chain ID`) |>
  rename(WT = "WT residue type",
         Pos = "Residue #") |>
  mutate(Stability_classification = case_when(
    Stability <= -3 ~ "Stabilising",
    Stability > -2 & Stability < -2 ~ "Neutral",
    Stability >= 3 ~ "Destabilising",
    .default = "Uncertain"
  ))


### Read local interaction results
mutatex_binding_data <- read_csv("../data/E_variant_selection_ensemble/mutatex_binding_results.csv")

mutatex_binding_data <- mutatex_binding_data |> 
  pivot_longer(cols = !c(`WT residue type`, `chain ID`, `Residue #`),
               names_to = "Mut",
               values_to = "Binding") |>
  select(!`chain ID`) |>
  rename(WT = "WT residue type",
         Pos = "Residue #") |>
  mutate(Binding_classification = case_when(
    Binding <= -1 ~ "Stabilising",
    Binding >= 1 ~ "Destabilising",
    .default = "Uncertain"
  ))


### Read DeMask results
demask_data <- read_delim("../data/E_variant_selection_ensemble/demask_scores.txt", delim = "\t") |>
  rename(DeMaSk_score = "score",
         Pos = "pos",
         Mut = "var") |>
  select(c(DeMaSk_score, Pos, WT, Mut)) |>
  mutate(DeMaSk_classification = case_when(
    DeMaSk_score < -0.25 ~ "LOF",
    DeMaSk_score > 0.25 ~ "GOF",
    .default = "Neutral"
  ))

joined_results <- variant_data |>
  inner_join(mutatex_stability_data,
             by = join_by(WT, Pos, Mut)) |>
  inner_join(mutatex_binding_data,
             by = join_by(WT, Pos, Mut)) |>
  inner_join(demask_data,
             by = join_by(WT, Pos, Mut)) |>
  arrange(Pos)

### Write all joined data
write_delim(joined_results, "../data/E_variant_selection_ensemble/variants_with_all_results.txt", delim = "\t")

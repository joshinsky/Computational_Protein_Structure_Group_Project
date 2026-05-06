library(tidyverse)

# Load the data
clinvar_df <- read_tsv("../data/A:variant_selection/clinvar+patho.tsv")
cosmic_df  <- read_tsv("../data/cosmic_correct.tsv")
# Load the AlphaMissense file
am_df <- read_tsv("../data/A:variant_selection/AlphaMissense-Search-Q13188.tsv")

# Process COSMIC
cosmic_clean <- cosmic_df %>%
  filter(Type == "Substitution - Missense") %>%
  extract(
    `AA Mutation`, 
    into = c("aa1", "pos", "aa2"), 
    regex = "p\\.([A-Z])(\\d+)([A-Z])", 
    remove = FALSE,
    convert = TRUE
  ) %>%
  mutate(
    Mutation = paste0(aa1, pos, aa2),
    Source = "COSMIC"
  ) %>%
  select(Mutation, Source)

# Process ClinVar
clinvar_clean <- clinvar_df %>%
  mutate(
    Mutation = paste0(a.a.1, position, a.a.2),
    Source = "ClinVar"
  ) %>%
  select(Mutation, Source)

# Combine cosmic and clinvar then deduplicate
combined_variants <- bind_rows(clinvar_clean, cosmic_clean) %>%
  drop_na(Mutation) %>% 
  distinct(Mutation, .keep_all = TRUE)

# Process AlphaMissense and join
# key is mutation
am_clean <- am_df %>%
  mutate(Mutation = paste0(a.a.1, position, a.a.2)) %>%
  select(
    Mutation, 
    `pathogenicity score`, 
    `pathogenicity class`
  )

# attach  scores to variants
final_df <- combined_variants %>%
  left_join(am_clean, by = "Mutation")

# Save the result
write_tsv(final_df, "../data/A:variant_selection/combined_variants_with_scores.tsv")

## Tidy the data files from GTEx

library(data.table)
library(magrittr)
library(tidyverse)

source("save_per_tissue.R")

#### ---- Sample Info ---- ####

# attributes of the samples
sample_attrs <- read_tsv(
    "raw_data/GTEx_v7_Annotations_SampleAttributesDS.txt"
) %>%
    select(SAMPID, SMTS, SMTSD, SMGEBTCHT, SMPTHNTS)
names(sample_attrs) <- c("sample_id",
                         "tissue",
                         "tissue_detail",
                         "seq_tech",
                         "pathology_notes")
saveRDS(sample_attrs, "data/sample_attributes.tib")

# the meaning of the "hardy_scale" that describes the death of the donor
hardy_scale_dict <- tribble(
    ~hardy_scale, ~death, ~death_detail,
    1, "violent", "Violent and fast death Deaths due to accident, blunt force trauma or suicide, terminal phase estimated at < 10 min.",
    2, "fast", "Fast death of natural causes Sudden unexpected deaths of people who had been reasonably healthy, after a terminal phase estimated at < 1 hr (with sudden death from a myocardial infarction as a model cause of death for this category)",
    3, "intermediate", "Intermediate death Death after a terminal phase of 1 to 24 hrs (not classifiable as 2 or 4); patients who were ill but death was unexpected",
    4, "slow", "Slow death Death after a long illness, with a terminal phase longer than 1 day (commonly cancer or chronic pulmonary disease); deaths that are not unexpected",
    0, "ventilator", "Ventilator Case All cases on a ventilator immediately before death."
)

# descriptions of the donors
sample_pheno <- read_tsv(
    "raw_data/GTEx_v7_Annotations_SubjectPhenotypesDS.txt"
)
names(sample_pheno) <- c("subject_id", "sex", "age_range", "hardy_scale")
sample_pheno %<>%
    mutate(sex = ifelse(sex == 1, "M", "F")) %>%
    left_join(hardy_scale_dict, by = "hardy_scale") %T>%
    saveRDS("data/sample_phenotypes.tib")


#### ---- Genes ---- ####

# TEST
gene_tpm <- fread(
    "raw_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_tpm.gct",
    sep = "\t",
    skip = 2,
    nrows = 100
) %>%
    as_tibble() %>%
    gather(key = "sample_id", value = "tpm", -Name, -Description) %>%
    left_join(sample_attrs, by = "sample_id") %>%
    save_per_tissue(tissue, "data/gene_expression_tpm")

# TEST
gene_reads <- gene_tpm <- fread(
    "raw_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_reads.gct",
    sep = "\t",
    skip = 2,
    nrows = 100
) %>%
    as_tibble() %>%
    gather(key = "sample_id", value = "tpm", -Name, -Description) %>%
    left_join(sample_attrs, by = "sample_id") %>%
    save_per_tissue(tissue, "data/gene_expression_reads")


# median expression levels across tissues
gene_median <- fread(
    "raw_data/GTEx_Analysis_2016-01-15_v7_RNASeQCv1.1.8_gene_median_tpm.gct"
) %>%
    as_tibble() %>%
    gather(key = "tissue", value = "median_tpm", -gene_id, -Description) %T>%
    saveRDS("data/gene_expression_median_tpm.tib")

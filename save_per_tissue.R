# Saving and loading the GTEx data by tissue

library(jhcutils)
library(rlang)
library(tidyverse)

# save each tissue to a separate file
#   tib: GTEx data tibble
#   tissue_column: column name for tissue (quoted)
#   home_dir: directory to save to
save_per_tissue <- function(tib, tissue_column, home_dir) {
    tissue_column <- enquo(tissue_column)
    tissues <- tib %>%
        u_pull(!!tissue_column)

    # check that destination directory exists
    if (!dir.exists(home_dir)) dir.create(home_dir)

    # save a file for each tissue
    for (tissue in tissues) {
        cat(tissue)
        fname <- janitor::make_clean_names(tissue)
        fname <- file.path(home_dir, paste0(fname, ".tib"))
        tib %>%
            filter(!!tissue_column == !!tissue) %>%
            saveRDS(fname)
        cat("\33[2K\r")
    }
    cat("all saved to '", home_dir, "'", "\n", sep = "")
    invisible(NULL)
}

# load the tissue files from a directory save to using `save_per_tissues()`
#   home_dir: directory to save to
#   tissues: vector of tissues to search for ("all" to load all files)
load_tissue <- function(home_dir, tissues = c("all")) {
    if (length(tissues) < 1) stop("no tissues requested")
    tissues_regex <- str_to_lower(tissues) %>%
        janitor::make_clean_names() %>%
        paste0(collapse = "|")
    if (any(tissues == "all")) {
        tib <- list.files(home_dir, full.names = TRUE) %>%
            purrr::map(readRDS) %>%
            bind_rows()
    } else {
        tib <- list.files(home_dir, full.names = TRUE) %>%
            str_subset(tissues_regex) %>%
            purrr::map(readRDS) %>%
            bind_rows()
    }
    return(tib)
}

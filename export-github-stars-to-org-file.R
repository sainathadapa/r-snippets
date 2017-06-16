source('get_github_stars.R')
export_github_stars_data_to_org_file <- function(url, filepath) {
  get_github_stars_data(url) %>% 
    apply(MARGIN = 1, FUN = (function(x) {
      c(
        paste0('* ', x['description']),
        paste0('| ', str_pad(names(x[-2]),11,'right') , ' | ', x[-2], ' |')
      ) %>% paste0(., collapse = '\n')
    })) %>% 
    writeLines(., filepath)
}



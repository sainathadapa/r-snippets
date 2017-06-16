library(rvest)
library(rlist)
library(stringr)
library(dplyr)

make_na_if_null <- function(x) {
  if (is.null(x) || (length(x) == 0)) return(NA_character_)
  x
}

common_extractor <- function(x, css) {
  x %>% 
    html_nodes(css) %>% 
    html_text() %>% 
    str_trim()
}

get_one_node_elements <- function(x) {
  
  data_frame(name = x %>% common_extractor('.mb-1 a') %>% str_replace_all(' ', '') %>% make_na_if_null(),
             description = x %>% common_extractor('.pr-4') %>% make_na_if_null(),
             language = x %>% common_extractor('span.mr-3') %>% make_na_if_null(),
             stars = x %>% common_extractor('span+ .muted-link') %>% make_na_if_null(),
             forks = x %>% common_extractor('.muted-link+ .mr-3') %>% make_na_if_null(),
             updated = x %>% common_extractor('relative-time') %>% make_na_if_null())
}

get_one_page_data <- function(x) {
  x %>%
    html_nodes('.py-4') %>% 
    lapply(get_one_node_elements) %>%
    bind_rows()
  
}

get_next_pages <- function(x) {
  x %>%
    html_nodes('.pagination a') %>%
    html_attrs() %>%
    list.mapv(href) %>%
    unique %>%
    paste0('https://github.com', .) %>% 
    sort
} 

get_github_stars_data <- function(x) {
  pages_to_try <- x
  pages_tried <- c()
  
  all_pages_data <- list()
  
  while (length(pages_to_try) > 0) {
    
    this_page <- pages_to_try[1]
    
    Sys.sleep(0.5)
    this_page_html <- read_html(this_page)
    
    all_pages_data <- c(all_pages_data, list(get_one_page_data(this_page_html)))
    
    pages_tried <- c(pages_tried, this_page)
    pages_to_try <- c(pages_to_try, get_next_pages(this_page_html)) %>% setdiff(y = pages_tried)
  }
  
  distinct(bind_rows(all_pages_data)) %>%
    filter(!is.na(name)) %>% 
    mutate(url = paste0('https://github.com/',  name))
  
}


# get_github_stars_data('https://github.com/sainathadapa?tab=stars')




library(dplyr)
library(stringr)

glimpse_output_as_org_table <- function(x) {
  capture.output(glimpse(x)) %>%
    str_replace_all('^\\$', '| ') %>% 
    str_replace_all('(.*)<(.*)>(.*)', '\\1|<\\2>|\\3 |') %>% 
    paste0(collapse = '\n') %>% cat  
}

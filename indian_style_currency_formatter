indian_comma <- function(x) {
  
  where_na <- is.na(x)
  x <- x[!where_na]
  
  x <- round(x, digits = 0)
  
  s1 <- x %% 1000
  
  s2 <- (x - s1) / 1000
  
  s1 <- as.character(s1)
  s1 <- vapply(X = s1, FUN.VALUE = 'temp', USE.NAMES = FALSE,
               FUN = function(y) {
                 paste0(c(rep('0', 3 - str_length(y)), y), collapse = '')
               })
  
  s2c = format(s2, big.mark = ",", scientific = FALSE, trim = TRUE, big.interval = 2)
  
  res <- paste0(s2c, ',', s1)
  res <- str_replace_all(res, '^(0*)(.*)(.)$', '\\2\\3')
  res <- str_replace_all(res, '^(,*)(.*)$', '\\2')
  res <- str_replace_all(res, '^(0*)(.*)(.)$', '\\2\\3')
  
  # res <- str_pad(res, width = max(str_length(res)), side = 'left')
  
  ans <- character(length(where_na))
  ans[where_na] <- NA_character_
  ans[!where_na] <- res
  
  ans
}

# indian_comma(c(0, 10, 8, 1000, 234, 500007, 12315414))

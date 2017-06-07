#' ---
#' output: 
#'   prettydoc::html_pretty:
#'     theme: cayman
#'     highlight: github
#'     toc: true
#'     css: custom.css
#' ---

#+ package_options, include=FALSE
library("knitr")
opts_knit$set(progress = TRUE, verbose = TRUE)
#+ global_options, include=FALSE
opts_chunk$set(fig.fullwidth = TRUE, fig.width = 12, fig.height = 8)

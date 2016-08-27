library(ggplot2)
library(scales)
library(lubridate)
library(magrittr)
library(dplyr)
library(viridis)

calendar_heat_map <- function(df, datecol, valcol) {
  toplot <- df %>% 
    select_(.dots = c(datecol, valcol)) %>% 
    rename_(.dots = c(dt = datecol, val = valcol))
              
  toplot <- toplot %>% 
    mutate(mnth = format(dt, format = '%B'),
           dy = format(dt, format = '%A'),
           mnthnum = format(dt, format = '%m'),
           dynum = format(dt, format = '%w'),
           wknum = format(dt, format = '%U'))
  
  toplot <- toplot %>% 
    mutate(dynum = as.numeric(dynum),
           mnthnum = as.numeric(mnthnum),
           wknum = as.numeric(wknum))
  
  dy_dynum <- toplot %>% 
    select(dynum, dy) %>% 
    distinct() %>% 
    mutate(dynum = -dynum) %>% 
    arrange(dynum)
  
  toplot$dynum <- factor(-toplot$dynum, levels = dy_dynum$dynum, ordered = TRUE, labels = dy_dynum$dy)
  
  tmp <- toplot %>% 
    group_by(mnthnum, wknum) %>% 
    summarise(mindynum = min(dynum),
              maxdynum = max(dynum)) %>% 
    ungroup
  
  tmp2 <- toplot %>% 
    group_by(mnthnum, dynum) %>% 
    summarise(minwknum = min(wknum),
              maxwknum = max(wknum)) %>% 
    ungroup
  
  mnth_lbl_pos <- tmp2 %>% 
    group_by(mnthnum) %>% 
    summarise(wknum = c(minwknum, maxwknum) %>% 
                range %>% 
                sum %>% 
                divide_by(2)) %>% 
    ungroup %>% 
    inner_join(toplot %>% 
                 select(mnthnum, mnth) %>% 
                 distinct, by = 'mnthnum')
  
  ggobj <- ggplot(toplot) + 
    geom_tile(aes(x = wknum, y = dynum, fill = val)) +
    scale_fill_viridis() + 
    geom_segment(data = tmp, aes(x = wknum - 0.5, xend = wknum + 0.5,
                                 y = as.numeric(mindynum) - 0.5, yend = as.numeric(mindynum) - 0.5)) +
    geom_segment(data = tmp, aes(x = wknum - 0.5, xend = wknum + 0.5,
                                 y = as.numeric(maxdynum) + 0.5, yend = as.numeric(maxdynum) + 0.5)) +
    geom_segment(data = tmp2, aes(y = as.numeric(dynum) - 0.5, yend = as.numeric(dynum) + 0.5,
                                  x = minwknum - 0.5, xend = minwknum - 0.5)) +
    geom_segment(data = tmp2, aes(y = as.numeric(dynum) - 0.5, yend = as.numeric(dynum) + 0.5,
                                  x = maxwknum + 0.5, xend = maxwknum + 0.5)) +
    geom_text(data = mnth_lbl_pos, aes(x = wknum, y = 8, label = mnth), vjust = 'inward') +
    theme_classic() +
    coord_equal(xlim = c(-0.5, 52.5), expand = FALSE) +
    theme(axis.text.x = element_blank(),
          axis.title.x = element_blank()) +
    ylab('Day of Week')
  
  ggobj
}




# note: the dev version of bib2df may be necessary as the CRAN version
# currently has an issue with parsing curly braces

# devtools::install_github("ropensci/bib2df")
library(pacman)
p_load(
  here, 
  tidyverse,
  bib2df
)

# extract cite keys from manuscript ---------------------------------------

# load manuscript
Rmd <- readChar(here("writing", "manuscript.rmd"),nchars=1e7)

# extract out all citekeys 
cites <- str_extract_all(Rmd, "@[a-zA-Z0-9-]*(?=(\\s)|(;)|(])|(\\.)|($))")[[1]] %>% 
  unique() %>% 
  tibble() %>% 
  filter(str_detect(., "\\d")) %>% 
  mutate(cite = str_remove(., "@")) %>% 
  pull(cite)

# filter .bib file to just those keys -------------------------------------

bib_out <- bib2df(here("writing", "themusiclab.bib")) %>% 
  filter(BIBTEXKEY %in% all_of(cites)) %>% 
  select(!contains("."))

df2bib(bib_out, file = here("writing", "themusiclab_test.bib"))





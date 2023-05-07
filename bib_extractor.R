
# note: the dev version of bib2df may be necessary as the CRAN version
# currently has an issue with parsing curly braces

# devtools::install_github("ropensci/bib2df")
library(pacman)
p_load(
  here, 
  tidyverse,
  bib2df
)


# parameters --------------------------------------------------------------


manuscript_file_path <- here("writing", "manuscript.Rmd")
bib_file_path <- here("writing", "themusiclab_long.bib")
output_file_path <- here("writing", "themusiclab.bib")


# extract cite keys from manuscript ---------------------------------------

# load manuscript
Rmd <- readChar(manuscript_file_path, nchars=1e9)

# extract out all citekeys 
cites <- str_extract_all(Rmd, "@[a-zA-Z0-9-]*(?=(\\s)|(;)|(])|(\\.)|($))")[[1]] %>% 
  unique() %>% 
  tibble() %>% 
  filter(str_detect(., "\\d|(inpress)")) %>% 
  mutate(cite = str_remove(., "@")) %>% 
  pull(cite)

# filter .bib file to just those keys -------------------------------------

bib_out <- bib2df(bib_file_path) %>% 
  filter(BIBTEXKEY %in% cites) %>% 
  select(!contains("."))

df2bib(bib_out, file = output_file_path)





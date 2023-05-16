library(tidyverse)
library(magick)

img_path <- "/Users/chil375/Downloads/chattels_and_entry_condition"

# downsample photos proportional to downscale_factor
down_boi <- function(img_input, downscale_factor) {
  img <- image_read(str_c(img_path, img_input, sep = "/"))
  img_info <- image_info(img)
  img <- image_resize(img, str_c(img_info$width*downscale_factor, img_info$height*downscale_factor, sep = "x"))
  magick::image_write(img, path = str_c(img_path, "downsampled", img_input, sep = "/"))
}

# vector of file names
my_photos <- list.files(img_path) |> 
  str_subset(".jpg")
# process photos
walk(my_photos, down_boi, 0.25)

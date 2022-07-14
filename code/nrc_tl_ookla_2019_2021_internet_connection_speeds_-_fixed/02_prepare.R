# dataset creation code - dataset preparation (transformation, new variables, linkage, etc)

# Import file from original

unzip('data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2019-01-01_performance_fixed_tiles.zip',
      exdir = "data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/working/")

sf <- sf::st_read("data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/working/gps_fixed_tiles.shp")


# Update file manifest
data_file_checksums()





as_binary = function(x){
  tmp = rev(as.integer(intToBits(x)))
  id = seq_len(match(1, tmp, length(tmp)) - 1)
  tmp[-id]
}

deg2num = function(lat_deg, lon_deg, zoom) {
  lat_rad = lat_deg * pi /180
  n = 2.0 ^ zoom
  xtile = floor((lon_deg + 180.0) / 360.0 * n)
  ytile = floor((1.0 - log(tan(lat_rad) + (1 / cos(lat_rad))) / pi) / 2.0 * n)
  c(xtile, ytile)
}

# reference JavaScript implementations
# https://developer.here.com/documentation/traffic/dev_guide/common/map_tile/topics/quadkeys.html

tileXYToQuadKey = function(xTile, yTile, z) {
  quadKey = ""
  for (i in z:1) {
    digit = 0
    mask = bitwShiftL(1, i - 1)
    xtest = as_binary(bitwAnd(xTile, mask))
    if(any(xtest)) {
      digit = digit + 1
    }

    ytest = as_binary(bitwAnd(yTile, mask))
    if(any(ytest)) {
      digit = digit + 2
    }
    quadKey = paste0(quadKey, digit)
  }
  quadKey
}

get_perf_tiles <- function(bbox, tiles){
  bbox <- st_bbox(
    st_transform(
      st_as_sfc(bbox),
      4326
    ))
  tile_grid <- bbox_to_tile_grid(bbox, zoom = 16)
  # zoom level 16 held constant, otherwise loop through the tile coordinates calculated above
  quadkeys <- pmap(list(tile_grid$tiles$x, tile_grid$tiles$y, 16), tileXYToQuadKey)
  perf_tiles <- tiles %>%
    filter(quadkey %in% quadkeys)
}




us <- tigris::states(cb=T)

va_bb <- sf::st_bbox(us[us$STATEFP=="51",])

tiles <- arrow::read_parquet("data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2019-01-01_performance_fixed_tiles.parquet")

va_perf_tiles <- get_perf_tiles(va_bb, tiles) %>%
  st_as_sf(wkt = "tile", crs = 4326)






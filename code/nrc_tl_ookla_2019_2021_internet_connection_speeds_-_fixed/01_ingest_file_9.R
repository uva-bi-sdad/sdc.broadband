# dataset creation code - data source ingest - file 9
# source file: s3://ookla-open-data/shapefiles/performance/type=fixed/year=2020/quarter=1/2020-07-01_performance_fixed_tiles.zip

# Import source file and save to original for backup
source_file <- "s3://ookla-open-data/shapefiles/performance/type=fixed/year=2020/quarter=1/2020-07-01_performance_fixed_tiles.zip"
file.copy(source_file, "data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2020-07-01_performance_fixed_tiles.zip")

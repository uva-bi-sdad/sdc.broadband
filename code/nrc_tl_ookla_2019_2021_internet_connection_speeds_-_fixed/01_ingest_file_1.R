# dataset creation code - data source ingest - file 1
# source file: s3://ookla-open-data/shapefiles/performance/type=fixed/year=2019/quarter=1/2019-01-01_performance_fixed_tiles.zip

# Import source file and save to original for backup
source_file <- "s3://ookla-open-data/shapefiles/performance/type=fixed/year=2019/quarter=1/2019-01-01_performance_fixed_tiles.zip"
dest_file <- "data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2019-01-01_performance_fixed_tiles.zip"

aws.s3::save_object(object = source_file, region = "us-west-2", file = dest_file)


# experiment with parquet instead
s <- "s3://ookla-open-data/parquet/performance/type=fixed/year=2019/quarter=1/2019-01-01_performance_fixed_tiles.parquet"
d <- "data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2019-01-01_performance_fixed_tiles.parquet"
aws.s3::save_object(object = s, region = "us-west-2", file = d)


library(arrow, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
ds <- open_dataset("data/nrc_tl_ookla_2019_2021_internet_connection_speeds_-_fixed/original/2019-01-01_performance_fixed_tiles.parquet")
ds

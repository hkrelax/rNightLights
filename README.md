# rNightLights
This package was forked from walshc/nightlights project. I managered to add more functions like `untarNightLights` to uncompressing the manully downloaded NOAA data and `calibNightLights` to inter-calibiration the data across different satellites and years.

An `R` package to extract NOAA night lights data for regions within shapefiles
(a `SpatialPolygons` or `SpatialPolygonsDataFrame`). The night lights data can be downloaded from
[here](http://ngdc.noaa.gov/eog/data/web_data/v4composites/) or using the
function `downloadNightLights()` in the package. Alternatively, a download
script is provided to download and extract all the data (see below).

![Data](/img.png?raw=true "Night Lights Data")

## Installation

```r
if (!require(devtools)) install.packages("devtools")
devtools::install_github("jpshuimu/rNightLights")
```

## Usage

```r
require(rNightLights)

# Download, extract and load and example shapefile to work with (US counties):
download.file("ftp://ftp2.census.gov/geo/tiger/TIGER2015/COUSUB/tl_2015_25_cousub.zip",
              destfile = "tl_2015_25_cousub.zip")
unzip("tl_2015_25_cousub.zip")
shp <- rgdal::readOGR(".", "tl_2015_25_cousub")

# Download and extract some night lights data to a directory "night-lights":
downloadNightLights(years = 1999:2000, directory = "night-lights")

# Uncompress the downloaded night lights data to a directory "night-lights":
untarNightLights(years = 1999:2000, directory = "night-lights")

# By default, the function gets the sum of night lights within the regions:
nl.sums <- extractNightLights(directory = "night-lights", shp)

# You can specificy other statistics to get, e.g. the mean & standard deviation:
nl.mean.sd <- extractNightLights(directory = "night-lights", shp,
                                 stats = c("mean", "sd"))
```

## Example output
If the night lights directory contains the data for years 1999 and 2000 and `stats = "sum"`:

               GEOID       NAME night.lights.1999.sum night.lights.2000.sum
        0 2502328285    Hanover                3613.0                3587.0
        1 2502338855 Marshfield                5726.5                5253.5
        2 2502350145    Norwell                4494.0                4268.5
        3 2502372985    Wareham                5625.5                5338.0
        4 2500300975     Alford                 324.5                 409.0
        5 2500334970      Lenox                2339.5                2661.0
        
## Roadmap
* modify the `extractNightLights()` function. In order to do the calibration, we need to extract all the cells of certain area before calcuating certain statistical results. 
* add inter-calibration function following ***Elvidge et al (2009). Li et al (2013)*** to make a comparable panel data.

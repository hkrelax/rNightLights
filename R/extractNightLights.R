extractNightLights <- function(directory = ".", shp, stats = NULL, years = NULL) {
  require(raster)
  if (!class(shp) %in% c("SpatialPolygons", "SpatialPolygonsDataFrame", 
                         "SpatialPointsDataFrame")) {
    stop(paste("'shp' must be either a SpatialPolygons", 
               "SpatialPolygonsDataFrame or SpatialPointsDataFrame"))
  }
  crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
  shp <- sp::spTransform(shp, sp::CRS(crs))
  orig.dir <- getwd()
  setwd(directory)
  files <- list.files(pattern = "*.tif$")
  all.years <- as.numeric(substr(files, 4, 7))
  double.years <- all.years[duplicated(all.years)]
  if (is.null(years)) {
    years <- sort(unique(all.years))
  }
  if (class(shp) == "SpatialPolygons") {
    df <- data.frame(id = 1:length(shp@polygons))
  }
  else if (class(shp) == "SpatialPolygonsDataFrame") {
    df <- data.frame(shp@data)
  }
  else if (class(shp) == "SpatialPointsDataFrame") {
    df <- data.frame(shp@data)
  }
  for (i in seq_along(years)) {
    if (years[i] %in% double.years) {
      both.files <- grep(years[i], files, value = TRUE)
      
      r1 <- crop(raster(both.files[1]), shp, snap = "out")
      satellite1 <- substr(both.files[1], 1, 3)
      
      cat("Extracting night lights data for satellite ", satellite1, " year ", years[i], "...\n", sep = "")
      # In oreder to do the calibration, instead of calculate centain statistical function,
      # we first extract all the cell value, including the zero ones.
      extract <- raster::extract(r1, shp, method = "simple")
      # All the cells' value within certain region were return as a list.
      df[[paste0("night.lights.", satellite1,".", years[i])]] <- c(extract)
      
      r2 <- crop(raster(both.files[2]), shp, snap = "out")
      satellite2 <- substr(both.files[2], 1, 3)
      
      cat("Extracting night lights data for satellite ", satellite2, " year ", years[i], "...\n", sep = "")
      extract <- raster::extract(r2, shp, method = "simple")
      df[[paste0("night.lights.", satellite2,".", years[i])]] <- c(extract)
      
    }
    else {
      r <- crop(raster(grep(years[i], files, value = TRUE)), 
                shp, snap = "out")
      satellite <- substr(grep(years[i], files, value = TRUE), 1, 3)
      
      cat("Extracting night lights data for satellite ", satellite, " year ", years[i], "...\n", sep = "")
      extract <- raster::extract(r, shp, method = "simple")
      df[[paste0("night.lights.", satellite,".", years[i])]] <- c(extract)
    }
    cat("Done\n")
  }
  setwd(orig.dir)
  return(df)
}
#Impostazione della working directory
setwd("~/Desktop/Università/Telerilevamento") 
getwd() #verifica della working directory
list.files() #lista dei file all'interno della working directory

### Caricamento pacchetti
library(terra)     # Per la gestione di dati raster. 
library(imageRy)   # Gestione, analisi e visualizzazione multiframe di immagini raster
library(ggplot2)   # Creazione di grafici personalizzati
library(patchwork) # Per la combinazione flessibile dei grafici a barre in un'unica interfaccia;
library(viridis)   # Palette di colori ad alta leggibilità
library(ggridges)  # Grafici a cresta per visualizzare distribuzioni continue

# FUNZIONE CHE IN TEORIA DOVREBBE TAGLIARMI L'IMMAGINE ATTORNO AD UNO SHAPEFILE MA NON FUNZIONA
clipCoast <- function(img, boundary){
  img_crop <- crop(img, boundary)
  img_mask <- mask(img_crop, boundary)

  return(img_mask)
  }

#importa raster
pre2019<-rast("Australia_2019_bands.tif")
post2020<-rast("Australia_2020_bands.tif")
post2026<-rast("Australia_2026_bands.tif")
pre2019
post2020
post2026

#mostra layer separati
im.multiframe(3,4)
plot(pre2019[[1]], col = rocket(100), main = "2019, B2")
plot(pre2019[[2]], col = rocket(100), main = "2019, B3")
plot(pre2019[[3]], col = rocket(100), main = "2019, B4")
plot(pre2019[[4]], col = rocket(100), main = "2019, B8")

plot(post2020[[1]], col = rocket(100), main = "2020, B2")
plot(post2020[[2]], col = rocket(100), main = "2020, B3")
plot(post2020[[3]], col = rocket(100), main = "2020, B4")
plot(post2020[[4]], col = rocket(100), main = "2020, B8")

plot(post2026[[1]], col = rocket(100), main = "2026, B2")
plot(post2026[[2]], col = rocket(100), main = "2026, B3")
plot(post2026[[3]], col = rocket(100), main = "2026, B4")
plot(post2026[[4]], col = rocket(100), main = "2026, B8")

#visualizzazione a colori naturali
im.multiframe(1,3)
im.plotRGB(pre2019, r=3, g=2, b=1, title="2019")
im.plotRGB(post2020, r=3, g=2, b=1, title="2020")
im.plotRGB(post2026, r=3, g=2, b=1, title="2026")

# nir su red
im.plotRGB(pre2019, r=4, g=2, b=1, title="2019")
im.plotRGB(post2020, r=4, g=2, b=1, title="2020")
im.plotRGB(post2026, r=4, g=2, b=1, title="2026")

#Elimino mare da DVI
coast <- vect("AustraliaCoast.shp")

pre2019 <- clipCoast(pre2019,coast)
pre2020 <- clipCoast(pre2020,coast)
pre2026 <- clipCoast(pre2026,coast)

#DVI
dvi_2019 <- im.dvi(pre2019, 4, 3)
dvi_2020 <- im.dvi(post2020, 4, 3)
dvi_2026 <- im.dvi(post2026, 4, 3)
plot(dvi_2019, col = magma(100), main = "DVI 2019")
plot(dvi_2020, col = magma(100), main = "DVI 2020")
plot(dvi_2026, col = magma(100), main = "DVI 2026")

#NDVI
ndvi_2019 <- im.ndvi(pre2019, 4, 3)
ndvi_2020 <- im.ndvi(post2020, 4, 3)
ndvi_2026 <- im.ndvi(post2026, 4, 3)
plot(ndvi_2019, col = inferno(100), main = "NDVI 2019")
plot(ndvi_2020, col = inferno(100), main = "NDVI 2020")
plot(ndvi_2026, col = inferno(100), main = "NDVI 2026")

#Stack
stack_ndvi <- c(ndvi_2019, ndvi_2020, ndvi_2026) 
names(stack_ndvi) <- c("NDVI 2016", "NDVI 2020", "NDVI 2026")
im.ridgeline(stack_ndvi, scale = 1, palette = "plasma")

#NDVI diff
dev.off()
ndvi_diff1 <- ndvi_2020 - ndvi_2019
ndvi_diff2 <- ndvi_2026 - ndvi_2020
ndvi_diff3 <- ndvi_2026 - ndvi_2019
im.multiframe(1,3)
plot(ndvi_diff1, col = rocket(100), main = "2019 - 2020")
plot(ndvi_diff2, col = rocket(100), main = "2020 - 2026")
plot(ndvi_diff3, col = rocket(100), main = "2019 - 2026")

#CLASSI
class_2019 <- im.classify(ndvi_2019, seed = 42, num_cluster = 4)
class_2020 <- im.classify(ndvi_2020, seed = 42, num_cluster = 4)
class_2026 <- im.classify(ndvi_2026, seed = 42, num_cluster = 4)

f_2016 <- freq(class_2016)
f_2026 <- freq(class_2026)

prop_2016 <- f_2016$count / ncell(class_2016)
prop_2026 <- f_2026$count / ncell(class_2026)

perc_2016 <- prop_2016 * 100
perc_2026 <- prop_2026 * 100

tabella <- data.frame(
  class = c(1, 2, 3),
  P2016 = perc_2016,
  P2025 = perc_2026
)

tabella

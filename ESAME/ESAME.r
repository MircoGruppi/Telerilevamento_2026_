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
pre2018 <- rast("Australia_2018_bands.tif")
post2020 <- rast("Australia_2020_bands.tif")
post2026 <- rast("Australia_2026_bands.tif")
pre2018
post2020
post2026

#mostra layer separati
im.multiframe(3,4)

plot(pre2018[[1]], col = rocket(100), main = "2018, B2")
plot(pre2018[[2]], col = rocket(100), main = "2018, B3")
plot(pre2018[[3]], col = rocket(100), main = "2018, B4")
plot(pre2018[[4]], col = rocket(100), main = "2018, B8")

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

im.plotRGB(pre2018, r=3, g=2, b=1, title = "2018")
im.plotRGB(post2020, r=3, g=2, b=1, title = "2020")
im.plotRGB(post2026, r=3, g=2, b=1, title = "2026")

# nir su red   
im.plotRGB(pre2018, r=4, g=2, b=1, title = "2018")
im.plotRGB(post2020, r=4, g=2, b=1, title = "2020")
im.plotRGB(post2026, r=4, g=2, b=1, title = "2026")
#CAMBIA TITLE CON MAIN


#Elimino mare da DVI   -> NON FUNGE
coast <- vect("AustraliaCosta.shp")

pre2018 <- clipCoast(pre2018,coast)
post2020 <- clipCoast(post2020,coast)
post2026 <- clipCoast(post2026,coast)

#DVI
dvi_2018 <- im.dvi(pre2018, 4, 3)
dvi_2020 <- im.dvi(post2020, 4, 3)
dvi_2026 <- im.dvi(post2026, 4, 3)

plot(dvi_2018, col = magma(100), main = "DVI 2018")
plot(dvi_2020, col = magma(100), main = "DVI 2020")
plot(dvi_2026, col = magma(100), main = "DVI 2026")

#NDVI
ndvi_2018 <- im.ndvi(pre2018, 4, 3)
ndvi_2020 <- im.ndvi(post2020, 4, 3)
ndvi_2026 <- im.ndvi(post2026, 4, 3)

plot(ndvi_2018, col = inferno(100), main = "NDVI 2018")
plot(ndvi_2020, col = inferno(100), main = "NDVI 2020")
plot(ndvi_2026, col = inferno(100), main = "NDVI 2026")

#Stack
stack_ndvi <- c(ndvi_2018, ndvi_2020, ndvi_2026) 
names(stack_ndvi) <- c("NDVI 2018", "NDVI 2020", "NDVI 2026")
im.ridgeline(stack_ndvi, scale = 1, palette = "plasma")

#NDVI diff
dev.off()

ndvi_diff1 <- ndvi_2020 - ndvi_2018
ndvi_diff2 <- ndvi_2026 - ndvi_2020
ndvi_diff3 <- ndvi_2026 - ndvi_2018

im.multiframe(1,3)

plot(ndvi_diff1, col = rocket(100), main = "2018 - 2020")
plot(ndvi_diff2, col = rocket(100), main = "2020 - 2026")
plot(ndvi_diff3, col = rocket(100), main = "2018 - 2026")

#CLASSI
class_2018 <- im.classify(ndvi_2018, seed = 96, num_cluster = 3)
class_2020 <- im.classify(ndvi_2020, seed = 20, num_cluster = 3)
class_2026 <- im.classify(ndvi_2026, seed = 09, num_cluster = 3)

levels(class_2018) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))
levels(class_2020) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))
levels(class_2026) <- data.frame(value = c(1, 2, 3), label = c("Mare", "Vegetazione", "Suolo nudo"))

col_classes <- c("Mare" = "#ffffff","Vegetazione" = "#09622A", "Suolo nudo"="#E8C761")

plot(class_2018, col=col_classes, main="2018", legend=FALSE)
plot(class_2020, col=col_classes, main="2020", legend=FALSE)
plot(class_2026, col=col_classes, main="2026", legend=FALSE)

labels <- c("Vegetazione" = "#09622A", "Suolo nudo"="#E8C761")

legend("bottomleft", 
       legend = names(labels), 
       fill = labels, 
       bg = "white",
       xpd = TRUE)

f_2018 <- freq(class_2018)
f_2020 <- freq(class_2020)
f_2026 <- freq(class_2026)

perc_2018 <- (f_2018$count / ncell(class_2018)) * 100
perc_2020 <- (f_2020$count / ncell(class_2020)) * 100
perc_2026 <- (f_2026$count / ncell(class_2026)) * 100


tabella <- data.frame( 
  class = c("Mare", "Vegetazione", "Suolo nudo"),
  Pre_2018 = perc_2018 ,
  Post_2020 = perc_2020 ,
  Post_2026 = perc_2026 ,
)

tabella
